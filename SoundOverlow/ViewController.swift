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

// Load the dictionary of secret keys from secrets.plist
let jambaseKey = dict!.object(forKey: "JAMBASE_KEY") as! String
let songKickKey = dict!.object(forKey: "SONGKICK_KEY") as! String


///// PARSING JAMBASE JSON  //////

struct ResponseFromJambase: Decodable {
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
    let Address: String?
    let City: String?
    let State: String?
    let StateCode: String?
    let Country: String?
    let CountryCode: String?
    let ZipCode: String?
    let Url: String?
    let Latitude: Double
    let Longitude: Double
}

struct Artist: Decodable {
    let Id: Int
    let Name: String
}

//// PARSING SONGKICK JSON ///

struct ResponseFromSongkick: Decodable {
   let resultsPage: Results
}

struct Results: Decodable {
    let status: String
    let results: AllResults
    let perPage: Int?
    let page: Int
    let totalEntries: Int
    let clientLocation: ClientLocation
}
struct AllResults: Decodable {
    let event: [Events]
}

struct Events: Decodable  {
    let type: String
    let popularity: Double?
    let displayName: String
    let status: String?
    let performance: [Performance]
    let ageRestriction: String?
    let start: Start
    let location: Location
    let uri: String
    let id: Int?
    let venue: VenueInfo
}

struct ClientLocation: Decodable {
    let ip: String?
    let lat: Double?
    let lng: Double?
    let metroAreaId: Int?
}

struct Start: Decodable {
    let datetime: String?
    let time: String?
    let date: String?
}

struct Location: Decodable {
    let city: String
    let lat: Double?
    let lng: Double?
}

struct Performance: Decodable {
    let displayName: String
    let billingIndex: Int?
    let billing: String?
    let artist: ArtistDescription
    let id: Int?
}

struct ArtistDescription: Decodable {
    let displayName: String
    let identifier: [Identifier]
    let uri: String?
    let id: Int?
}

struct Identifier: Decodable {
    let href: String?
    let mbid: String?
}

struct VenueInfo: Decodable {
    let displayName: String
    let lat: Double?
    let lng: Double?
    let metroArea: MetroArea
    let uri: String?
    let id: Int?
}

struct MetroArea: Decodable {
    let displayName: String
    let country: Country
    let uri: String?
    let id: Int?
    let state: State
}

struct Country: Decodable {
    let displayName: String?
}

struct State: Decodable {
    let displayName: String?
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //MAP
    

    @IBOutlet weak var map: MKMapView! // imports map view
    
    let manager = CLLocationManager()  // setting up manager
    
    var currentZip = "98104"
    
    let currentLat = "47.6062"
    let currentLong = "-122.3321"
    
    
    //this functions is called every time user moves
    
    
    
    ////// PARSING JSON FUNC ///////
    
    func processSongkickData(currentLat: String, currentLong: String ) {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let today = dateFormatter.string(from: now)
        print("Today's date:")
        print(today)
        
        let songKickUrl = "http://api.songkick.com/api/3.0/events.json?apikey=\(String(describing: songKickKey))&min_date=\(today)&max_date=\(today)&location=geo:\(currentLat),\(currentLong)"
        
        print("Songkick url: =====================")
        print(songKickUrl)
        
        
        guard let url = URL(string: songKickUrl) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            
            guard let data = data else {return}
            print("Printing songkick data:")
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let test = try JSONDecoder().decode(ResponseFromSongkick.self, from: data)
                
                print("Printing songkick response:")
                print(test)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
        
    }
    
    func processJambaseData (zipCode: String) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let today = dateFormatter.string(from: now)
        
        let jambaseurlString = "http://api.jambase.com/events?zipCode=\(zipCode)&radius=30&startDate=\(today)T00:00:00&endDate=\(today)T23:59:00&page=0&api_key=\(String(describing: jambaseKey))"
        
        print("Jambase URL STRING ---------------------------")
        print(jambaseurlString)
        
        guard let url = URL(string: jambaseurlString) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            
            guard let data = data else {return}
            print("Printing jambase  data:")
            print(String(data: data, encoding: .utf8)!)
            // print(data)  /// prints bytes again :(
            
            do {
                let test = try JSONDecoder().decode(ResponseFromJambase.self, from: data)
                
                print("Printing jambase Info:")
                print(test)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //////   CURRENT LOCATION /////
        
        let location = locations[0]  // most recent location

        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.08, 0.08)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)  //sets region based on location and span
        
        map.setRegion(region, animated: true)  // shows blue dot blinking
        
        self.map.showsUserLocation = true // shows blue dot
        

        ////// GEOCODER - REVERSE LOOKUP TO GET ZIPCODE /////
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in //placemark keeps track of all addresses in location and extracts
            if error != nil {
                print("There was an Geocoder Error!")
                print(error!)
            }
            else {
                if let place = placemark?[0] { // most recent placemark
                    if self.currentZip != place.postalCode! {
                        self.currentZip = place.postalCode!
                        
                        print(self.currentZip)   // force unwrap to avoid warning
                        self.processJambaseData(zipCode: self.currentZip)
                        let stringLat = "\(location.coordinate.latitude)"
                        let stringLong = "\(location.coordinate.longitude)"
                        print("Printing String lat and long =========================== from Geodecoder ")
                        print(stringLat)
                        print(stringLong)
                        self.processSongkickData(currentLat: stringLat, currentLong: stringLong)
                    }
                }
            }
        }
        
    }
    
//////////// VIEW DID LOAD ////////////
    
    override func viewDidLoad()
    {
        super.viewDidLoad()   // xcode version of document ready
        
        self.processJambaseData(zipCode: self.currentZip)
        self.processSongkickData(currentLat: self.currentLat, currentLong: currentLong)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest  // accuracy
        manager.requestWhenInUseAuthorization()   // user has to agree to use data when using app
        manager.startUpdatingLocation()  // updates location constantly
    }
    
    
}

