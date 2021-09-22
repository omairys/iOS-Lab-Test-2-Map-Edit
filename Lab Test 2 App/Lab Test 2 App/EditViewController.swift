//
//  EditViewController.swift
//  Lab Test 2 App
//
//  Created by Omairys Uzcátegui on 2021-09-18.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputSubTitle: UITextField!
    @IBOutlet weak var inputLatitude: UITextField!
    @IBOutlet weak var inputLongitud: UITextField!
    var managedObjectContext: NSManagedObjectContext!
    
    var currentLocation : Location?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.currentLocation = self.currentLocation ?? NSEntityDescription.insertNewObject(forEntityName: "Location",
                                                            into: self.managedObjectContext) as! Location
        
        setUIValues()
        
    }
    
    func setUIValues() {
        guard
            let currentTitle = self.currentLocation?.title,
            let currentSubTitle = self.currentLocation?.subtitle,
            let currentLatitude = self.currentLocation?.latitude,
            let currentLongitud = self.currentLocation?.longitude else {
                return
            }
        
        self.inputName.text = currentTitle
        self.inputSubTitle.text = currentSubTitle
        self.inputLatitude.text = String(currentLatitude)
        self.inputLongitud.text = String(currentLongitud)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard
            let title = self.inputName.text,
            let subtitle = self.inputSubTitle.text,
            let latitud = self.inputLatitude.text,
            let longitud = self.inputLongitud.text else {
                return
            }
        
        if title.isEmpty || subtitle.isEmpty || latitud.isEmpty || longitud.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "All fields are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }else{
            currentLocation!.title = title
            currentLocation!.subtitle = subtitle
            currentLocation!.latitude = Double(latitud)!
            currentLocation!.longitude = Double(longitud)!
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }

            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
