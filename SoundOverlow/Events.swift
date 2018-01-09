//
//  Events.swift
//  SoundOverlow
//
//  Created by Tanja  Stroble on 1/5/18.
//  Copyright © 2018 Tanja  Stroble. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook

class Concert: NSObject, MKAnnotation
{
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init() // inherits from Object , must be called
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
