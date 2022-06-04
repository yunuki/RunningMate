//
//  YearMonthPicker.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/06/01.
//

import UIKit

class YearMonthPicker: UIControl {
    
    var minimumDate: Date? = nil {
        didSet {
            guard let minimumDate = minimumDate,
                  calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending else {return}
            date = minimumDate
        }
    }
    
    var maximumDate: Date? = nil {
        didSet {
            guard let maximumDate = maximumDate,
                  calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending else {return}
            date = maximumDate
        }
    }
    
    var date: Date = Date() {
        didSet {
            if let minimumDate = minimumDate,
               calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending {
                date = calendar.date(from: calendar.dateComponents([.year, .month], from: minimumDate)) ?? minimumDate
            } else if let maximumDate = maximumDate,
                      calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending {
                date = calendar.date(from: calendar.dateComponents([.year, .month], from: maximumDate)) ?? maximumDate
            }
            setDate(date, animated: true)
            sendActions(for: .valueChanged)
        }
    }
    
    enum Component: Int {
        case year
        case month
    }
    
    var calendar: Calendar = Calendar.autoupdatingCurrent
    
    lazy var monthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }()
    
    lazy var yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("y")
        return formatter
    }()
    
    lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    init() {
        super.init(frame: .zero)
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setLocale()
        setDate(date, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocale() {
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        calendar.locale = Locale(identifier: "ko_kr")
        monthDateFormatter.calendar = calendar
        monthDateFormatter.timeZone = calendar.timeZone
        monthDateFormatter.locale = calendar.locale
        yearDateFormatter.calendar = calendar
        yearDateFormatter.timeZone = calendar.timeZone
        yearDateFormatter.locale = calendar.locale
    }
    
    func setDate(_ date: Date, animated: Bool) {
        guard let yearRange = calendar.maximumRange(of: .year),
              let monthRange = calendar.maximumRange(of: .month) else {return}
        let year = calendar.component(.year, from: date) - yearRange.lowerBound
        pickerView.selectRow(year, inComponent: .year, animated: animated)
        let month = calendar.component(.month, from: date) - monthRange.lowerBound
        pickerView.selectRow(month, inComponent: .month, animated: animated)
    }
    
    func isValidDate(_ date: Date) -> Bool {
        if let minimumDate = minimumDate,
            let maximumDate = maximumDate, calendar.compare(minimumDate, to: maximumDate, toGranularity: .month) == .orderedDescending { return true }
        if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending { return false }
        if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending { return false }
        return true
    }
}

extension YearMonthPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        dateComponents.year = value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
        dateComponents.month = value(for: pickerView.selectedRow(inComponent: .month), representing: .month)
        guard let date = calendar.date(from: dateComponents) else {return}
        self.date = date
    }
    
    private func value(for row: Int, representing component: Calendar.Component) -> Int? {
        guard let range = calendar.maximumRange(of: component) else {return nil}
        return row + range.lowerBound
    }
}

extension YearMonthPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let component = Component(rawValue: component) else {return 0}
        
        switch component {
        case .year:
            return calendar.maximumRange(of: .year)?.count ?? 0
        case .month:
            return calendar.maximumRange(of: .month)?.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: traitCollection)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        guard let component = Component(rawValue: component) else { return label }
        var dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)

        switch component {
            case .month:
                dateComponents.month = value(for: row, representing: .month)
                dateComponents.year = value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
            case .year:
                dateComponents.month = value(for: pickerView.selectedRow(inComponent: .month), representing: .month)
                dateComponents.year = value(for: row, representing: .year)
        }

        guard let date = calendar.date(from: dateComponents) else { return label }

        switch component {
            case .month:
                label.text = monthDateFormatter.string(from: date)
            case .year:
                label.text = yearDateFormatter.string(from: date)
        }
        label.textColor = isValidDate(date) ? Asset.Color.Black : UIColor.setGray(159)
        return label
    }
}

extension UIPickerView {
    func selectedRow(inComponent component: YearMonthPicker.Component) -> Int {
        return selectedRow(inComponent: component.rawValue)
    }
    
    func selectRow(_ row: Int, inComponent component: YearMonthPicker.Component, animated: Bool) {
        selectRow(row, inComponent: component.rawValue, animated: animated)
    }
}
