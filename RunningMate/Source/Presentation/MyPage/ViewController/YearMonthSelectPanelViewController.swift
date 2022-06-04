//
//  YearMonthSelectPanelViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/06/02.
//

import UIKit
import RxSwift

class YearMonthSelectPanelViewController: BasePanelViewController {
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 16, weight: .bold)
        l.textColor = Asset.Color.Black
        l.text = "연월 선택"
        return l
    }()
    
    let yearMonthPicker: YearMonthPicker = {
        let picker = YearMonthPicker()
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        picker.maximumDate = Date()
        return picker
    }()
    
    lazy var okBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .nanumRound(size: 14, weight: .bold)
        btn.setTitle("확인", for: .normal)
        btn.setTitleColor(Asset.Color.Black, for: .normal)
        return btn
    }()
    
    var dateSelectTrigger: PublishSubject<Date>?
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(panelHeight: 240)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        okBtn.rx.tap
            .map{[unowned self] _ in
                return self.yearMonthPicker.date
            }
            .subscribe(onNext: {[weak self] date in
                self?.dismiss(animated: true)
                self?.dateSelectTrigger?.onNext(date)
            })
            .disposed(by: disposeBag)
    }
    
    func setConstraints() {
        
        self.panel.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        }
        
        self.panel.addSubview(yearMonthPicker)
        yearMonthPicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
        }
        
        self.panel.addSubview(okBtn)
        okBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-16)
        }
    }

}
