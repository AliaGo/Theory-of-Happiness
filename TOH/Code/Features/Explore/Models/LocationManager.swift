//
//  LocationManager.swift
//  TOH
//
//  Created by Alia on 2025/2/26.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            checkLocationAuthorization()
            manager!.delegate = self
            manager!.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("show an alert")
        }
    }
    
    func checkLocationAuthorization() {
        guard let manager = manager else { return }
        
        //manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied. Go into your setting to change it.")
            
        case .authorizedAlways, .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
