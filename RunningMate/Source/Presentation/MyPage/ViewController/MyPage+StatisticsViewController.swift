//
//  MyPage+StatisticsViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class MyPage_StatisticsViewController: BaseViewController, MyPageChild, IndicatorInfoProvider {
    
    var childScrollView: UIScrollView {
        return statisticsScrollView
    }
    
    lazy var statisticsScrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        return sv
    }()
    
    lazy var totalStatisticsView: TotalStatisticsView = {
        let total = TotalStatisticsView()
        return total
    }()
    
    let yearMonthLabel: UILabel = {
        let l = PaddingLabel(padding: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 0))
        l.font = .nanumRound(size: 24, weight: .bold)
        l.textColor = .black
        l.textAlignment = .left
        return l
    }()
    
    let openYearMonthPickerBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(Asset.Image.btnSettingDate, for: .normal)
        return btn
    }()
    
    let selectedStatisticsView = SelectedStatisticsView()
    
    private let viewModel: MyPage_StatisticsViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPage_StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setConstraints() {
        self.view.addSubview(statisticsScrollView)
        statisticsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        statisticsScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.addArrangedSubview(totalStatisticsView)
        totalStatisticsView.snp.makeConstraints { make in
            make.height.equalTo(CGFloat(188).adjusted)
            make.left.right.equalToSuperview()
        }
        
        let yearMonthContainer = UIView()
        yearMonthContainer.addSubview(yearMonthLabel)
        yearMonthLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        yearMonthContainer.addSubview(openYearMonthPickerBtn)
        openYearMonthPickerBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(yearMonthLabel.snp.right).offset(10)
        }
        stackView.addArrangedSubview(yearMonthContainer)
        yearMonthContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        stackView.addArrangedSubview(selectedStatisticsView)
        selectedStatisticsView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func bindViewModel() {
        
        let viewDidLoad = rx.sentMessage(#selector(viewDidLoad))
            .map{_ in}
            .asDriver(onErrorRecover: {_ in Driver.empty()})
        
        let output = self.viewModel.transform(input: MyPage_StatisticsViewModel.Input(
            viewDidLoad: viewDidLoad,
            openYearMonthPickerTrigger: openYearMonthPickerBtn.rx.tap.asDriver()
        ))
        
        output.totalAccumulate
            .drive(onNext: totalStatisticsView.bindData(data:))
            .disposed(by: disposeBag)
        
        output.openYearMonthPickerTriggered
            .drive()
            .disposed(by: disposeBag)
        
        output.dateSelectTriggered
            .drive()
            .disposed(by: disposeBag)
        
        output.selectedYearMonth
            .drive(onNext: {[weak self] args in
                guard let (year, month) = args else {return}
                self?.yearMonthLabel.text = "\(year)년 \(month)월"
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(
            output.totalAverage,
            output.selectedAverage
        ).drive(onNext: {[weak self] total, selected in
            self?.selectedStatisticsView.bindData(total: total, selected: selected)
        })
        .disposed(by: disposeBag)
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "통계")
    }
}
