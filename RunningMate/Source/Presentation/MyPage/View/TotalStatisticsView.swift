//
//  TotalStatisticsView.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/31.
//

import UIKit

class TotalStatisticsView: UIView {
    
    lazy var distanceAndDurationContainer: UIView = {
        let container = UIView()
        container.backgroundColor = Asset.Color.RunningMate
        container.roundCorner(12)
        
        let distanceTitleLabel = UILabel()
        distanceTitleLabel.font = .nanumRound(size: 12, weight: .bold)
        distanceTitleLabel.textColor = .white
        let distanceTitleAttr = NSMutableAttributedString(string: "누적 거리")
        distanceTitleAttr.addImage(Asset.Image.icnFlag.withRenderingMode(.alwaysTemplate).withTintColor(.white), isLeft: true)
        distanceTitleLabel.attributedText = distanceTitleAttr
        let distanceStackView = UIStackView()
        distanceStackView.axis = .vertical
        distanceStackView.alignment = .leading
        distanceStackView.spacing = 8
        distanceStackView.addArrangedSubview(distanceTitleLabel)
        distanceStackView.addArrangedSubview(distanceLabel)
        
        let durationTitleLabel = UILabel()
        durationTitleLabel.font = .nanumRound(size: 12, weight: .bold)
        durationTitleLabel.textColor = .white
        let durationTitleAttr = NSMutableAttributedString(string: "누적 시간")
        durationTitleAttr.addImage(Asset.Image.icnClock.withRenderingMode(.alwaysTemplate).withTintColor(.white), isLeft: true)
        durationTitleLabel.attributedText = durationTitleAttr
        let durationStackView = UIStackView()
        durationStackView.axis = .vertical
        durationStackView.alignment = .leading
        durationStackView.spacing = 8
        durationStackView.addArrangedSubview(durationTitleLabel)
        durationStackView.addArrangedSubview(durationLabel)
        
        container.addSubview(distanceStackView)
        distanceStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.bottom.equalTo(container.snp.centerY).offset(-16)
        }
        
        container.addSubview(durationStackView)
        durationStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(container.snp.centerY).offset(16)
        }
        
        return container
    }()
    
    lazy var paceContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.setGray(243)
        container.roundCorner(12)
        
        let paceTitleLabel = UILabel()
        paceTitleLabel.font = .nanumRound(size: 12, weight: .bold)
        paceTitleLabel.textColor = Asset.Color.RunningMate
        let paceTitleAttr = NSMutableAttributedString(string: "평균 페이스")
        paceTitleAttr.addImage(Asset.Image.icnPace.withRenderingMode(.alwaysTemplate).withTintColor(Asset.Color.RunningMate), isLeft: true)
        paceTitleLabel.attributedText = paceTitleAttr
        
        let paceStackView = UIStackView()
        paceStackView.axis = .vertical
        paceStackView.alignment = .leading
        paceStackView.spacing = 8
        
        paceStackView.addArrangedSubview(paceTitleLabel)
        paceStackView.addArrangedSubview(paceLabel)
        
        container.addSubview(paceStackView)
        paceStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        return container
    }()
    
    lazy var kcalContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.setGray(64)
        container.roundCorner(12)
        
        let kcalTitleLabel = UILabel()
        kcalTitleLabel.font = .nanumRound(size: 12, weight: .bold)
        kcalTitleLabel.textColor = .white
        let kcalTitleAttr = NSMutableAttributedString(string: "누적 칼로리")
        kcalTitleAttr.addImage(Asset.Image.icnFire.withRenderingMode(.alwaysTemplate).withTintColor(.white), isLeft: true)
        kcalTitleLabel.attributedText = kcalTitleAttr
        
        let kcalStackView = UIStackView()
        kcalStackView.axis = .vertical
        kcalStackView.alignment = .leading
        kcalStackView.spacing = 8
        kcalStackView.addArrangedSubview(kcalTitleLabel)
        kcalStackView.addArrangedSubview(kcalLabel)
        
        container.addSubview(kcalStackView)
        kcalStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        return container
    }()
    
    let distanceLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 28, weight: .bold)
        l.textColor = .white
        l.textAlignment = .left
        return l
    }()
    
    let durationLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 28, weight: .bold)
        l.textColor = .white
        l.textAlignment = .left
        return l
    }()
    
    let paceLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 24, weight: .bold)
        l.textColor = Asset.Color.RunningMate
        l.textAlignment = .left
        return l
    }()
    
    let kcalLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 28, weight: .bold)
        l.textColor = .white
        l.textAlignment = .right
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
        self.addSubview(distanceAndDurationContainer)
        distanceAndDurationContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(distanceAndDurationContainer.snp.height)
        }
        
        self.addSubview(paceContainer)
        paceContainer.snp.makeConstraints { make in
            make.left.equalTo(distanceAndDurationContainer.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(distanceAndDurationContainer)
            make.height.equalToSuperview().multipliedBy(0.5).offset(-6)
        }
        
        self.addSubview(kcalContainer)
        kcalContainer.snp.makeConstraints { make in
            make.left.right.equalTo(paceContainer)
            make.bottom.equalTo(distanceAndDurationContainer)
            make.height.equalToSuperview().multipliedBy(0.5).offset(-6)
        }
    }
    
    func bindData(data: RecordStatistics) {
        self.handleDistance(data.distance)
        self.handleDuration(data.duration)
        self.handlePace(data.pace)
        self.handleKcal(data.kcal)
    }
    
    func handleDistance(_ distance: Double) {
        let distanceAttr = NSMutableAttributedString(string: "\(String(format: "%04.2f", distance))")
        distanceAttr.append(NSAttributedString(string: " km", attributes: [.font : UIFont.nanumRound(size: 14, weight: .bold)]))
        self.distanceLabel.attributedText = distanceAttr
    }
    
    func handleDuration(_ duration: Int) {
        let hour = duration / 3600
        let min = (duration / 60) % 60
        let attr = NSMutableAttributedString(string: "\(hour)")
        attr.append(NSAttributedString(string: " hour", attributes: [
            .font: UIFont.nanumRound(size: 14, weight: .bold),
            .foregroundColor : UIColor.white.withAlphaComponent(0.6)
        ]))
        attr.append(NSAttributedString(string: " \(min)"))
        attr.append(NSAttributedString(string: " min", attributes: [
            .font: UIFont.nanumRound(size: 14, weight: .bold),
            .foregroundColor : UIColor.white.withAlphaComponent(0.6)
        ]))
        self.durationLabel.attributedText = attr
    }
    
    func handlePace(_ pace: Double) {
        paceLabel.text = "\(String(format: "%02d", Int(pace)))'\(String(format: "%02d", Int(pace * 100) % 100))\""
    }
    
    func handleKcal(_ kcal: Double) {
        let attr = NSMutableAttributedString(string: "\(Int(kcal))")
        attr.append(NSAttributedString(string: " kcal", attributes: [
            .font : UIFont.nanumRound(size: 14, weight: .bold),
            .foregroundColor : UIColor.white.withAlphaComponent(0.6)
        ]))
        self.kcalLabel.attributedText = attr
    }
}
