//
//  DeadlineSectionCell.swift
//  TodoApp
//
//  Created by Marwa Awad on 27.03.2025.
//

import UIKit

class DeadlineSectionCell: UITableViewCell {
    
    //MARK: - Identifier
    public static var identifier = "DeadlineSectionCell"
    let addTaskViewModel = AddTasksViewModel.shared
    
    //MARK: - UI Components
    lazy var datePicker: UIDatePicker = {
        let picker  = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = dateRange.lowerBound
        picker.maximumDate = dateRange.upperBound
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = false
        return picker
    }()
    
    lazy var timePicker: UIDatePicker = {
        let picker  = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(timePickerChanged(_:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = false
        return picker
    }()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let now = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date()))!
        let endDate = calendar.date(byAdding: .year, value: 10, to: now)!
        return now...endDate
    }()

    //MARK: - Initlizer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func setupUI(picker: UIDatePicker) {
        contentView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            picker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Actions
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        _ = updateTheDeadline(by: sender.date)
    }
    
    @objc private func timePickerChanged(_ sender: UIDatePicker) {
        _ = updateTheDeadline(by: sender.date)
    }
    
    private func updateTheDeadline(by date: Date) -> Date{
        addTaskViewModel.setFinalDate(date)
        addTaskViewModel.setFinalTime(date)
        return date
    }
}
