//
//  RecordTableViewCell.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/29.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    static var identifier: String {
        return String(describing: RecordTableViewCell.self)
    }
    
    let characterImgView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.setGray(159)
        return img
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 12)
        l.textColor = UIColor.setGray(159)
        l.textAlignment = .left
        return l
    }()
    
    let distanceLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 20, weight: .bold)
        l.textColor = UIColor.setGray(64)
        l.textAlignment = .left
        return l
    }()
    
    let kcalLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 20, weight: .bold)
        l.textColor = UIColor.setGray(64)
        l.textAlignment = .left
        return l
    }()
    
    let paceLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 14)
        l.textColor = UIColor.setGray(64)
        l.textAlignment = .right
        return l
    }()
    
    let durationLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 14)
        l.textColor = UIColor.setGray(64)
        l.textAlignment = .right
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        self.contentView.addSubview(characterImgView)
        characterImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        characterImgView.roundCorner(25)
        
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImgView)
            make.left.equalTo(characterImgView.snp.right).offset(16)
        }
        
        self.contentView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(characterImgView)
            make.left.equalTo(characterImgView.snp.right).offset(16)
        }
        
        self.contentView.addSubview(kcalLabel)
        kcalLabel.snp.makeConstraints { make in
            make.left.equalTo(distanceLabel.snp.right).offset(12)
            make.centerY.equalTo(distanceLabel)
        }
        
        self.contentView.addSubview(paceLabel)
        paceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.centerY).offset(-2)
            make.right.equalToSuperview().offset(-32)
        }
        
        self.contentView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY).offset(2)
            make.left.equalTo(paceLabel)
        }
    }
    
    func bindData(data: Record) {
        self.dateLabel.text = Date.generateDate(rawDate: data.createdAt)
        let distanceAttr = NSMutableAttributedString(string: "\(String(format: "%04.2f", data.distance))")
        distanceAttr.append(NSAttributedString(string: " km", attributes: [.font : UIFont.nanumRound(size: 12)]))
        self.distanceLabel.attributedText = distanceAttr
        let kcalAttr = NSMutableAttributedString(string: "\(Int(data.kcal))")
        kcalAttr.append(NSAttributedString(string: " kcal", attributes: [.font : UIFont.nanumRound(size: 12)]))
        self.kcalLabel.attributedText = kcalAttr
        let paceAttr = NSMutableAttributedString(string: "\(String(format: "%02d", Int(data.pace)))'\(String(format: "%02d", Int(data.pace * 100) % 100))\"")
        paceAttr.addImage(Asset.Image.icnPace, isLeft: true)
        self.paceLabel.attributedText = paceAttr
        let timeAttr = NSMutableAttributedString(string: "\(String(format: "%02d", data.duration / 60 % 60)):\(String(format: "%02d", data.duration % 60))")
        timeAttr.addImage(Asset.Image.icnClock, isLeft: true)
        self.durationLabel.attributedText = timeAttr
    }
}
