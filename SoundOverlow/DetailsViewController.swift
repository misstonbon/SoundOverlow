//
//  DetailsViewController.swift
//  SoundOverlow
//
//  Created by Tanja  Stroble on 1/10/18.
//  Copyright © 2018 Tanja  Stroble. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class DetailsViewController: UIViewController {
    
    var concertData: Concert?
    var eventName: String?
    var venueName: String?
    var ticketsURL: String?

    @IBOutlet var eventTitle: UILabel!
    
    @IBAction func toTickets(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
