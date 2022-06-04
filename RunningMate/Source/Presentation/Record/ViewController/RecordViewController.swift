//
//  RecordViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/13.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class RecordViewController: BaseViewController {
    
    let characterBackground: UIView = {
        let v = UIView()
        v.backgroundColor = Asset.Color.RunningMate.withAlphaComponent(0.2)
        return v
    }()
    
    lazy var characterImgView: UIImageView = {
        return UIImageView(image: Asset.Image.imgCharacter1.resizeImage(to: CGSize(width: 240, height: 240)))
    }()
    
    let timeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.nanumRound(size: 36, weight: .bold)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        l.text = "00:00:00"
        return l
    }()
    
    lazy var recordStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = 0
        
        let bg = UIView()
        bg.backgroundColor = UIColor.setGray(243)
        sv.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bg.roundCorner(12)
        
        let distanceView = makeRecordView(rLabel: distanceLabel, mLabel: makeMeasureLabel("km"))
        let kcalView = makeRecordView(rLabel: kcalLabel, mLabel: makeMeasureLabel("kcal"))
        let paceView = makeRecordView(rLabel: paceLabel, mLabel: makeMeasureLabel("pace"))
        
        sv.addArrangedSubview(distanceView)
        sv.addArrangedSubview(kcalView)
        sv.addArrangedSubview(paceView)
        return sv
    }()
    
    func makeRecordLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.font = UIFont.nanumRound(size: 24, weight: .bold)
        l.textColor = Asset.Color.Black
        l.textAlignment = .center
        l.text = text
        return l
    }
    
    func makeMeasureLabel(_ measure: String) -> UILabel {
        let l = UILabel()
        l.font = UIFont.nanumRound(size: 14, weight: .bold)
        l.textColor = Asset.Color.RunningMate
        l.textAlignment = .center
        l.text = measure
        return l
    }
    
    func makeRecordView(rLabel: UILabel, mLabel: UILabel) -> UIView {
        let recordView = UIView()
        recordView.addSubview(rLabel)
        rLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        recordView.addSubview(mLabel)
        mLabel.snp.makeConstraints { make in
            make.top.equalTo(rLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return recordView
    }
    
    lazy var distanceLabel: UILabel = {
        return makeRecordLabel("00.00")
    }()
    
    lazy var kcalLabel: UILabel = {
        return makeRecordLabel("000")
    }()
    
    lazy var paceLabel: UILabel = {
        return makeRecordLabel("00'00\"")
    }()
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.userTrackingMode = .follow
        mv.addGestureRecognizer(mapViewTapGesture)
        return mv
    }()
    let mapViewTapGesture = UITapGestureRecognizer()
    
    let pauseOrResumeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(Asset.Image.btnPause, for: .normal)
        return btn
    }()
    
    let pausedView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.isUserInteractionEnabled = false
        v.backgroundColor = Asset.Color.Black.withAlphaComponent(0.2)
        return v
    }()
    
    let endRunningBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .nanumRound(size: 16, weight: .bold)
        btn.setImage(Asset.Image.icnStop, for: .normal)
        btn.setTitle("종료", for: .normal)
        btn.setTitleColor(UIColor.setGray(64), for: .normal)
        btn.setBackgroundColor(.white, for: .normal)
        btn.titleEdgeInsets.right = -4
        btn.imageEdgeInsets.left = -4
        return btn
    }()
    private var locationManager: CLLocationManager!
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
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func updateUI() {
        super.updateUI()
        self.title = "기록 측정"
    }
    
    override func setConstraints() {
        self.view.addSubview(characterBackground)
        characterBackground.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        characterBackground.roundCorner(100)
        
        self.view.addSubview(characterImgView)
        characterImgView.snp.makeConstraints { make in
            make.center.equalTo(characterBackground)
        }
        
        self.view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(characterBackground.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(recordStackView)
        recordStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(88)
        }
        
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(recordStackView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-70)
        }
        
        self.view.addSubview(pausedView)
        pausedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let btnContainer = UIView()
        btnContainer.backgroundColor = Asset.Color.RunningMate
        
        btnContainer.addSubview(pauseOrResumeBtn)
        pauseOrResumeBtn.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(56)
        }
        pauseOrResumeBtn.roundCorner(28)
        
        btnContainer.addSubview(endRunningBtn)
        endRunningBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.bottom.equalToSuperview().offset(-8)
            make.left.equalTo(pauseOrResumeBtn.snp.right).offset(12)
            make.width.equalTo(116)
            make.height.equalTo(56)
        }
        endRunningBtn.roundCorner(28)
        
        self.view.addSubview(btnContainer)
        btnContainer.snp.makeConstraints { make in
            make.centerY.equalTo(mapView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        btnContainer.roundCorner(36)
    }
    
    func bindViewModel() {
        
        let viewDidLoad = rx.sentMessage(#selector(viewDidLoad))
            .map{_ in}
            .asDriver(onErrorRecover: {_ in Driver.empty()})
        
        let output = self.viewModel.transform(input: RecordViewModel.Input(
            viewDidLoad: viewDidLoad,
            pauseOrResumeBtnTapped: pauseOrResumeBtn.rx.tap.asDriver(),
            mapViewTapped: mapViewTapGesture.rx.event.map{_ in}.asDriver(onErrorRecover: {_ in Driver.empty()}),
            endRunningBtnTapped: endRunningBtn.rx.tap.asDriver()
        ))
        
        output.startRunning
            .drive()
            .disposed(by: disposeBag)
        
        output.time
            .drive(onNext: {[weak self] time in
                let ti = NSInteger(time)
                let hours = ti / 3600
                let minutes = (ti / 60) % 60
                let seconds = ti % 60
                self?.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            })
            .disposed(by: disposeBag)
        
        output.distance
            .map{"\(String(format: "%05.2f", $0))"}
            .drive(distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.kcal
            .map{"\(String(format: "%03d", Int($0)))"}
            .drive(kcalLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.pace
            .map({ pace -> String in
                let integer = Int(pace)
                let float = Int(pace * 100) % 100
                return "\(String(format: "%02d", integer))'\(String(format: "%02d", float))\""
            })
            .drive(paceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isPaused
            .drive(onNext: {[weak self] isPaused in
                let img = isPaused ? Asset.Image.btnResume : Asset.Image.btnPause
                self?.pauseOrResumeBtn.setImage(img, for: .normal)
                self?.pausedView.isHidden = !isPaused
                self?.recordStackView.arrangedSubviews.enumerated()
                    .filter{$0.0 == 1}
                    .forEach{$0.1.isHidden = !isPaused}
            })
            .disposed(by: disposeBag)
        
        output.pauseOrResumeRunning
            .drive()
            .disposed(by: disposeBag)
        
        output.pushFullScreenMapVC
            .drive()
            .disposed(by: disposeBag)
        
        output.endRunning
            .drive()
            .disposed(by: disposeBag)
    }
}

extension RecordViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        self.mapView.setRegion(region, animated: true)
    }
}
