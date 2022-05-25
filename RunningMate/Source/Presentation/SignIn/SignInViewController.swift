//
//  SignInViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import UIKit
import SnapKit
import AuthenticationServices
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController {
    
    let logoImgView = UIImageView(image: Asset.Image.imgLogoSignIn)
    
    let mentLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 16)
        l.textColor = .white
        l.numberOfLines = 2
        l.text = "당신과 함께 달릴 러닝 메이트,\n지금 바로 만나보세요"
        return l
    }()
    
    lazy var appleSignInBtn: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton()
        btn.addTarget(self, action: #selector(appleSignInBtn(_:)), for: .touchUpInside)
        return btn
    }()
    @objc func appleSignInBtn(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleSignInManager
        controller.presentationContextProvider = appleSignInManager
        controller.performRequests()
    }
    
    lazy var appleSignInManager: AppleSignInManager = {
        let alm = AppleSignInManager()
        alm.setAppleSignInPresentationAnchorView(self)
        alm.delegate = self
        return alm
    }()
    
    private let viewModel: SignInViewModel
    private let disposeBag = DisposeBag()
    private let authCodeSubject = PublishSubject<String>()
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = Asset.Color.RunningMate
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setConstraints() {
        let container = UIView()
        container.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        container.addSubview(mentLabel)
        mentLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImgView.snp.bottom).offset(156)
            make.left.equalToSuperview()
        }
        
        container.addSubview(appleSignInBtn)
        appleSignInBtn.snp.makeConstraints { make in
            make.top.equalTo(mentLabel.snp.bottom).offset(56)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        self.view.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func bindViewModel() {
        
        let viewWillAppear = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map{_ in}
            .asDriver(onErrorRecover: {_ in Driver.empty()})
        
        let output = self.viewModel.transform(input: SignInViewModel.Input(
            viewWillAppear: viewWillAppear,
            authCodeTrigger: authCodeSubject.asDriver(onErrorRecover: {_ in Driver.empty()})
        ))
        
        output.doAuth
            .drive()
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: LoadingIndicator.handleLoading(_:))
            .disposed(by: disposeBag)
    }
}

extension SignInViewController: AppleSignInManagerDelegate {
    func success(authorizationCode: String) {
        authCodeSubject.onNext(authorizationCode)
    }
    
    func fail(error: AppleSignInManager.AppleSignInError) {
        switch error {
        case .authorization:
            print("failed to auth")
        case .decode:
            print("failed to decode authorization code")
        }
    }
}
