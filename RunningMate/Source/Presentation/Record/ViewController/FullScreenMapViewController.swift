//
//  FullScreenMapViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/06/02.
//

import UIKit
import MapKit

class FullScreenMapViewController: BaseViewController {
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.userTrackingMode = .follow
        return mv
    }()
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func updateUI() {
        super.updateUI()
        self.title = "지도"
    }
    
    override func setConstraints() {
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FullScreenMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        self.mapView.setRegion(region, animated: true)
    }
}
