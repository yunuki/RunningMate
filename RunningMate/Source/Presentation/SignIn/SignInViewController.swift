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
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setConstraints() {
        self.view.addSubview(appleSignInBtn)
        appleSignInBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(300)
            make.height.equalTo(80)
        }
    }
    
    func bindViewModel() {
        
        let viewDidLoad = rx.sentMessage(#selector(viewDidLoad))
            .map{_ in}
            .asDriver(onErrorRecover: {_ in Driver.empty()})
        
        let output = self.viewModel.transform(input: SignInViewModel.Input(
            viewDidLoad: viewDidLoad,
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
