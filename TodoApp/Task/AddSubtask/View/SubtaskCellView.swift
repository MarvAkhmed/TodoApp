//
//  SubtaskTableViewCell.swift
//  TodoApp
//
//  Created by Marwa Awad on 16.04.2025.
//

import UIKit

class SubtaskCellView: UITableViewCell {
    
    //MARK: - Properties
    public static let identifier = "SubtaskCell"
    private var subtaskViewModel = AddSubtaskViewModel.shared
    
    var lastText: String?
    weak var lastCellEmptyDelegate: LastCellEmptyDelegate?
    
    private var subtaskTitleTextViewHeightConstraints: NSLayoutConstraint!
    //MARK: - UI Components
    ///  Not Editing
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .systemGreen
        label.textColor = .white
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtaskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    /// Editing
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        return textView
    }()
    
    private lazy var deadlinePicker: UIDatePicker = {
        let picker  = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = dateRange.lowerBound
        picker.maximumDate = dateRange.upperBound
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = false
        picker.addTarget(self, action: #selector(didPickTime(_:)), for: .valueChanged)
        return picker
    }()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let now = calendar.date(from: calendar.dateComponents([.year,.month,.day, .hour, .minute, .second], from: Date()))!
        let endDate = calendar.date(byAdding: .year, value: 10, to: now)!
        return now...endDate
    }()
    
    private lazy var setDateSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.addTarget(self, action: #selector(didSelectSwitch), for: .valueChanged)
        return uiSwitch
    }()

    //MARK: - Cell Configuration in both States
    func configureDefault(with subtask: SubtaskModel) {
        setupDefaultUI()
        counterLabel.text = "\(subtask.order)"
        subtaskLabel.text = subtask.title
        subtaskViewModel.updateSubtaskDeadlineIfSwitchOff(subtask.id)
        guard  let timer = subtaskViewModel.getDeadline(for: subtask.id) else  { return }
        let formated = subtaskViewModel.formattedTimeLeft(from: timer)
        timerLabel.text = "\(formated)"
    }
    
     func configureEditable(with subtask: SubtaskModel, switchState: Bool) {
        setupEditableUI()
        initilizeTextView(with: subtask.title)
        setDateSwitch.isOn = switchState
    }
    
    func configure(_ cell: SubtaskCellView, with subtask: SubtaskModel, isEditing: Bool) {
        let switchState =  subtaskViewModel.getSwitchStatus(of: subtask.id)
        isEditing ? configureEditable(with: subtask, switchState: switchState) : configureDefault(with: subtask)
    }

    //MARK: - Setup UI
    private func isDefaultState() -> Bool {
        counterLabel.superview != nil  &&
        subtaskLabel.superview != nil &&
        timerLabel.superview != nil
    }
    
    private func isEditableState() -> Bool {
        setDateSwitch.superview != nil &&
        titleTextView.superview != nil
    }
    
    private func removeDefaultUI() {
        DispatchQueue.main.async { [weak self] in
            guard  let self = self  else { return }
            if self.isDefaultState() { [ self.counterLabel, self.subtaskLabel, self.timerLabel ].forEach { $0?.removeFromSuperview() }  }
        }
    }
    
    private func removeDeadlinePicker() {
        deadlinePicker.removeFromSuperview()
    }
    
    private func removeEditableUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self  else { return }
            if self.isEditableState() {[self.titleTextView, self.setDateSwitch ].forEach { $0.removeFromSuperview()}}
            self.removeDeadlinePicker()
        }
    }
    
    private func deactivateDynamicNotNeededHeights() {
        if subtaskTitleTextViewHeightConstraints != nil {
            subtaskTitleTextViewHeightConstraints.isActive = false
        }
    }
    
    private func setupDefaultUI() {
        contentView.addSubview(counterLabel)
        contentView.addSubview(subtaskLabel)
        contentView.addSubview(timerLabel)
        
        removeEditableUI()
        NSLayoutConstraint.activate([
            counterLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            counterLabel.widthAnchor.constraint(equalToConstant: 28),
            counterLabel.heightAnchor.constraint(equalToConstant: 28),
            
            subtaskLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            subtaskLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 30),
            subtaskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 170),
            timerLabel.bottomAnchor.constraint(equalTo: subtaskLabel.layoutMarginsGuide.topAnchor, constant: -7),
            timerLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        reloadTableView()
    }
    
    private func setupEditableUI() {
        removeDefaultUI()
        contentView.addSubview(titleTextView)
        contentView.addSubview(setDateSwitch)

        lastText = titleTextView.text
        
        deactivateDynamicNotNeededHeights()
        subtaskTitleTextViewHeightConstraints = titleTextView.heightAnchor.constraint(equalToConstant: 40)
       
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: setDateSwitch.leadingAnchor, constant: -8),
            titleTextView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            
            setDateSwitch.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            setDateSwitch.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            setDateSwitch.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
        ])
        guard let indexPath = indexPathInTableView() else { return }
        let subtask = subtaskViewModel.subtasks[indexPath.row]
        let id = subtaskViewModel.getId(of: subtask)
        let switchState = subtaskViewModel.getSwitchStatus(of: id)
        switchEffectOnTheUI(state: switchState)
    }
    
    /// switch view
    private func addDeadlinePickerViewUI() {
        contentView.addSubview(deadlinePicker)
        NSLayoutConstraint.activate([
            deadlinePicker.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            deadlinePicker.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    private func switchEffectOnTheUI(state: Bool)  {
        DispatchQueue.main.async { [weak self] in
            guard let self = self  else { return }
            state ? self.addDeadlinePickerViewUI() : self.removeDeadlinePicker()
        }
    }
    
    /// text view ui
    private func setTextViewPlaceHolder() {
        titleTextView.text = "Subtask... "
        titleTextView.textColor = .lightGray
    }
    
    private func changeSubtaskTitle(_ title: String) {
        titleTextView.text = title
        titleTextView.textColor = UIColor.black
    }
    
    private func initilizeTextView(with title: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if title.isEmpty{
                self.setTextViewPlaceHolder()
                _ = lastCellEmptyDelegate?.isEmptyTextView(text: title)
                _ = lastCellEmptyDelegate?.removeTheLastEmptySubtask()
            } else {
                self.changeSubtaskTitle(title)
            }
        }
    }
}

//MARK: - UITextViewDelegate
extension SubtaskCellView:  UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let isTextViewEmpty = textView.text.isEmpty
        guard let  indexPath = indexPathInTableView() else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self  else { return }
            isTextViewEmpty ? self.setTextViewPlaceHolder() : self.subtaskViewModel.updateSubtaskText(at: indexPath.row, with: textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxCharacterLimit = 100
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxCharacterLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let calculatedHeight = calculateTextViewHeightForCell(of: textView)
        var newHeight: CGFloat?
        DispatchQueue.main.async { [weak self] in
            _ =  self?.lastCellEmptyDelegate?.isEmptyTextView(text: self?.lastText ?? "")
        }
        lastText = textView.text
        
        subtaskTitleTextViewHeightConstraints.constant =  calculatedHeight
        
        guard let indexPath = indexPathInTableView() else { return }
        
        subtaskViewModel.updateSubtaskText(at: indexPath.row, with: textView.text)
        
        let subtask = subtaskViewModel.subtasks[indexPath.row]
        let id = subtaskViewModel.getId(of: subtask)
        DispatchQueue.main.async { [weak self]  in
            newHeight = self?.subtaskViewModel.getSwitchStatus(of: id) ?? false ?  calculatedHeight + 50 :  calculatedHeight + 20
            self?.subtaskViewModel.cacheHeight(for: id, height: newHeight!)
        }
    }
}

//MARK: - Helpers
extension SubtaskCellView {
    func getNumberOfLines(of textView: UITextView) -> CGFloat {
        let fontLineHeight = textView.font?.lineHeight ?? 20
        let width = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: width, height: .leastNonzeroMagnitude))
        let totalHeight = newSize.height
        let numberOfLines = ceil(totalHeight / fontLineHeight)
        return numberOfLines
    }
    
    private func calculateTextViewHeightForCell(of textView: UITextView) -> CGFloat {
        let fontLineHeight = textView.font?.lineHeight ?? 20
        let numberOfLines = getNumberOfLines(of: textView)
        let calculatedHeight = numberOfLines * fontLineHeight
        return calculatedHeight
    }
    
    func calculatePeickerViewHeightForCell(for subtaskId: UUID, isOn: Bool) {
        let baseHeight = calculateTextViewHeightForCell(of: titleTextView)
        let additionalHeight: CGFloat = subtaskViewModel.getSwitchStatus(of: subtaskId) ? 60 : 20
        let totalCellHeight = baseHeight + additionalHeight
        subtaskViewModel.cacheHeight(for: subtaskId, height: totalCellHeight)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            self.findTableView()?.performBatchUpdates (nil)
        }
    }
}

//MARK: - Date Action Selector
extension SubtaskCellView {
    @objc private func didPickTime(_ sender: UIDatePicker) {
        guard let indexPath = indexPathInTableView()else { return }
        let id = subtaskViewModel.getId(at: indexPath.row)
        let selectedDeadline  = sender.date
        subtaskViewModel.handleManualDatePicked(for: id, newDate: selectedDeadline)
    }
    
    //MARK: - Switch Action
    @objc private func didSelectSwitch() {
        guard let indexPath = indexPathInTableView() else { return }
        let id = subtaskViewModel.getId(at: indexPath.row)
        subtaskViewModel.setSwitchStatus(of: id, to: setDateSwitch.isOn)
        let switchState = subtaskViewModel.getSwitchStatus(of: id)
        
        calculatePeickerViewHeightForCell(for: id, isOn: switchState)
        switchEffectOnTheUI(state: switchState)

        
        
    }
}

//MARK: -  Get the tableView and indexPath
extension SubtaskCellView {
    private func findTableView() -> UITableView? {
        var view = superview
        while let superview = view {
            if let tableView = superview as? UITableView {return tableView }
            view = superview.superview
        }
        return nil
    }
    
    private func  indexPathInTableView() -> IndexPath? {
        guard let tableView = findTableView() else { return nil }
        return  tableView.indexPath(for: self)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            self.findTableView()?.reloadData()
        }
    }
}
