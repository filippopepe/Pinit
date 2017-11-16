//
//  MapViewController.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 21/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import WatchConnectivity
import CoreData
class MapViewController: UIViewController,CLLocationManagerDelegate , MKMapViewDelegate, WCSessionDelegate{
    var location:LocationMO!
    var lastFoundLocation: CLLocation?
    var session: WCSession?
    
    @IBAction func Save(_ sender: Any) {
        performSegue(withIdentifier: "segueNewPosition", sender: nil)

        
    }
    
    
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations  locations: [CLLocation]){
//        let location = locations[0]
//        
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
//        map.setRegion(region, animated: true)
//        
//        print(location.altitude)
//        print(location.speed)
//        
//        self.map.showsUserLocation = true

        guard let mostRecentLocation = locations.last else { return  }
        updateSessionLocationDetails(location: mostRecentLocation)
        updateWatchTrackerLocation(location: mostRecentLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start our WatchConnectivity Session
        startWatchKitSession()

        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        map.delegate = self
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.removeAnnotations(map.annotations)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saved(segue:UIStoryboardSegue){
        
    }
    
    
    func startWatchKitSession()
    {
        if (WCSession.isSupported())
        {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }


    func updateSessionLocationDetails(location: CLLocation)
    {
        guard let session = session else { return }
        print("iPhone: Set application context: (applicationContext)")
        let data = NSKeyedArchiver.archivedData(withRootObject: location)
        let context = ["lastFoundLocation": data]
        do {
            try session.updateApplicationContext(context)
        } catch {
            print("Update application context failed.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(error)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void)
    {
        let imageData:NSData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "defaultPic"), 0.8)! as NSData
        let value=message["Messaggio"] as! String
        
        print("sto chiamndo l'handler lato iphone")
        print(value)
        
        
        
    //    storeTranscription(letto: value!)\
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            /*SALVATAGGIO DEGLI ELEMENTI NEL DATABASE. VIENE DEFINITA UNA VARIABILE DI TIPO ENTITA' DEL DB (LocatioMO) e i dati vengono inseriti nei rispettivi campi */
            
            location = LocationMO(context: appDelegate.persistentContainer.viewContext)
       
            //location.name = (namePosition.text == "") ? "Default" : namePosition.text
            location.name = "Position \(n)"
            n = n + 1
            location.type = value
            location.lat = (manager.location?.coordinate.latitude)!
            location.long = (manager.location?.coordinate.longitude)!
            location.image = imageData as Data
            print("Salvataggio Dati ....")
            appDelegate.saveContext()
            print("* * * * * * SALVATO * * * * * * \n\n")
 
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = userLocation.coordinate
        region.span = MKCoordinateSpanMake(0.01, 0.01)
        mapView.setRegion(region, animated: true)
    }
    
    func didLocationDistanceChange(updateLocation:CLLocation) -> Bool{
    guard let lastQueredLocation = lastFoundLocation else { return true }
        let distance = lastQueredLocation.distance(from: updateLocation)
    return distance>400
    }
    func updateWatchTrackerLocation(location:CLLocation){
        if didLocationDistanceChange(updateLocation: location) == false {return }
        self.lastFoundLocation = location
        let coordinate = location.coordinate
        addRemoveAnnotations(isAdding:true,coordinate:coordinate)
            manager.allowDeferredLocationUpdates(untilTraveled: 400, timeout: 60)
    }
    
    func addRemoveAnnotations(isAdding:Bool,coordinate:CLLocationCoordinate2D? = nil){
        if isAdding == false {
        let allAnnotation = self.map.annotations
            if allAnnotation.count > 0 {
                self.map.removeAnnotations(allAnnotation)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.startUpdatingLocation()
    }
}
