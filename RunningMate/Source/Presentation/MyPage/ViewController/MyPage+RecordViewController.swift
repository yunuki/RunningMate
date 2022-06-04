//
//  MyPage+RecordViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class MyPage_RecordViewController: BaseViewController, MyPageChild, IndicatorInfoProvider {
    
    var childScrollView: UIScrollView {
        return self.recordTableView
    }
    
    lazy var recordTableView: UITableView = {
        let tv = UITableView()
        tv.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
        tv.rowHeight = 72
        tv.separatorColor = UIColor.setGray(207)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .clear
        
        return tv
    }()
    
    private let viewModel: MyPage_RecordViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPage_RecordViewModel) {
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
        self.view.addSubview(recordTableView)
        recordTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        
        let fetchFirstPageTrigger = rx.sentMessage(#selector(viewDidLoad))
            .map{_ in}
            .asDriver(onErrorRecover: {_ in Driver.empty()})
        
        let output = self.viewModel.transform(input: MyPage_RecordViewModel.Input(
            fetchFirstPageTrigger: fetchFirstPageTrigger
        ))
        
        output.fetchFirstPageTriggered
            .drive()
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: self.recordTableView.handleLoading(_:))
            .disposed(by: disposeBag)
        
        output.records
            .drive(recordTableView.rx.items(cellIdentifier: RecordTableViewCell.identifier, cellType: RecordTableViewCell.self)) {idx, item, cell in
                cell.bindData(data: item)
            }
            .disposed(by: disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "러닝 기록")
    }
}
