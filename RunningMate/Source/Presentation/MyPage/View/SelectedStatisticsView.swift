//
//  SelectedStatisticsView.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/06/01.
//

import UIKit

class SelectedStatisticsView: UIView {
    
    let distanceCompareBarView = CompareBarView()
    let durationCompareBarView = CompareBarView()
    let kcalCompareBarView = CompareBarView()
    let paceCompareBarView = CompareBarView()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.addArrangedSubview(distanceCompareBarView)
        sv.addArrangedSubview(durationCompareBarView)
        sv.addArrangedSubview(kcalCompareBarView)
        sv.addArrangedSubview(paceCompareBarView)
        return sv
    }()
    
    init() {
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = Asset.Color.RunningMate.withAlphaComponent(0.15).cgColor
        self.roundCorner(8)
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindData(total: RecordStatistics, selected: RecordStatistics) {
        distanceCompareBarView.bindData(total: total.distance, selected: selected.distance)
        distanceCompareBarView.totalLabel.text = makeDistanceStr(total.distance)
        distanceCompareBarView.selectedLabel.text = makeDistanceStr(selected.distance)
        
        durationCompareBarView.bindData(total: Double(total.duration), selected: Double(selected.duration))
        durationCompareBarView.totalLabel.text = makeDurationStr(total.duration)
        durationCompareBarView.selectedLabel.text = makeDurationStr(selected.duration)
        
        kcalCompareBarView.bindData(total: total.kcal, selected: selected.kcal)
        kcalCompareBarView.totalLabel.text = makeKcalStr(total.kcal)
        kcalCompareBarView.selectedLabel.text = makeKcalStr(selected.kcal)
        
        paceCompareBarView.bindData(total: total.pace, selected: selected.pace)
        paceCompareBarView.totalLabel.text = makePaceStr(total.pace)
        paceCompareBarView.selectedLabel.text = makePaceStr(selected.pace)
    }
    
    func makeDistanceStr(_ distance: Double) -> String {
        return String(format: "%04.2f", distance)
    }
    
    func makeDurationStr(_ duration: Int) -> String {
        let min = (duration / 60) % 60
        let sec = duration % 60
        return "\(min):\(String(format: "%02d", sec))"
    }
    
    func makeKcalStr(_ kcal: Double) -> String {
        return "\(Int(kcal))"
    }
    
    func makePaceStr(_ pace: Double) -> String {
        return "\(Int(pace))'\(String(format: "%02d", Int(pace * 100) % 100))\""
    }
}
