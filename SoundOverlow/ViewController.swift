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

let path = Bundle.main.path(forResource: "secrets", ofType: "plist")
let dict = NSDictionary(contentsOfFile: path!)

// Load secrets

let jambaseKey = dict!.object(forKey: "JAMBASE_KEY") as! String
// Load the dictionary of secret keys from secrets.plist


///// PARSING JSON  //////

struct ResponseFromJson: Decodable {
    let Info: Info
    let Events: [Event]
}

struct Info: Decodable {
   let TotalResults: Int
   let PageNumber: Int
   let Message: String?
}

struct Event: Decodable {
    let Id: Int
    let Date: String
    let Venue: Venue
    let Artists: [Artist]
    let TicketUrl: String
}

struct Venue: Decodable {
    let Id: Int
    let Name: String
    let Address: String
    let City: String
    let State: String
    let StateCode: String
    let Country: String
    let CountryCode: String
    let ZipCode: String
    let Eventurl: String
    let Latitude: Double
    let Longitude: Double
}

struct Artist: Decodable {
    let Id: Int
    let Name: String
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //MAP
    

    @IBOutlet weak var map: MKMapView! // imports map view
    
    let manager = CLLocationManager()  // setting up manager
    
    //this functions is called every time user moves
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        //////   CURRENT LOCATION /////
        
        let location = locations[0]  // most recent location
//        print(location)
//        print("Location above!")
        
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
                    let currentZip = place.postalCode!
                    print(currentZip)   // force unwrap to avoid warning
                }
            }
            
        }
        
    }
    
//////////// VIEW DID LOAD ////////////
    
    override func viewDidLoad()
    {
        super.viewDidLoad()   // xcode version of document ready
        
        //////////     URL SETUP FOR THE API CALL ////////
        
        let currentZip:String = "98104"
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let today = dateFormatter.string(from: now)
        print(today)
        
        print("Today's date above")
        
        
        let jsonurlString = "http://api.jambase.com/events?zipCode=\(currentZip)&radius=30&startDate=\(today)T00:00:00&endDate=\(today)T23:59:00&page=0&api_key=\(String(describing: jambaseKey))"
        
            print("JSON URL STRING ---------------------------")
        
        print(jsonurlString)
    
        
        guard let url = URL(string: jsonurlString) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
        
            guard let data = data else {return}
            print("Printing data:")
            print(String(data: data, encoding: .utf8)!)
           // print(data)  /// prints bytes again :(
            
            do {
                let test = try JSONDecoder().decode(Info.self, from: data)
                print("Printing Info:")
                print(test)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest  // accuracy
        manager.requestWhenInUseAuthorization()   // user has to agree to use data when using app
        manager.startUpdatingLocation()  // updates location constantly
    }
    
    
}

