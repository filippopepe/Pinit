//
//  SettingsViewController.swift
//  ApplicationW2
//
//  Created by Marco Lettiero on 02/08/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SettingsViewController: UIViewController, FunctionNotAvailableYetProtocol {
    @IBAction func appRateAction(_ sender: Any) {
        self.present(functionNotAvailableYetAlarm(), animated: true, completion: nil)
    }
    @IBAction func creditsAction(_ sender: Any) {
        self.present(functionNotAvailableYetAlarm(), animated: true, completion: nil)
    }
    @IBAction func deleteAllAction(_ sender: Any) {
       self.deleteAllRecords()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol FunctionNotAvailableYetProtocol {
    func functionNotAvailableYetAlarm() -> UIAlertController
}

extension FunctionNotAvailableYetProtocol {
    func functionNotAvailableYetAlarm() -> UIAlertController {
        let alertMessage = UIAlertController(title: "Function not available", message: "Sorry, this feature is not avaialable yet.", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertMessage
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
