//
//  ViewController.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 21/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        print(launchedBefore)
        if launchedBefore{
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        }else {
            print("A puttan ra mamm ro segue")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "segueTutorial", sender: self)
            }
            print("Qua ci sono arrivato")
            
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func timeToMoveOn(){
        self.performSegue(withIdentifier: "seguePrincipale", sender: nil)
    }
    
    
}

