//
//  LocationManager.swift
//  Sample4-OriginalMap
//
//  Created by keiji yamaki on 2021/01/05.
//

import Foundation
import CoreLocation
import Combine

// ロケーションとマップの内部処理
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var firstDataFlag : Bool = true  // 取得したポイントの情報
    var pointData = (p1:CLLocationCoordinate2D(latitude: 0, longitude: 0), p2:CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    @Published var locationStatus: CLAuthorizationStatus? {
         willSet {
             objectWillChange.send() }}
     @Published var lastLocation: CLLocation? {
         willSet {
             objectWillChange.send() }}
     var statusString: String {
         guard let status = locationStatus else {
             return "unknown"
         }
         switch status {
         case .notDetermined: return "notDetermined"
         case .authorizedWhenInUse: return "authorizedWhenInUse"
         case .authorizedAlways: return "authorizedAlways"
         case .restricted: return "restricted"
         case .denied: return "denied"
         default: return "unknown"
         }
     }
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    // 位置情報を取得
    func getLocation() {
        self.locationManager.startUpdatingLocation()
    }
    // 位置情報取得の時の処理
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }
    // 現在地の取得と位置の表示
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        print(#function, location)
        manager.stopUpdatingLocation()  // 現在地の取得終了
    }
}
