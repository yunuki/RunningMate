//
//  RecordViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/13.
//

import UIKit
import RxSwift
import RxCocoa

class RecordViewController: BaseViewController {
    
    let timeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.nanumRound(size: 36, weight: .bold)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        l.text = "00:00:00"
        return l
    }()
    
    let distanceLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.nanumRound(size: 24)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        return l
    }()
    
    let paceLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.nanumRound(size: 24)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        return l
    }()
    
    let endRunningBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("종료", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    private let viewModel: RecordViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: RecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "기록 측정"
        RecordManager.shared.delegate = self
    }
    
    override func setConstraints() {
        self.view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(endRunningBtn)
        endRunningBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let output = self.viewModel.transform(input: RecordViewModel.Input(
            endRunningBtnTapped: endRunningBtn.rx.tap.asDriver()
        ))
        
        output.endRunning
            .drive()
            .disposed(by: disposeBag)
    }
}

extension RecordViewController: RecordManagerDelegate {
    func didDistanceChanged(distance: CGFloat) {
        self.distanceLabel.text = "\(distance)"
    }
    
    func didPaceChanged(pace: CGFloat) {
        self.paceLabel.text = "\(pace)"
    }
    
    func didTimeChanged(time: TimeInterval) {
        let ti = NSInteger(time)
        let hours = ti / 3600
        let minutes = (ti / 60) % 60
        let seconds = ti % 60
        self.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
}
