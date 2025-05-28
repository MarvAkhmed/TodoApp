//
//  SubtaskAddViewController.swift
//  TodoApp
//
//  Created by Marwa Awad on 26.03.2025.
//

import UIKit
import SentencepieceTokenizer
import CoreML

protocol LastCellEmptyDelegate: AnyObject {
    func isEmptyTextView(text: String) -> Bool
    func removeTheLastEmptySubtask()
}

class SubTaskViewController: UIViewController{
    
    //MARK: - Variables
    private var subtasksViewModel =  AddSubtaskViewModel.shared
    var taskTitle: String = ""
    
    //MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubtaskCellView.self, forCellReuseIdentifier: SubtaskCellView.identifier)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let buttonsConfig: ((_ title: String, _ image: UIImage) -> UIButton.Configuration) = { title, image in
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .systemBlue
        configuration.title = title
        configuration.image = image
        return configuration
    }
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let configuration = buttonsConfig("New Subtask", UIImage(systemName: "plus.circle")!)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        button.sizeToFit()
        button.addTarget(self, action: #selector(addNewSubtask), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var aiHelpButton: UIButton = {
        let configuration = buttonsConfig("AI Help", UIImage(systemName: "brain")!)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        button.sizeToFit()
        button.addTarget(self, action: #selector(aiHelpAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeEmptyTextViews()
    }
    
    
    //MARK: - Setup UI & NavigaionBar
    private func configureNavigationBar() {
        updateEditButtonTitle()
        navigationItem.title = "Subtasks"
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(addButton)
        footerView.addSubview(aiHelpButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.heightAnchor.constraint(equalToConstant: 40),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            aiHelpButton.trailingAnchor.constraint(equalTo: footerView.layoutMarginsGuide.trailingAnchor),
            aiHelpButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
            
            addButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
            addButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
        ])
    }
    
    //MARK: -  Actions
    @objc private func didTapNavigationButton() {
        toggleEditingMode()
    }
    
    @objc func addNewSubtask() {
        guard let initialTime =  AddTasksViewModel.shared.getCombinedDateAndTime() else {
            let alert = UIAlertController(title: "Deadline not selected", message: "please fill in the time", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let defaultOrder = subtasksViewModel.subtasks.count + 1
        
        let relatedTaskId = AddTasksViewModel.shared.currentTaskId
        
        let newSubtask = SubtaskModel(taskId: relatedTaskId,
                                      title: "",
                                      order: defaultOrder,
                                      timeLeft: initialTime)
        
        subtasksViewModel.addSubtask(subtask: newSubtask)
        updateEditButtonTitle()
        scrollToLastSubtask()
        toggleIfNeeded()
    }
    
    @objc func aiHelpAction() {
        do {
            try feedTheModel(by: taskTitle)
        } catch {
            //            print("Error occurred while trying to feed the model: \(error)")
        }
    }
    
    private func encodeTheTitle(title: String) throws -> [Int] {
        guard let modelPath = Bundle.main.path(forResource: "spiece", ofType: "model") else {
            throw NSError(domain: "TokenizerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "spiece.model not found"])
        }
        let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)
        let tokens = try tokenizer.encode(title)
        print("Encoded tokens: \(tokens)")
        return tokens
    }
    
    private func padTokens(_ tokens: [Int], toLength length: Int = 16) -> [Int] {
        var padded = tokens
        if padded.count > length {
            padded = Array(padded.prefix(length))
        } else if padded.count < length {
            padded.append(contentsOf: Array(repeating: 0, count: length - padded.count))
        }
        return padded
    }
    
    
    private func convertToMLMultiArray(from tokens: [Int]) throws -> MLMultiArray {
        let shape = [1, NSNumber(value: tokens.count)]
        let multiArray = try MLMultiArray(shape: shape, dataType: .float32)
        
        for (index, token) in tokens.enumerated() {
            multiArray[[0, NSNumber(value: index)]] = NSNumber(value: token)
        }
        print("multiArray: \(multiArray)")
        return multiArray
    }
    
    private func prepareInput(inputIds: MLMultiArray, decoderInput: MLMultiArray) throws -> FlanT5FineTunedInput {
        let inputs = FlanT5FineTunedInput(input_ids: inputIds, decoder_input_ids: decoderInput)
        print("inputs: \(inputs)")
        try predict(inputs: inputs)
        return inputs
    }
    
    private func feedTheModel(by taskTitle: String) throws {
        do {
            let token =  try encodeTheTitle(title: taskTitle)
            let trimmedToken =  padTokens(token)
            let inputIds = try convertToMLMultiArray(from: trimmedToken)
            let decoderInput = try convertToMLMultiArray(from: [1])
            _ = try prepareInput(inputIds: inputIds, decoderInput: decoderInput)
            
        }
    }
    
    private func predict(inputs: FlanT5FineTunedInput) throws {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuOnly
        let model = try FlanT5FineTuned(configuration: config)
        let prediction = try model.prediction(input: inputs)

        if let logits = prediction.featureValue(for: "var_2257")?.multiArrayValue {
            print("Raw logits shape: \(logits.shape)")
            print("Raw logits values (first 10):")

            // Get logits buffer as Float32 array
            let floatPointer = UnsafeMutablePointer<Float32>(OpaquePointer(logits.dataPointer))
            let buffer = UnsafeBufferPointer(start: floatPointer, count: logits.count)
            let firstTen = buffer.prefix(10)
            print(Array(firstTen))

            // Assuming logits shape = [batch_size, seq_len, vocab_size]
            // Here batch_size = 1, seq_len = 1 (from your example), vocab_size = 32128
            // Get predicted token by argmax of last dimension (vocab dimension)

            let vocabSize = logits.shape[2].intValue
            var predictedTokenIds = [Int]()

            // For each token position in seq_len (probably 1 here)
            for i in 0..<logits.shape[1].intValue {
                var maxScore: Float32 = -Float.greatestFiniteMagnitude
                var maxIndex = 0

                for j in 0..<vocabSize {
                    // index calculation in MLMultiArray is flattened row-major
                    // index = i * vocabSize + j (for 2D logits), here logits is 3D (batch, seq_len, vocab)
                    // So total index in flat array is: i * vocabSize + j, since batch=1
                    let index = i * vocabSize + j
                    let score = buffer[index]
                    if score > maxScore {
                        maxScore = score
                        maxIndex = j
                    }
                }
                predictedTokenIds.append(maxIndex)
            }

            print("Predicted token IDs: \(predictedTokenIds)")

            // Now decode predicted tokens back to string using Sentencepiece tokenizer
            guard let modelPath = Bundle.main.path(forResource: "spiece", ofType: "model") else {
                print("⚠️ spiece.model not found")
                return
            }
            do {
                let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)
                let decodedText = try tokenizer.decode(predictedTokenIds)
                print("Decoded output text: \(decodedText)")
            } catch {
                print("Error decoding tokens: \(error)")
            }

        } else {
            print("⚠️ Could not get output 'var_2257'")
        }
    }

}
//MARK: - UITableViewDataSource & UITableViewDelegate
extension SubTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasksViewModel.getSubtasksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubtaskCellView.identifier, for: indexPath) as? SubtaskCellView else { return UITableViewCell() }
        let subtask = subtasksViewModel.subtasks[indexPath.row]
        let isEditing = tableView.isEditing
        cell.configure(cell, with: subtask, isEditing: isEditing)
        cell.backgroundColor = .clear
        cell.lastCellEmptyDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var subtasks = subtasksViewModel.subtasks
        let movedSubtask = subtasks.remove(at: sourceIndexPath.row)
        subtasks.insert(movedSubtask, at: destinationIndexPath.row)
        subtasksViewModel.subtasks = subtasks
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let id = subtasksViewModel.getId(at: indexPath.row)
        return tableView.isEditing ? subtasksViewModel.getCachedHeight(for: id) : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.subtasksViewModel.subtasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - Helper methods for the UI Updates & cell configs
extension SubTaskViewController {
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func updateEditButtonTitle() {
        let title = tableView.isEditing ? "Save" : "Edit"
        
        let navigationButton = UIBarButtonItem(title: title,
                                               style: .done,
                                               target: self,
                                               action: #selector(didTapNavigationButton))
        
        navigationItem.rightBarButtonItem = navigationButton
        reloadTableView()
    }
    
    
    private func scrollToLastSubtask()  {
        view.endEditing(true)
        reloadTableView()
        let lastElement = subtasksViewModel.subtasks.count - 1
        let lastIndexPath = IndexPath(row: lastElement, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    private func toggleIfNeeded() {
        if !tableView.isEditing {
            toggleEditingMode()
        }
    }
    
    private func toggleEditingMode() {
        tableView.isEditing.toggle()
        updateEditButtonTitle()
        reloadTableView()
        removeTheLastEmptySubtask()
    }
    
    
}

//MARK: - Check if the last index is emtpy to delete it and to disable the add button
extension SubTaskViewController: LastCellEmptyDelegate {
    func isEmptyTextView(text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let isTrimmedEmpty = trimmed.isEmpty
        addButton.isEnabled = !isTrimmedEmpty
        let isButtonEnabled = addButton.isEnabled
        return isButtonEnabled
    }
    
    func removeTheLastEmptySubtask() {
        guard let lastSubtask = subtasksViewModel.subtasks.last else { return }
        if !isEmptyTextView(text: lastSubtask.title) &&
            navigationItem.rightBarButtonItem?.title == "Edit" {
            subtasksViewModel.subtasks.removeLast()
            addButton.isEnabled = true
        }
    }
    
    func removeEmptyTextViews() {
        var emptyIndexPaths = [IndexPath]()
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let emptyTextView =  subtasksViewModel.getSubtaskText(at: row).isEmpty
            guard emptyTextView   else { return }
            let indexPath = IndexPath(row: row, section: 0)
            emptyIndexPaths.append(indexPath)
            subtasksViewModel.subtasks.remove(at: row)
            tableView.deleteRows(at: emptyIndexPaths, with: .automatic)
        }
    }
}
