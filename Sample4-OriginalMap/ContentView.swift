//
//  ContentView.swift
//  Sample4-OriginalMap
//
//  Created by keiji yamaki on 2021/01/05.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager() // ロケーション
    @State var center_coord = CLLocationCoordinate2D(latitude:35.710063, longitude: 139.8107)
    
    var body: some View {
        MapView(center_coord: $center_coord)
            .onAppear{
                // 現在地を取得
                locationManager.getLocation()
            }
            // 現在地を取得したら、中心を設定
            .onChange(of: locationManager.lastLocation) { newValue in
                center_coord = locationManager.lastLocation!.coordinate
            }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
