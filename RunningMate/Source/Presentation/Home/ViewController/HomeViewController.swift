//
//  HomeViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    let logoImgView = UIImageView(image: Asset.Image.imgLogo)
    
    let greetingLabelSmall: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 16)
        l.textColor = Asset.Color.Black
        l.textAlignment = .left
        l.text = "\(UserManager.shared.getUserSnapShot()?.nickname ?? "")님, 반가워요!"
        return l
    }()
    
    let greetingLabelBig: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 24, weight: .extraBold)
        l.textColor = Asset.Color.Black
        l.textAlignment = .left
        l.numberOfLines = 2
        l.text = "오늘은 가볍게\n공원 한바퀴 어떤가요?"
        return l
    }()
    
    lazy var characterImgView: UIImageView = {
        return UIImageView(image: Asset.Image.imgCharacter1)
    }()
    
    let characterBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = Asset.Color.RunningMate.withAlphaComponent(0.2)
        return v
    }()
    
    let startRunningBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.nanumRound(size: 20, weight: .extraBold)
        btn.setTitle("러닝 시작", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(Asset.Color.Black, for: .normal)
        return btn
    }()
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startRunningBtn.circleCorner()
    }
    
    override func setConstraints() {
        
        self.view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-6)
            make.left.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(characterBackgroundView)
        characterBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(120)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(CGFloat(260).adjusted)
        }
        characterBackgroundView.roundCorner(CGFloat(260).adjusted/2)
        
        self.view.addSubview(characterImgView)
        characterImgView.snp.makeConstraints { make in
            make.center.equalTo(characterBackgroundView)
        }
        
        self.view.addSubview(greetingLabelSmall)
        greetingLabelSmall.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(44)
            make.left.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(greetingLabelBig)
        greetingLabelBig.snp.makeConstraints { make in
            make.top.equalTo(greetingLabelSmall.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(startRunningBtn)
        startRunningBtn.snp.makeConstraints { make in
            make.top.equalTo(characterBackgroundView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(56)
        }
    }
    
    func bindViewModel() {
        let output = self.viewModel.transform(input: HomeViewModel.Input(
            startRunningBtnTapped: startRunningBtn.rx.tap.asDriver()
        ))
        
        output.pushRecordVC
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func initNavigationBar() {
        self.navigationController?.initNavigationBar(
            navigationItem: navigationItem,
            rightButtonImages: [Asset.Image.icnMyPage],
            rightActions: [#selector(pushMyPageVC(_:))])
    }
    @objc func pushMyPageVC(_ sender: Any) {
        let vc = MyPageViewController(viewModel: MyPageViewModel(navigator: MyPageNavigator(navigationController: self.navigationController)))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
