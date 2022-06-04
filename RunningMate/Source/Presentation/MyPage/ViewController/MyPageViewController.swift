//
//  MyPageViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

protocol MyPageChild {
    var childScrollView: UIScrollView {get}
}

class MyPageViewController: ButtonBarPagerTabStripViewController {
    
    lazy var outerScrollView: OuterScrollView = {
        let sv = OuterScrollView()
        sv.childScrollView = (self.viewControllers[currentIndex] as! MyPageChild).childScrollView
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 0
        return sv
    }()
    
    lazy var headerContainer: UIView = {
        let headerContainer = UIView()
        headerContainer.backgroundColor = UIColor.setGray(243)
        headerContainer.addSubview(characterImgView)
        characterImgView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        headerContainer.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImgView.snp.bottom).offset(-24)
            make.left.equalToSuperview().offset(24)
        }
        headerContainer.addSubview(typeStackView)
        typeStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.bottom.equalToSuperview().offset(-24)
        }
        return headerContainer
    }()
    
    var headerHeight: CGFloat {
        return headerContainer.frame.height
    }
    
    lazy var characterImgView: UIImageView = {
        return UIImageView(image: Asset.Image.imgCharacter1)
    }()
    
    lazy var typeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        func makeLabel() -> UILabel {
            let l = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
            l.font = .nanumRound(size: 12, weight: .bold)
            l.textColor = .white
            l.backgroundColor = Asset.Color.RunningMate
            return l
        }
        for _ in 0..<3 {
            sv.addArrangedSubview(makeLabel())
        }
        let l2 = UILabel()
        l2.font = .nanumRound(size: 16, weight: .bold)
        l2.textColor = Asset.Color.Black
        l2.textAlignment = .left
        l2.text = "달리는 러너"
        sv.addArrangedSubview(l2)
        return sv
    }()
    
    lazy var typeDic: [String:String] = {
        var dic: [String:String] = [:]
        dic["DAY"] = "#낮에"
        dic["NIGHT"] = "#밤에"
        dic["INSIDE"] = "#안에서"
        dic["OUTSIDE"] = "#밖에서"
        dic["FAST"] = "#빨리"
        dic["SLOW"] = "#천천히"
        return dic
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 18, weight: .bold)
        l.textColor = Asset.Color.Black
        l.textAlignment = .left
        return l
    }()
    
    let dotIndicator: UIView = {
        let v = UIView()
        v.backgroundColor = Asset.Color.RunningMate
        v.snp.makeConstraints { make in
            make.width.height.equalTo(4)
        }
        v.roundCorner(2)
        return v
    }()
    
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    private var observation: NSKeyValueObservation?
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setPager()
        super.viewDidLoad()
        updateUI()
        setConstraints()
        self.observation = addObserver()
        self.navigationController?.initNaviBarWithBackButton()
    }
    
    deinit {
        self.observation?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.snp.updateConstraints { make in
            make.height.equalTo(outerScrollView.frame.height - buttonBarView.frame.height)
        }
    }
    
    func setPager() {
        settings.style.buttonBarItemFont = .nanumRound(size: 16)
        settings.style.buttonBarItemTitleColor = Asset.Color.Black
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarItemLeftRightMargin = 16
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.selectedBarHeight = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) in
            oldCell?.label.font = .nanumRound(size: 16)
            newCell?.label.font = .nanumRound(size: 16, weight: .bold)
            
            guard let `self` = self else {return}
            newCell?.contentView.addSubview(self.dotIndicator)
            self.dotIndicator.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-16)
            }
        }
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        guard indexWasChanged else {return}
        self.outerScrollView.childScrollView = (viewControllers[toIndex] as! MyPageChild).childScrollView
        if outerScrollView.contentOffset.y < self.headerHeight {
            outerScrollView.childScrollView?.setContentOffset(.zero, animated: false)
        }
    }
    
    func updateUI() {
        self.view.backgroundColor = .white
        self.title = "마이페이지"
    }
    
    func setConstraints() {
        stackView.addArrangedSubview(headerContainer)
        stackView.addArrangedSubview(buttonBarView)
        buttonBarView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        stackView.addArrangedSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        
        outerScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(outerScrollView)
        outerScrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }

    func bindViewModel() {
        
        let output = self.viewModel.transform(input: MyPageViewModel.Input(
        
        ))
        
        output.user
            .drive(onNext: {[weak self] user in
                self?.nameLabel.text = user.nickname
                self?.typeStackView.isHidden = user.group == nil
                if let groupType = user.group?.type {
                    self?.handleGroupType(groupType)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func handleGroupType(_ type: Group.GroupType) {
        let split = type.rawValue.split(separator: "_").map{String($0)}
        split.enumerated().forEach({idx, typeStr in
            (typeStackView.arrangedSubviews[idx] as? UILabel)?.text = typeDic[typeStr]
        })
    }
    
    func addObserver() -> NSKeyValueObservation {
        return outerScrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] scrollView, change in
            guard let `self` = self,
                  let childScrollView = self.outerScrollView.childScrollView else {return}
            guard change.newValue != change.oldValue,
                  let offsetY = change.newValue?.y else {return}
            
            let maxOffsetY = self.headerHeight
            
            self.outerScrollView.bounces = offsetY < 1
            childScrollView.bounces = offsetY >= maxOffsetY
            
            let scrollDown = self.outerScrollView.panGestureRecognizer.translation(in: self.outerScrollView).y < 0
            if scrollDown {
                childScrollView.contentOffset.y = max(offsetY - maxOffsetY, 0.0)
            } else {
                if childScrollView.contentOffset.y > 0.0 {
                    self.outerScrollView.contentOffset.y = maxOffsetY
                }
            }
        })
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [
            MyPage_RecordViewController(
                viewModel: MyPage_RecordViewModel(
                    useCase: DefaultRecordUseCase(
                        repository: DefaultRecordRepository(
                            recordNetwork: NetworkProvider.shared.makeRecordNetwork()
                        )
                    )
                )
            ),
            MyPage_StatisticsViewController(
                viewModel: MyPage_StatisticsViewModel(
                    useCase: DefaultRecordStatisticsUseCase(
                        repository: DefaultRecordStatisticsRepository(
                            network: NetworkProvider.shared.makeRecordStatisticsNetwork()
                        )
                    ), navigator: MyPage_StatisticsNavigator(navigationController: self.navigationController)
                )
            )
        ]
    }
}
