//
//  Inventory.swift
//  LemonadeStand
//
//  Created by Lynx on 7/2/16.
//  Copyright © 2016 Lynx. All rights reserved.
//

import Foundation
import UIKit

struct Inventory {
    var numLemons = 0
    var numIceCubes = 0
    var money = 0
    
    init(aMoney: Int, aLemons: Int, aIceCubes: Int) {
        money = aMoney
        numLemons = aLemons
        numIceCubes = aIceCubes
    }
}