//
//  MapView.swift
//  Sample4-OriginalMap
//
//  Created by keiji yamaki on 2021/01/05.
//  地図の画面、地図を操作するには、BindingのmapControlを使用する
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var mapControl: MKMapView?

    var map = MKMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.710063, longitude: 139.8107), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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
            // MAPコントロールを設定
            parent.mapControl = mapView
        }
    }
}
