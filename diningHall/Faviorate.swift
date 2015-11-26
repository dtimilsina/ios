//
//  Faviorate.swift
//  diningHall
//
//  Created by Diwas  Timilsina on 7/26/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Faviorate: NSManagedObject {

    @NSManaged var foodList: NSSet
    @NSManaged var notificationList: NSSet

}