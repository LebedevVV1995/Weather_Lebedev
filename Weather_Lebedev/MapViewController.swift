//
//  ViewController.swift
//  Weather_Lebedev
//
//  Created by Владимир on 30/06/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class MapViewController: UIViewController, GMSMapViewDelegate{

    var weatherArray = Float()
    
    @IBOutlet weak var mapView: GMSMapView!

    var locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
    }
}

extension MapViewController: CLLocationManagerDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    
            mapView.clear()
        Alamofire.request("https://samples.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=b6907d289e10d714a6e88b30761fae22", method: .get).responseJSON {
            response in
            
            if let result = response.result.value{
                
                let dict:Dictionary = result as! Dictionary<String, Any>
                let innerDict:Dictionary = dict["main"] as! Dictionary <String, Any>
                
                if let weatherArr = innerDict["temp"] as? NSNumber{
                    let dsfd = weatherArr.floatValue
                    self.weatherArray = Float(dsfd)
                }
            }
        }
        //https://samples.openweathermap.org/data/2.5/weather?lat=47.20609674742386&lon=39.619138687849045&appid=b6907d289e10d714a6e88b30761fae22
        let marker = GMSMarker(position: coordinate)
        marker.title = "Sydney"
        marker.snippet = "Температура : \(Int(weatherArray - 273.15)) °C"
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = mapView
        marker.appearAnimation = .pop
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}
