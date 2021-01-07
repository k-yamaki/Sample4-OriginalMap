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
    @State var mapControl: MKMapView?   // 地図のコントロール
    @State var mySpot: MySpot?          // スポットのデータ
    @State var mapViewSize : CGSize?    // 地図画面のサイズ
    @State var areaDragOn = false       // エリア設定のドラッグの有効・無効
    @State var areaRectSize : CGRect?   // エリア設定の四角形
    
    var body: some View {
        VStack {
            Text("エリアを並行に地図を回転\nエリア範囲をドラッグ")
            HStack {
                Spacer()
                Button(action: {
                    // 現在地へ移動
                    locationManager.getLocation()
                }){ Text("現在地へ")}
                Spacer()
                Button(action: {
                    areaDragOn.toggle() // ドラッグのON\OFF
                    if areaDragOn {
                        mySpot = nil
                    }
                    // ドラッグONの時に、地図の移動処理を停止する
                    mapDrag(on: !areaDragOn)
                }){ Text(areaDragOn ? "ドラッグ中" : "ドラッグ開始")}
                Spacer()
                Button(action: {
                    mySpot = nil
                    mapViewSize = nil
                    areaRectSize = nil
                    // ドラッグONの時に、地図の移動処理を停止する
                    mapDrag(on: true)
                }){ Text("クリア")}
                Spacer()
            }.padding()
            ZStack (alignment:.topLeading){ // 画面の起点を左上に設定
                // マップ画面
                GeometryReader{ geometry in
                    MapView(mapControl: $mapControl)
                        .onAppear{
                            // 画面の表示タイミングで、現在地を取得
                            locationManager.getLocation()
                            mapViewSize = geometry.size
                        }
                        // 現在地を取得したら、中心を設定
                        .onChange(of: locationManager.lastLocation) { newValue in
                            // 中心の設定
                            guard let location = locationManager.lastLocation, let mapControl = mapControl else { return }
                            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                            mapControl.setRegion(region, animated: true)
                        }
                        // 四角形をドラッグ
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    if areaDragOn {
                                        areaRectSize = CGRect(origin: value.startLocation, size: CGSize(width:value.translation.width, height:value.translation.height))
                                    }
                                }
                                .onEnded{ value in
                                    if areaDragOn {
                                        guard let mapViewSize = mapViewSize, let mapControl = mapControl else {
                                            return
                                        }
                                        self.areaRectSize = CGRect(origin: value.startLocation, size: CGSize(width:value.translation.width, height:value.translation.height))
                                        mySpot = MySpot(mapControl:mapControl, rect: self.areaRectSize!, height: mapViewSize.height)
                                        areaDragOn = false
                                    }
                            })
                }

                // マップ画面のエリア
                if let areaRectSize = areaRectSize {
                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                        .position(x:areaRectSize.midX, y:areaRectSize.midY)
                        .frame(width:areaRectSize.width, height:areaRectSize.height)
                        .onChange(of: areaRectSize) { newValue in
                        }
                }
                // スポット画面
                if let mySpot = mySpot {
                    Rectangle()
                        .foregroundColor(.red)
                        .opacity(0.2)
                        .position(x:mySpot.spotViewRect.center.x, y:mySpot.spotViewRect.center.y)
                        .frame(width:mySpot.spotViewRect.width, height:mySpot.spotViewRect.height)
                }
            }
        }
    }
    
    // 地図画面のドラッグ機能のON・OFF
    private func mapDrag (on: Bool){
        guard let mapControl = mapControl else {
            return
        }
        mapControl.isScrollEnabled = on //スクロール
        mapControl.isRotateEnabled = on //回転
        mapControl.isZoomEnabled = on//ズーム
        mapControl.isPitchEnabled = on //3D表示
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
