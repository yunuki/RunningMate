//
//  SignUpViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/16.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    let nicknameLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 16, weight: .bold)
        l.textColor = UIColor.setGray(64)
        l.text = "닉네임"
        return l
    }()
    
    let essential: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 12, weight: .bold)
        l.textColor = Asset.Color.RunningMate
        l.text = "필수"
        return l
    }()
    
    lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .nanumRound(size: 12, weight: .bold)
        tf.placeholder = "닉네임을 입력해주세요 (\(self.viewModel.minNicknameLength)-\(self.viewModel.maxNicknameLength)자)"
        tf.textColor = Asset.Color.Black
        tf.borderStyle = .none
        tf.delegate = self
        return tf
    }()
    
    let isNicknameValidLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 12, weight: .bold)
        return l
    }()
    
    let saveBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .nanumRound(size: 20, weight: .extraBold)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("완료", for: .normal)
        btn.setBackgroundColor(UIColor.setGray(207), for: .normal)
        return btn
    }()
    
    private let viewModel: SignUpViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내 정보 수정"
    }
    
    override func setConstraints() {
        self.view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(48)
            make.left.equalToSuperview().offset(24)
        }
        
        self.view.addSubview(essential)
        essential.snp.makeConstraints { make in
            make.bottom.equalTo(nicknameLabel)
            make.left.equalTo(nicknameLabel.snp.right).offset(4)
        }
        
        self.view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
        }
        let underline = UIView()
        underline.backgroundColor = UIColor.setGray(207)
        self.view.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.left.right.equalTo(nicknameTextField)
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        self.view.addSubview(isNicknameValidLabel)
        isNicknameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(underline.snp.bottom).offset(4)
            make.left.equalTo(underline)
        }
        
        self.view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }

    func bindViewModel() {
        let output = self.viewModel.transform(input: SignUpViewModel.Input(
            nickname: nicknameTextField.rx.text.asDriver(),
            saveBtnTapped: saveBtn.rx.tap.asDriver()
        ))
        
        output.isNicknameValid
            .drive(onNext: {[weak self] isValid in
                self?.isNicknameValidLabel.text = "사용 \(isValid ? "가능" : "불가")한 닉네임입니다"
                self?.isNicknameValidLabel.textColor = isValid ? Asset.Color.RunningMate : Asset.Color.Red
                self?.saveBtn.setBackgroundColor(isValid ? Asset.Color.RunningMate : UIColor.setGray(207), for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.save
            .drive()
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nicknameTextField.resignFirstResponder()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        let newLength = text.count + string.count - range.length
        return newLength <= self.viewModel.maxNicknameLength
    }
}
