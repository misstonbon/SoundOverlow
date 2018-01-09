////
////  playground.swift
////  SoundOverlow
////
////  Created by Tanja  Stroble on 1/9/18.
////  Copyright © 2018 Tanja  Stroble. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Social
//
//
//// sharing on facebook from button :
//
//@IBAction func buttonAction(_ sender: Any)
//{
//    let alert = UIAlertController(title: "Share", message: "Share", preferredStyle: .actionSheet)
//    let actionOne = UIAlertAction(title: "Share on FB", style: .default) { (action) in
//        ///check if user connected to FB or Twitter :
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
//            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            post?.setInitialText("Excited for tonight's concert!")
//            post?.add(UIImage(named: "logo.png"))
//
//            self.present(post, animated: true, completion: nil)
//
//        } else {
//            // if not connceted to FB
//           self.showAlert(service: "Facebook")
//            }
//        }
//    }
//    /// add action to action sheet
//    alert .addAction(actionOne)
//    // present alert
//    self.present(alert, animated: true, completion: nil)
//}
//
//func showAlert(service: String ) {
//    let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
//    let action = UIAlertAction(title: "Close", style: .cancel, handler: nil)
//    alert.addAction(action)
//    present(alert, animated: true, completion: nil)
//
//
//
//    import UIKit
//    import Social
//
//    class ViewController: UIViewController {
//
//        @IBAction func buttonAction(_ sender: Any)
//        {
//            //Alert
//            let alert = UIAlertController(title: "Share", message: "Share the poem of the day!", preferredStyle: .actionSheet)
//
//            //First action
//            let actionOne = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
//
//                //Checking if user is connected to Facebook
//                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
//                {
//                    let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
//
//                    post.setInitialText("Poem of the day")
//                    post.add(UIImage(named: "img.png"))
//
//                    self.present(post, animated: true, completion: nil)
//
//                } else {self.showAlert(service: "Facebook")}
//            }
//
//            //Second action
//            let actionTwo = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
//
//                //Checking if user is connected to Facebook
//                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
//                {
//                    let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
//
//                    post.setInitialText("Poem of the day")
//                    post.add(UIImage(named: "img.png"))
//
//                    self.present(post, animated: true, completion: nil)
//
//                } else {self.showAlert(service: "Twitter")}
//            }
//
//            let actionThree = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//            //Add action to action sheet
//            alert.addAction(actionOne)
//            alert.addAction(actionTwo)
//            alert.addAction(actionThree)
//
//            //Present alert
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        func showAlert(service:String)
//        {
//            let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
//
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        }
//
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view, typically from a nib.
//        }
//
//        override func didReceiveMemoryWarning() {
//            super.didReceiveMemoryWarning()
//            // Dispose of any resources that can be recreated.
//        }
//
//
//}

