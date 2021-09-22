//
//  DetailsViewController.swift
//  Lab Test 2 App
//
//  Created by Omairys Uzcátegui on 2021-09-17.
//

import UIKit
import CoreLocation
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelLatitude: UILabel!
    @IBOutlet weak var labelLongitud: UILabel!
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var titleText = ""
    var subtitleText = "No Category"
    
    var managedObjectContext: NSManagedObjectContext!
    var currentLocation : Location?{
        didSet {
          if let location = currentLocation {
              titleText = location.title!
              subtitleText = location.subtitle!
              coordinate = CLLocationCoordinate2DMake(
              location.latitude, location.longitude)
          }
        }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil,
                                               using:
            {
                (notification: Notification) in
                if let updatedCurrentLocation = notification.userInfo?[NSUpdatedObjectsKey] as? Set<Location> {
                    self.currentLocation = updatedCurrentLocation.first
                    self.setUIValues()
                }
            })
        setUIValues()
                
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                  object: nil)
    }
    
    func setUIValues() {
        labelTitle.text = "Title: "+titleText
        labelSubTitle.text = "Subtitle: "+subtitleText
        labelLatitude.text = "Latitud: "+String(format: "%.8f", coordinate.latitude)
        labelLongitud.text = "Longitud: "+String(format: "%.8f", coordinate.longitude)
    }

    @IBAction func edit(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let destinationVC = navigationController.viewControllers[0] as! EditViewController
        destinationVC.managedObjectContext = self.managedObjectContext
        destinationVC.currentLocation = self.currentLocation
    }
    
    @IBAction func deleteLocation(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Location",
                                                message: "Are you sure you want to delete this Location?",
                                                preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            (_) -> Void in

            self.managedObjectContext.delete(self.currentLocation!)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                self.managedObjectContext.rollback()
                print("Something went wrong: \(error)")
            }
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
