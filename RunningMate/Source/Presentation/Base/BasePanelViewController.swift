//
//  BasePanelViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import UIKit

class BasePanelViewController: UIViewController {
    
    let panel: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.roundCorner(24)
        return v
    }()
    
    lazy var dismissBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        return btn
    }()
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private let panelHeight: CGFloat
    
    init(panelHeight: CGFloat) {
        self.panelHeight = panelHeight
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.setGray(27).withAlphaComponent(0.2)
        self.view.addSubview(panel)
        panel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(panelHeight + self.view.safeAreaInsets.bottom)
        }
        
        self.view.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(panel.snp.top)
        }
    }
}
