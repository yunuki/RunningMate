//
//  RecordStartViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/24.
//

import UIKit

class RecordStartViewController: BasePanelViewController {
    
    enum DayOrNight {
        case day, night
        
        var title: String {
            switch self {
            case .day:
                return "낮"
            case .night:
                return "밤"
            }
        }
    }
    
    enum InsideOrOutside {
        case inside, outside
        
        var title: String {
            switch self {
            case .inside:
                return "실내"
            case .outside:
                return "실외"
            }
        }
    }
    
    let dayOrNightLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 16, weight: .bold)
        l.textColor = .black
        l.text = "⏰ 지금 시간은"
        l.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return l
    }()
    
    lazy var dayOrNight: UISegmentedControl = {
        let sc = UISegmentedControl(items: dayOrNightItems.map{$0.title})
        sc.selectedSegmentTintColor = Asset.Color.RunningMate
        sc.addTarget(self, action: #selector(dayOrNightIndexChanged(_:)), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        self.selectedDayOrNight = dayOrNightItems[0]
        return sc
    }()
    @objc func dayOrNightIndexChanged(_ sender: UISegmentedControl) {
        self.selectedDayOrNight = self.dayOrNightItems[sender.selectedSegmentIndex]
    }
    
    let insideOrOutsideLabel: UILabel = {
        let l = UILabel()
        l.font = .nanumRound(size: 16, weight: .bold)
        l.textColor = .black
        l.text = "⛳️ 러닝 장소는"
        l.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return l
    }()
    
    lazy var insideOrOutside: UISegmentedControl = {
        let sc = UISegmentedControl(items: insideOrOutsideItems.map{$0.title})
        sc.selectedSegmentTintColor = Asset.Color.RunningMate
        sc.addTarget(self, action: #selector(insideOrOutsideIndexChanged(_:)), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        self.selectedInsideOrOutside = insideOrOutsideItems[0]
        return sc
    }()
    @objc func insideOrOutsideIndexChanged(_ sender: UISegmentedControl) {
        self.selectedInsideOrOutside = self.insideOrOutsideItems[sender.selectedSegmentIndex]
    }
    
    lazy var runningStartBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .nanumRound(size: 20, weight: .extraBold)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("러닝 시작", for: .normal)
        btn.setBackgroundColor(Asset.Color.Black, for: .normal)
        btn.addTarget(self, action: #selector(runningStartBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()
    @objc func runningStartBtnTapped(_ sender: UIButton) {
        guard let dayOrNight = self.selectedDayOrNight,
              let insideOrOutside = self.selectedInsideOrOutside else {return}
        let nav = UINavigationController()
        nav.modalPresentationStyle = .fullScreen
        let vc = RecordViewController(viewModel: RecordViewModel(dayOrNight: dayOrNight, insideOrOutside: insideOrOutside, navigator: RecordNavigator(navigationController: nav)))
        nav.pushViewController(vc, animated: false)
        self.dismiss(animated: true)
        self.presentingViewController?.present(nav, animated: true)
    }
    
    private let dayOrNightItems: [DayOrNight] = [.day, .night]
    private var selectedDayOrNight: DayOrNight?
    private let insideOrOutsideItems: [InsideOrOutside] = [.outside, .inside]
    private var selectedInsideOrOutside: InsideOrOutside?
    
    init() {
        super.init(panelHeight: 320)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    
    func setConstraints() {
        self.panel.addSubview(dayOrNightLabel)
        dayOrNightLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.left.equalToSuperview().offset(36)
        }
        
        self.panel.addSubview(dayOrNight)
        dayOrNight.snp.makeConstraints { make in
            make.left.equalTo(dayOrNightLabel.snp.right).offset(36)
            make.centerY.equalTo(dayOrNightLabel)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(48)
        }
        
        self.panel.addSubview(insideOrOutsideLabel)
        insideOrOutsideLabel.snp.makeConstraints { make in
            make.top.equalTo(dayOrNightLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(36)
        }
        
        self.panel.addSubview(insideOrOutside)
        insideOrOutside.snp.makeConstraints { make in
            make.left.equalTo(insideOrOutsideLabel.snp.right).offset(36)
            make.centerY.equalTo(insideOrOutsideLabel)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(48)
        }
        
        self.panel.addSubview(runningStartBtn)
        runningStartBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(insideOrOutside.snp.bottom).offset(54)
            make.width.equalTo(180)
            make.height.equalTo(56)
        }
        runningStartBtn.roundCorner(28)
    }
}
