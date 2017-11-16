//
//  InterfaceController.swift
//  ApplicationW2 WatchKit Extension
//
//  Ceated by Vincenzo Cimmino on 21/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation
import WatchConnectivity
import MapKit

class InterfaceController: WKInterfaceController ,CLLocationManagerDelegate, WCSessionDelegate{
    var valoreDaInviare:String = "☕️"
    var session: WCSession?
    // Instantiate our location Manager class
    let manager = CLLocationManager()
    // variabile che contiene l'ultima posizione registrata e aggiornata nel tempo
    var lastFoundLocation: CLLocation?
    //var di appoggio per l'ultima posizione salvata registrata al momento della pressione del tasto
    var savedLocation:CLLocation?
    
    @IBOutlet var save: WKInterfaceButton!
    @IBOutlet var fourth: WKInterfaceButton!
    @IBOutlet var third: WKInterfaceButton!
    @IBOutlet var second: WKInterfaceButton!
    @IBOutlet var fist: WKInterfaceButton!
    @IBOutlet var mapView: WKInterfaceMap!
 
    @IBAction func saveLocationAction() {
        savedLocation = lastFoundLocation
        //lat e long
        print("entrato")
            var messageToSend=["Messaggio":valoreDaInviare]
        print(messageToSend["Messaggio"] as Any)
        self.session?.sendMessage(messageToSend, replyHandler:{
            (replayMessage) in
                let value=replayMessage["Message"] as? String
                DispatchQueue.main.async {
                        print("handler su watch")
                        print("iphone ha ricevuto")
                        print(value as Any)
                }}
            , errorHandler: { (error) in }
        )
        fist.setBackgroundColor(.blue)
        second.setBackgroundColor(.black)
        third.setBackgroundColor(.black)
        fourth.setBackgroundColor(.black)
        //save.setBackgroundColor(.black)
        let action = WKAlertAction(title: "OK", style: .default,handler: {})
        self.presentAlert(withTitle: "POSITION\nADDED!", message: nil, preferredStyle: .alert, actions: [action])
    }
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        startWatchKitSession()
        self.mapView.removeAllAnnotations()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        fist.setBackgroundColor(.blue)
        second.setBackgroundColor(.black)
        third.setBackgroundColor(.black)
        fourth.setBackgroundColor(.black)
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        startWatchKitSession()
        let authorizationStatus = CLLocationManager.authorizationStatus()
        handleLocationServicesAuthorizationStatus(status: authorizationStatus)
        if let lastUpdateLocation = lastFoundLocation {
            queryWatchTrackerForLocation(location: lastUpdateLocation)
        }
        fist.setBackgroundColor(.blue)
        second.setBackgroundColor(.black)
        third.setBackgroundColor(.black)
        fourth.setBackgroundColor(.black)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func handleLocationServicesAuthorizationStatus(status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted,.denied:
            print("Locations Disabled\n\n Enable Location for This App in Setting In your iPhone")
        case .authorizedAlways,.authorizedWhenInUse:
            manager.requestLocation()
        }
    }
    
    func didLocationDistanceChange(updateLocation: CLLocation)-> Bool {
        guard let lastUpdateLocation = lastFoundLocation  else { return true }
        let distance = lastUpdateLocation.distance(from: updateLocation)
        return distance>400
    }

    func queryWatchTrackerForLocation(location: CLLocation){
        if didLocationDistanceChange(updateLocation: location) == false{
            return
        }
        print(" WatchKit Current Location has Been Changed")
        lastFoundLocation = location
        let coordinate = location.coordinate
        mapView.addAnnotation(coordinate, with:WKInterfaceMapPinColor.green)
    }
    
    func startWatchKitSession(){
        if(WCSession.isSupported()){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("ActiovationDidCompleteWith actiovationState: \(activationState) error: \(String(describing: error))")
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let data = applicationContext["lastFoundLocation"] as? NSData
            else { return  }
        guard let location = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? CLLocation else { return  }
        queryWatchTrackerForLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let region : MKCoordinateRegion
        let _ : CLLocationCoordinate2D
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        guard let mostRecentLocation = locations.last else {return}
        queryWatchTrackerForLocation(location: mostRecentLocation)
        var myLocation:CLLocationCoordinate2D
        myLocation = CLLocationCoordinate2DMake(mostRecentLocation.coordinate.latitude, mostRecentLocation.coordinate.longitude)
        region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region)
        mapView.addAnnotation(myLocation, with: WKInterfaceMapPinColor.red)
    }
    
    @IBAction func First() {
        valoreDaInviare = "☕️"
        fist.setBackgroundColor(.blue)
        second.setBackgroundColor(.black)
        third.setBackgroundColor(.black)
        fourth.setBackgroundColor(.black)
        
    }
    
    @IBAction func Second() {
        valoreDaInviare = "🛍"
        fist.setBackgroundColor(.black)
        second.setBackgroundColor(.blue)
        third.setBackgroundColor(.black)
        fourth.setBackgroundColor(.black)
    }
    
    @IBAction func Third() {
        valoreDaInviare = "🌄"
        fist.setBackgroundColor(.black)
        second.setBackgroundColor(.black)
        third.setBackgroundColor(.blue)
        fourth.setBackgroundColor(.black)
    }
    
    @IBAction func Fourth() {
        valoreDaInviare = "🗽"
        fist.setBackgroundColor(.black)
        second.setBackgroundColor(.black)
        third.setBackgroundColor(.black)
        fourth.setBackgroundColor(.blue)
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager error.")
    }
}
