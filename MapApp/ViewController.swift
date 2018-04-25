//
//  ViewController.swift
//  MapApp
//
//  Created by Carey, Brady on 11/15/16.
//  Copyright © 2016 Carey, Brady. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapType: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextField!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        searchText.delegate = self
        searchText.alpha = 0.6 //Make text field transluscent
        // set initial location in Honolulu
        //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    }
    
    override func viewWillAppear(_ animated: Bool) { //Hides nav bar whenever this view appears
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func zoomIn(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 100000, 100000)
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func changeMapType(_ sender: AnyObject) {
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
            mapType.setTitle("Normal", for: UIControlState.normal)
        } else {
            mapView.mapType = MKMapType.standard
            mapType.setTitle("Satellite", for: UIControlState.normal)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func textFieldReturn(_ sender: AnyObject) {
        _ = sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as!
        ResultsTableViewController
        
        destination.mapItems = self.matchingItems
    }
    
    func performSearch() {
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    print("Website = \(item.url)")

                    
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    //let annotation = MKPointAnnotation()
                    let annotation = CustomPinAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    annotation.pinPhone = item.phoneNumber
                    annotation.pinSite = item.url
                    self.mapView.addAnnotation(annotation)
                    
                    let userLocation = self.mapView.userLocation //Zoom in after search
                    let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 4000, 4000)
                    self.mapView.setRegion(region, animated: true)
                    
                }
            }
        })
    }
    
    func showRoute(_ response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            //routeMap.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }

}

