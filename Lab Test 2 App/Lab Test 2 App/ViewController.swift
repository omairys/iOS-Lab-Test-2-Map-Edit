//
//  ViewController.swift
//  Lab Test 2 App
//
//  Created by Omairys Uzcátegui on 2021-09-14.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController{
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var mapView: MKMapView!
    let addSegueIdentifier = "addSegue"
    let detailsSegueIdentifier = "detailsSegue"
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { notification in
            if self.isViewLoaded {
              self.fetchLocations()
            }
        }
        
        fetchLocations()
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    // MARK:- Private methods
    func fetchLocations() {
      mapView.removeAnnotations(locations)
      let entity = Location.entity()
      let fetchRequest = NSFetchRequest<Location>()
      fetchRequest.entity = entity
      locations = try! managedObjectContext.fetch(fetchRequest)
      mapView.addAnnotations(locations)
    }
    
    
    func showLocations(){
        let theRegion = region(for: locations)
        mapView.setRegion(theRegion, animated: true)
    }
    // MARK: - Navigation
    @objc func showLocationDetails(_ sender: UIButton) {
      performSegue(withIdentifier: detailsSegueIdentifier, sender: sender)
        
    }
    
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegion(
                center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
          
        case 1:
          let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
          
        default:
          var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
          var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)
          
          for annotation in annotations {
            topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
            topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
            bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
            bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
          }
          
          let center = CLLocationCoordinate2D(latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2, longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
          
          let extraSpace = 1.1
          let span = MKCoordinateSpan(latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace, longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
          
          region = MKCoordinateRegion(center: center, span: span)
        }
        
        return mapView.regionThatFits(region)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case addSegueIdentifier:
            guard let navController = segue.destination as? UINavigationController,
            let saveVC = navController.topViewController as? EditViewController else {
                return
            }
            saveVC.managedObjectContext = managedObjectContext
        case detailsSegueIdentifier:
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.managedObjectContext = self.managedObjectContext
            let button = sender as! UIButton
            let location = locations[button.tag]
            destinationVC.currentLocation = location
        default:
                break
            }
    }

}

extension ViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      guard annotation is Location else {
        return nil
      }
      let identifier = "Location"
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      if annotationView == nil {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView.isEnabled = true
        pinView.canShowCallout = true
        pinView.animatesDrop = false
        pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
        pinView.tintColor = UIColor(white: 0.0, alpha: 0.5)
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(self, action: #selector(showLocationDetails), for: .touchUpInside)
        pinView.rightCalloutAccessoryView = rightButton
        annotationView = pinView
      }
      if let annotationView = annotationView {
        annotationView.annotation = annotation
        let button = annotationView.rightCalloutAccessoryView as! UIButton
          if let index = locations.firstIndex(of: annotation as! Location) {
          button.tag = index
        }
      }
      return annotationView
  }
}

