//
//  TutorialViewController.swift
//  ApplicationW2
//
//  Created by Filippo Pepe on 03/08/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController{

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var imgView: UIImageView!
    
    @IBAction func pageChanged(_ sender: Any) {
        imgView.image = UIImage(named: String(pageControl.currentPage+1))
        counterPage = pageControl.currentPage
    }
    
    var counterPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        imgView.image = UIImage(named: String(1))
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(respondGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondGesture(gesture:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        view.isUserInteractionEnabled = true
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
    
    func respondGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                counterPage = (counterPage + 1) % 3
                pageControl.currentPage = counterPage
                imgView.image = UIImage(named: String(counterPage+1))
            case UISwipeGestureRecognizerDirection.right :
                counterPage = (counterPage == 0) ? 2 : (counterPage-1)%3
                    pageControl.currentPage = counterPage
                    imgView.image = UIImage(named: String(counterPage+1))
                
            default:
                break
            }
        }
    }
    
//    @IBAction func tutorialBegin(segue: UIStoryboardSegue) {
//        pageControl.numberOfPages = 3
//        pageControl.currentPage = 0
//        imgView.image = UIImage(named: String(1))
//        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(respondGesture(gesture:)))
//        swipeRight.direction = .right
//        view.addGestureRecognizer(swipeRight)
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondGesture(gesture:)))
//        swipeLeft.direction = .left
//        view.addGestureRecognizer(swipeLeft)
//        view.isUserInteractionEnabled = true
//    }
    
}
