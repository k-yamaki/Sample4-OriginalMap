//
//  MapView.swift
//  Sample4-OriginalMap
//
//  Created by keiji yamaki on 2021/01/05.
//
import SwiftUI
import MapKit
import Combine

struct MySpot {
    var mapRect : CGRect
    var imageOffset : Double
    // 初期処理
    init(mapRect: CGRect, imageOffset: Double){
        self.mapRect = mapRect
        self.imageOffset = imageOffset
    }
    // スポットの中心点をGPSデータで返す
    func getPosition() -> CLLocationCoordinate2D {
        return (CLLocationCoordinate2D(latitude: CLLocationDegrees(mapRect.minY), longitude: CLLocationDegrees(mapRect.minX)))
    }
}
struct MapView: UIViewRepresentable {
    @Binding var center_coord: CLLocationCoordinate2D
    var mySpot = MySpot(mapRect: CGRect(x:139.8107, y:35.710063, width:10, height:10), imageOffset: 0)

    var map = MKMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let region = MKCoordinateRegion(center: center_coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.region = region
        map.userTrackingMode = MKUserTrackingMode.follow
        map.delegate = context.coordinator      // マップ機能
        return map
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
     // ビューの更新時に呼ばれる
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // 中心の設定
        let region = MKCoordinateRegion(center: center_coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

    // ロケーションとマップの内部処理
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
        }
        // MAPのロード前
        func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        }

        // 表示領域の変化の直後
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        }
    }
}
