//
//  Location.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 27/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import Foundation

class Location {
    var name = ""
    var type = ""
    var image = ""
    var lat = 0.0
    var long = 0.0
    var isVisited = false
    init(name: String, type : String, image :String , lat:Double , long:Double, isVisited:Bool) {
        self.name = name
        self.type = type
        self.image = image
        self.lat = lat
        self.long = long
        self.isVisited = isVisited
        
    }
}
