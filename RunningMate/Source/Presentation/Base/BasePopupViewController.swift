//
//  BasePopupViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import UIKit

class BasePopupViewController: UIViewController {
    
    lazy var popupView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.roundCorner(8)
        v.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        return v
    }()
    
    lazy var dismissBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(Asset.Image.btnClose, for: .normal)
        btn.addTarget(self, action: #selector(dismissBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()
    @objc func dismissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.setGray(27).withAlphaComponent(0.2)
    }

    func setConstraints() {
        self.view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
