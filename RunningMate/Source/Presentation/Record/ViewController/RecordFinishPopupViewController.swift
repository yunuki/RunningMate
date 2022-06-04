//
//  RecordFinishPopupViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import UIKit

class RecordFinishPopupViewController: BasePopupViewController {
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 20, weight: .extraBold)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        l.text = "러닝 기록이 저장되었습니다"
        return l
    }()
    
    let descLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 14)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        var attr = NSMutableAttributedString(string: "저장된 기록은 ")
        attr.append(NSAttributedString(string: "마이페이지", attributes: [.foregroundColor : Asset.Color.RunningMate]))
        attr.append(NSAttributedString(string: "에서 확인할 수 있어요"))
        l.attributedText = attr
        return l
    }()
    
    let imgView: UIImageView = UIImageView(image: Asset.Image.imgRecordFinish)

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }

    override func setConstraints() {
        super.setConstraints()
        
        popupView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.centerX.equalToSuperview()
        }
        
        popupView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        popupView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-22)
        }
    }
}
