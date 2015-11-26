//
//  foodList.swift
//  diningHall
//
//  Created by Diwas  Timilsina on 7/22/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import Foundation
import UIKit


// Food Item Class
class Food{
    var name: String!
    var image: UIImage!
    
    init(foodName:String, picLabel: UIImage){
        name = foodName
        image = picLabel
    }
}

// Labeled Food items (place holders for now)
var food1 = Food(foodName: "Pulled Chicken and Rice", picLabel: UIImage(named: "cross")!)
var food2 = Food(foodName: "Brown Rice", picLabel: UIImage(named: "cross")!)
var food3 = Food(foodName: "Steamed Vegitables", picLabel: UIImage(named: "cross")!)
var food4 = Food(foodName: "Cilantro and Black Beans", picLabel: UIImage(named: "cross")!)
var food5 = Food(foodName: "Apple", picLabel: UIImage(named: "cross")!)
var food6 = Food(foodName: "Mango", picLabel: UIImage(named: "cross")!)
var food7 = Food(foodName: "Grapes", picLabel: UIImage(named: "cross")!)
var food8 = Food(foodName: "Meat", picLabel: UIImage(named: "cross")!)
var food9 = Food(foodName: "Banana", picLabel: UIImage(named: "cross")!)
//Search Label

