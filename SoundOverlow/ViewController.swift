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

//////////////////////////////  IMPORTS SECRETS ////////////////////////////////////////////////////////////

let path = Bundle.main.path(forResource: "secrets", ofType: "plist")
let dict = NSDictionary(contentsOfFile: path!)

//////////////////////////////// LOADS SECRETS ////////////////////////////////////////////////////////////

// Load the dictionary of secret keys from secrets.plist

let songKickKey = dict!.object(forKey: "SONGKICK_KEY") as! String

////////////////////////////////// PARSES SONGKICK JSON //////////////////////////////////

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

/////////////////////////////  VIEW CONTROLLER  /////////////////////////////////////////

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
//////////////// MAP /////////////////////////////////////
    
    @IBOutlet weak var map: MKMapView! // imports map view
    
    let manager = CLLocationManager()  // setting up manager
    
    var currentZip = "98104"
    
    let currentLat = "47.6062"
    let currentLong = "-122.3321"
    
    var eventPins = [MKAnnotation]()
    
    var eventPin: Concert?
    
////////////////// SONGKICK JSON PARSING FUNCTION   /////////////////////////////////////
    
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

            do {
                let data = try JSONDecoder().decode(ResponseFromSongkick.self, from: data)
                
                //// ADD PINS //////
                
                if self.eventPins.count > 0 {
                    self.map.removeAnnotations(self.eventPins)
                }
                
                self.eventPins.removeAll()
        
                let events = data.resultsPage.results.event;
                
                for event in events {
                    let eventPin = Concert(title: event.displayName, locationName: event.venue.displayName, coordinate: CLLocationCoordinate2D(latitude: event.location.lat!, longitude: event.location.lng!))
                    
                    self.eventPins.append(eventPin)
                }
                
                // adjust zoom
                self.map.addAnnotations(self.eventPins)
                self.map.showAnnotations(self.eventPins, animated: true)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
      }.resume()
    }

////////////////////////////////////   CURRENT LOCATION ///////////////////////////////////
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations[0]  // most recent location

        self.map.showsUserLocation = true // shows blue dot
        
//////////////////////////////////// GEOCODER - REVERSE ZIPCODE LOOKUP  /////////////////////
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in //placemark keeps track of all addresses in location and extracts
            if error != nil {
                print("There was an Geocoder Error!")
                print(error!)
            }
            else {
                if let place = placemark?[0] { // most recent placemark
                    if self.currentZip != place.postalCode! {
                        self.currentZip = place.postalCode!
                        
                        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
                        
                        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                        
                        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)  //sets region based on location and span
                        
                        self.map.setRegion(region, animated: true)  // shows blue dot blinking
                        
                        let stringLat = "\(location.coordinate.latitude)"
                        let stringLong = "\(location.coordinate.longitude)"
                    
                        self.processSongkickData(currentLat: stringLat, currentLong: stringLong)
                    }
                }
            }
        }
    }
    
////////////////////////////////////////// VIEW DID LOAD /////////////////////////
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.processSongkickData(currentLat: self.currentLat, currentLong: self.currentLong)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest  // accuracy
        manager.requestWhenInUseAuthorization()   // user has to agree to use data when using app
        manager.startUpdatingLocation()  // updates location constantly
        
        // CONFIG MAP
        
        map.delegate = self
        
        // END CONFIG MAP
    }

}

////////////////////////////// SETS UP ANNOTATIONS //////////////////////////////////

extension ViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        // MKAnnotation is a protocol that requires title and subtitle, that's why we have to have both
        
        if let annotation = annotation as? Concert { // using Concert class
            let identifier  = "pin"  // below setup is so that clicking on pins can dequeue current view and queue up the next one 
            var view: MKAnnotationView
            if let dequeuedView =
                mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.image = UIImage(named: "smallestpin")
                view.canShowCallout = true
               // view.animatesDrop = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
//////////////// TAPPING INFO BUTTON CONTROLS ////////////////////////////
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        // this is the event pin containing all data relevant to DetailViewController !
       eventPin = view.annotation as? Concert
        
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
////////////////  LINKS TWO VIEWS VIA SEGUE //////////////////////////////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let destinationViewController = segue.destination as! DetailsViewController
       
            destinationViewController.concertData = eventPin    // passing all pin data to concertData var in DetailsViewController
        }
    }
}

