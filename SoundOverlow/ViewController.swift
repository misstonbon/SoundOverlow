//
//  ViewController.swift
//  SoundOverlow
//
//  Created by Tanja  Stroble on 1/2/18.
//  Copyright © 2018 Tanja  Stroble. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //MAP
    

    @IBOutlet weak var map: MKMapView! // imports map view
    
    let manager = CLLocationManager()  // setting up manager
    
    //this functions is called every time user moves
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]  // most recent location
        print(location)
        print("Location above!")
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.08, 0.08)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)  //sets region based on location and span
        
        map.setRegion(region, animated: true)  // shows blue dot blinking
        
        self.map.showsUserLocation = true // shows blue dot
        
        
        
        ////// GEOCODER - REVERSE LOOKUP TO GET ZIPCODE /////
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in //placemark keeps track of all addresses in location and extracts
            if error != nil {
                print("There was an Error!")
            }
            else {
                if let place = placemark?[0] { // most recent placemark
                    print(place)
                    let currentZip = place.postalCode
                    print(currentZip!)   // force unwrap to avoid warning
                }
            }
        }
        
    }
    
    //////////// VIEW DID LOAD ////////////
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()   // xcode version of document ready 
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest  // accuracy
        manager.requestWhenInUseAuthorization()   // user has to agree to use data when using app
        manager.startUpdatingLocation()  // updates location constantly
    }

/////////// DO NOT DELETE ANYTHING ABOVE THIS //////////////////
    

}

