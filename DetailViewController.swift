//
//  DetailViewController.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 27/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import MobileCoreServices

class DetailViewController: UIViewController,CLLocationManagerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var mappa: MKMapView!
  
    
    @IBOutlet weak var namePosition: UITextField!
    
    @IBOutlet weak var typePosition: UITextField!
    @IBOutlet weak var imagePosition: UIImageView!
    var newPick:Bool?
    var imagePicker: UIImagePickerController! = UIImagePickerController() //Picker per aprire fotocamera

    var location:LocationMO!
    //var locations: [LocationMO] = []

    var before:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        typePosition.text = (location.type?.contains("🀺🀲🀳"))! ? "" : location.type
        namePosition.text = location.name
        
        imagePicker.delegate=self
        if let locationImage = location.image {
            imagePosition.image = UIImage(data:locationImage as Data)
            imagePosition.layer.cornerRadius = 67
            imagePosition.clipsToBounds = true
            }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        before = namePosition.text!
        namePosition.resignFirstResponder()
        namePosition.delegate = self
        typePosition.resignFirstResponder()
        typePosition.delegate = self
        
    }
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations  locations: [CLLocation]){
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.lat, location.long)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mappa.setRegion(region, animated: true)
        mappa.removeAnnotations(mappa.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        mappa.addAnnotation(annotation)
        self.mappa.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Gotolocation(_ sender: Any) {
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(location.lat, location.long)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: options)
    
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        location.name = namePosition.text!
        location.type = typePosition.text!
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namePosition.resignFirstResponder()
        typePosition.resignFirstResponder()
        location.name = namePosition.text!
        location.type = typePosition.text!
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
        
        return true
    }


    @IBAction func photoFromLibrary(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
            
    }
}
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
            let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
            var chosenImage = UIImage()
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imagePosition.contentMode = .scaleAspectFill
            self.imagePosition.image = chosenImage
            self.imagePosition.clipsToBounds=true
            self.dismiss(animated:true, completion: nil)
            self.location.image = UIImageJPEGRepresentation(chosenImage, 0.8)
            appDelegate?.saveContext()
            print("Ktm1")
 
    }
    
    
}





