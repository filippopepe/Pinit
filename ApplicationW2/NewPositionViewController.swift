//
//  NewPositionViewController.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 21/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

var n = 0

class NewPositionViewController: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    var posizioni: [NSManagedObject] = []

    @IBOutlet var emoji1: UIButton!
    @IBOutlet var emoji2: UIButton!
    @IBOutlet var emoji3: UIButton!
    @IBOutlet var emoji4: UIButton!

    @IBOutlet weak var namePosition: UITextField! //Textfield per nome posizione
    @IBOutlet weak var map1:MKMapView! //Mappa
    
    @IBOutlet weak var image1: UIImageView! //ImageView per foto scattata 
    

    private var p = -1 //contatore per le priorità
    private var priorityList:[String] = ["☕️"," 🛍","🌄","🗽"] //Array di stringhe per il tipo della posizione
    private var selectedProp: [Bool] = [false,false,false,false]
    private var selectedPic = false
    
    let manager = CLLocationManager()
    
    var imagePicker1: UIImagePickerController! = UIImagePickerController() //Picker per aprire fotocamera
    var location:LocationMO!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabbarconroller?.tabbar.isHidden = true;
        namePosition.delegate = self
        namePosition.resignFirstResponder()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        imagePicker1.delegate = self
        image1.layer.cornerRadius = image1.frame.height / 2
        image1.clipsToBounds = true
        image1.image = UIImage(named: "fotoDefault")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations  locations: [CLLocation]){
        let location = locations[0]
        var myLocation:CLLocationCoordinate2D
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map1.setRegion(region, animated: true)
        self.map1.showsUserLocation = true
        }

/* Azione implementato dal bottone per inserire la foto . Richiama l'imagepicker. Come risorsa tale imagepicker utilizzerà la camera dell'iphone*/
  
    @IBAction func TakeImage1(_ sender: Any) {
        imagePicker1.allowsEditing = true
        imagePicker1.sourceType = .camera
        present(imagePicker1,animated: true, completion: nil)
    }
 
    /*  Funzione che consente all'utente di poter scattare foto utilizzando fotocamera iPhone */

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      
            image1.contentMode = .scaleAspectFit //Gli faccio mantenere la scala per non farla sgranare
            
            image1.image = pickedImage //Assegno la foto selezionata
  
            image1.clipsToBounds = true
            self.selectedPic = true

            dismiss(animated: true, completion: nil)

            
            /* Salvataggio foto selezionata
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil) //Salva in libreria la foto scattata
                */
        }
    }

/*Funzione che fa scomparire il picker una volta che l'utente ha scattato la foto e ha scelto se utilizzare o meno la foto scattata*/
//    
//    func imagePickerController(_ picker: UIImagePickerController) {
//        dismiss(animated : true, completion: nil)
//    }
//    
    
    
/* Funzione che consente di memorizzare la foto scattata direttamente nella libreria dell'iPhone
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    } }*/

        @IBAction func SavePosition(_ sender: Any) {
            let lat = manager.location?.coordinate.latitude
            let long = manager.location?.coordinate.longitude
            let img:UIImage = image1.image!
        
       /* CODIFICA FOTO IN FORMATO NSDATA */
            let imageData:NSData = UIImageJPEGRepresentation(img, 0.8)! as NSData
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
    /*SALVATAGGIO DEGLI ELEMENTI NEL DATABASE. VIENE DEFINITA UNA VARIABILE DI TIPO ENTITA' DEL DB (LocatioMO) e i dati vengono inseriti nei rispettivi campi */
            
                location = LocationMO(context: appDelegate.persistentContainer.viewContext)
                if namePosition.text != "" {
                    location.name = namePosition.text
                } else {
                    location.name = "Position \(n)"
                    n = n + 1
                }
                
                location.type = p != -1 ? priorityList[p] : "🀺🀲🀳"
                location.lat = lat!
                location.long = long!
                location.image = (self.selectedPic) ? imageData as Data : UIImageJPEGRepresentation(#imageLiteral(resourceName: "defaultPic"), 0.8)! as Data 
                print("Salvataggio Dati ....")
                appDelegate.saveContext()
                print("* * * * * * SALVATO * * * * * * \n\n")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namePosition.resignFirstResponder()
        return true
    }

    @IBAction func emoji1(_ sender: Any) {
        self.p = 0
        emoji1.isHighlighted = true
        emoji2.isHighlighted = false
        emoji3.isHighlighted = false
        emoji4.isHighlighted = false
        
        if !self.selectedProp[0] {
            self.selectedProp[0] = true
            self.selectedProp[1] = false
            self.selectedProp[2] = false
            self.selectedProp[3] = false
            emoji1.backgroundColor = UIColor.blue
            emoji2.backgroundColor = UIColor.clear
            emoji3.backgroundColor = UIColor.clear
            emoji4.backgroundColor = UIColor.clear
        }  else {
            self.selectedProp[0] = false
            emoji1.backgroundColor = UIColor.clear
            p = -1
        }
    }
    
    @IBAction func emoji2(_ sender: Any) {
        self.p = 1
        emoji1.isHighlighted = false
        emoji2.isHighlighted = true
        emoji3.isHighlighted = false
        emoji4.isHighlighted = false
        
        if !self.selectedProp[1] {
            self.selectedProp[0] = false
            self.selectedProp[1] = true
            self.selectedProp[2] = false
            self.selectedProp[3] = false
            emoji1.backgroundColor = UIColor.clear
            emoji2.backgroundColor = UIColor.blue
            emoji3.backgroundColor = UIColor.clear
            emoji4.backgroundColor = UIColor.clear
        }  else {
            self.selectedProp[1] = false
            emoji2.backgroundColor = UIColor.clear
            p = -1
        }
    }
    
    @IBAction func emoji3(_ sender: Any) {
        self.p = 2
        emoji1.isHighlighted = false
        emoji2.isHighlighted = false
        emoji3.isHighlighted = true
        emoji4.isHighlighted = false
        
        if !self.selectedProp[2] {
            self.selectedProp[0] = false
            self.selectedProp[1] = false
            self.selectedProp[2] = true
            self.selectedProp[3] = false
            emoji1.backgroundColor = UIColor.clear
            emoji2.backgroundColor = UIColor.clear
            emoji3.backgroundColor = UIColor.blue
            emoji4.backgroundColor = UIColor.clear
        }  else {
            self.selectedProp[2] = false
            emoji3.backgroundColor = UIColor.clear
            p = -1
        }
    }
    
    @IBAction func emoji4(_ sender: Any) {
        self.p = 3
        emoji1.isHighlighted = false
        emoji2.isHighlighted = false
        emoji3.isHighlighted = false
        emoji4.isHighlighted = true
        
        if !self.selectedProp[3] {
            self.selectedProp[0] = false
            self.selectedProp[1] = false
            self.selectedProp[2] = false
            self.selectedProp[3] = true
            emoji1.backgroundColor = UIColor.clear
            emoji2.backgroundColor = UIColor.clear
            emoji3.backgroundColor = UIColor.clear
            emoji4.backgroundColor = UIColor.blue
        }  else {
            self.selectedProp[3] = false
            emoji4.backgroundColor = UIColor.clear
            p = -1
        }
    }
}
