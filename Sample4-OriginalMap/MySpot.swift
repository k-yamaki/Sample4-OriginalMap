//
//  MySpot.swift
//  Sample4-OriginalMap
//
//  Created by keiji yamaki on 2021/01/07.
//  MySpotのデータ構造、画面のデータ構造のViewRectと地図のデータ構造のMapRectからなる。
//  MySpotViewは、MapViewを拡大した領域。MySpotViewのGPS地点を取得するには、MapViewに変換してGPS地点を取得する。

import SwiftUI
import MapKit

// マイスポットのデータ
struct MySpot {
    var mapControl : MKMapView  // マップのコントロール
    var mapGPSRect : MapRect     // マップGPS領域
    var mapViewRect : ViewRect    // マップView領域
    var spotViewRect : ViewRect   // スポットView領域
    var imageOffset : Double
    
    // 初期処理 マップのコントロールとマップ画面の対角点よりマイスポットを作成する
    init(mapControl: MKMapView, rect: CGRect, height:CGFloat){
        self.mapControl = mapControl
        self.mapViewRect = ViewRect(rect:rect)
        self.mapGPSRect = MapRect(mapControl: mapControl, viewRect: self.mapViewRect)
        self.spotViewRect = ViewRect(srcViewRect: mapViewRect, height: height)
        self.imageOffset = 0.0
    }
}

// 画面の矩形データ
struct ViewRect {
    var p1 : CGPoint
    var p2 : CGPoint
    var p3 : CGPoint
    var p4 : CGPoint
    var center : CGPoint
    var width : CGFloat
    var height : CGFloat
    var radian : Double
    
    // 四角形情報から初期設定：マップView領域を設定する時に使用
    init (rect: CGRect) {
        self.p1 = CGPoint(x:rect.minX, y:rect.minY)
        self.p2 = CGPoint(x:rect.maxX, y:rect.minY)
        self.p3 = CGPoint(x:rect.minX, y:rect.maxY)
        self.p4 = CGPoint(x:rect.maxX, y:rect.maxY)
        self.center = CGPoint(x:rect.midX, y:rect.midY)
        self.width = rect.width
        self.height = rect.height
        self.radian = 0.0
    }
    // 対角線２点と角度から初期設定：マップView領域を設定する時に使用
    init (p1: CGPoint, p4: CGPoint, radian: Double){
        self.height = CGFloat(CGFloat(cos(radian)) * (p4.y-p1.y) - CGFloat(sin(radian)) * (p4.x-p1.x)) / CGFloat(cos(radian)) * CGFloat(sin(radian + Double(CGFloat.pi / 2))) - CGFloat(sin(radian)) * CGFloat(cos(radian + Double(CGFloat.pi/2)))
        self.width = (p4.x - p1.x - CGFloat(height) * CGFloat(cos(radian + Double(CGFloat.pi/2)))) / CGFloat(cos(radian))

        self.p2 = CGPoint(x: p1.x + CGFloat(width) * CGFloat(cos(radian)),
                         y:p1.y + CGFloat(width) * CGFloat(sin(radian)))
        self.p3 = CGPoint(x: p1.x + CGFloat(height) * CGFloat(cos(radian + Double(CGFloat.pi/2))),
                         y: p1.y + CGFloat(height) * CGFloat(sin(radian + Double(CGFloat.pi/2))))
        self.p1 = p1
        self.p4 = p4
        self.center = CGPoint(x: p2.x/2 + p3.x/2, y: p2.y/2 + p3.y/2)
        self.radian = radian
    }
    
    // 元の画面サイズと高さから初期設定：スポットView領域を設定する時に使用
    init (srcViewRect: ViewRect, height:CGFloat){
        self.height = height
        self.width = height * srcViewRect.width / srcViewRect.height
        self.p1 = .zero
        self.p2 = CGPoint(x:width, y:0.0)
        self.p3 = CGPoint(x:0.0, y:height)
        self.p4 = CGPoint(x:width, y:height)
        self.center = CGPoint(x: width/2, y: height/2)
        self.radian = 0.0
    }

}
// MAPの矩形データ
struct MapRect {
    var p1 : CLLocationCoordinate2D
    var p2 : CLLocationCoordinate2D
    var p3 : CLLocationCoordinate2D
    var p4 : CLLocationCoordinate2D
    var width : Double
    var height : Double
    var radian : Double
    
    // マップViewからマップGPSを初期設定：マップGPSを設定する時に使用
    init (mapControl: MKMapView, viewRect: ViewRect){
        self.radian = viewRect.radian
        self.p1 = mapControl.convert(viewRect.p1, toCoordinateFrom: mapControl)
        self.p2 = mapControl.convert(viewRect.p2, toCoordinateFrom: mapControl)
        self.p3 = mapControl.convert(viewRect.p3, toCoordinateFrom: mapControl)
        self.p4 = mapControl.convert(viewRect.p4, toCoordinateFrom: mapControl)
        let p1Loc: CLLocation = CLLocation(latitude: self.p1.latitude, longitude: self.p1.longitude)
        let p2Loc: CLLocation = CLLocation(latitude: self.p2.latitude, longitude: self.p2.longitude)
        let p3Loc: CLLocation = CLLocation(latitude: self.p3.latitude, longitude: self.p3.longitude)
        self.width = p2Loc.distance(from: p1Loc)
        self.height = p3Loc.distance(from: p1Loc)
    }
}
