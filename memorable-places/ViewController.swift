//
//  ViewController.swift
//  memorable-places
//
//  Created by Chanse Campbell on 07/07/2017.
//  Copyright © 2017 Chanse Campbell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    /* Variables */
    @IBOutlet var map: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if activePlace == -1 {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
            // get place details to appear on map
            if places.count > activePlace {
                if let name = places[activePlace]["name"] {
                    if let lat = places[activePlace]["lat"] {
                        if let lng = places[activePlace]["lng"] {
                            if let latitude = Double(lat) {
                                if let longitude = Double(lng) {
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    self.map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    annotation.coordinate = coordinate
                                    annotation.title = name
                                    self.map.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
            }
            
        }

        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region =  MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    
    func longpress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            // converts gesture recognizer info into a coordinate
            let touchPoint = gestureRecognizer.location(in: self.map)
            let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    print(error)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                }
                
                if title == "" {
                    title =  "Added \(NSDate())"
                }

                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
                places.append(["name": title, "lat": String(coordinate.latitude), "lng": String(coordinate.longitude)])
                
                UserDefaults.standard.setValue(places, forKey: "places")
                
            })

        }
        
//        let placesObject = UserDefaults.standard.object(forKey: "places")
//        
//        var places:[MKPointAnnotation]
//        
//        if let tempPlaces = placesObject as? [MKPointAnnotation] {
//            // add content to an existing array
//            places = tempPlaces
//            
//            places.append(annotation)
//        } else {
//            // create a new array
//            places = [annotation]
//        }
//        
//        // save the new or updated array
//        UserDefaults.standard.setValue(places, forKey: "places")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

