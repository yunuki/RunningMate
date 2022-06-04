//
//  CompareBarView.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/06/01.
//

import UIKit

class CompareBarView: UIView {
    
    final let barMaxHeight: CGFloat = 200
    
    let totalBar: UIView = {
        let v = UIView()
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.backgroundColor = Asset.Color.RunningMate.withAlphaComponent(0.2)
        v.roundCorner(4)
        return v
    }()
    
    let totalLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 14, weight: .bold)
        l.textColor = UIColor.setGray(159)
        l.textAlignment = .center
        return l
    }()
    
    let selectedBar: UIView = {
        let v = UIView()
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.backgroundColor = Asset.Color.RunningMate
        v.roundCorner(4)
        return v
    }()
    
    let selectedLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 20, weight: .bold)
        l.textColor = Asset.Color.RunningMate
        l.textAlignment = .center
        return l
    }()

    init() {
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width).multipliedBy(CGFloat(300) / CGFloat(80).adjusted)
        }
        
        self.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(selectedLabel)
        selectedLabel.snp.makeConstraints { make in
            make.bottom.equalTo(totalLabel.snp.top).offset(-8)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(totalBar)
        totalBar.snp.makeConstraints { make in
            make.bottom.equalTo(selectedLabel.snp.top).offset(-16)
            make.left.equalTo(self.snp.centerX).offset(6)
            make.width.equalTo(CGFloat(12).adjusted)
            make.height.equalTo(0)
        }
        
        self.addSubview(selectedBar)
        selectedBar.snp.makeConstraints { make in
            make.bottom.equalTo(selectedLabel.snp.top).offset(-16)
            make.right.equalTo(self.snp.centerX).offset(-6)
            make.width.equalTo(CGFloat(12).adjusted)
            make.height.equalTo(0)
        }
    }
    
    func bindData(total: Double, selected: Double) {
        let totalIsBigger = total > selected
        let ratio = totalIsBigger ? selected / total : total / selected
        totalBar.snp.updateConstraints { make in
            make.height.equalTo(totalIsBigger ? barMaxHeight : barMaxHeight * ratio)
        }
        selectedBar.snp.updateConstraints { make in
            make.height.equalTo(totalIsBigger ? barMaxHeight * ratio : barMaxHeight)
        }
    }
}
