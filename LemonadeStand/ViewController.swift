//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Lynx on 6/29/16.
//  Copyright © 2016 Lynx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var moneyIHaveLabel: UILabel!
    @IBOutlet weak var lemonsIHaveLabel: UILabel!
    @IBOutlet weak var iceCubesIHaveLabel: UILabel!
    @IBOutlet weak var suppliesNumLemonsLabel: UILabel!
    @IBOutlet weak var suppliesNumIceCubesLabel: UILabel!
    @IBOutlet weak var mixLemonsLabel: UILabel!
    @IBOutlet weak var mixIceCubesLabel: UILabel!
    
    @IBOutlet weak var weatherToday: UIImageView!
    
    var myInventory = Inventory(aMoney: 10, aLemons: 1, aIceCubes: 1)
    let price = Price()
    
    var lemonsToMix = 0
    var iceCubesToMix = 0
    var lemonsToBuy = 0
    var iceCubesToBuy = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateMyInventoryUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func suppliesAddLemonButton(sender: UIButton) {
        if (myInventory.money >= price.lemon) {
            myInventory.numLemons += 1
            lemonsToBuy += 1
            myInventory.money -= price.lemon
            updateMyInventoryUI()
            updateSuppliesUI()
        } else {
            showAlertWithText(message: "You have no money left to buy inventory")
        }
    }

    @IBAction func suppliesSubtractLemonButton(sender: UIButton) {
        if myInventory.numLemons > 0 {
            myInventory.numLemons -= 1
            lemonsToBuy -= 1
            myInventory.money += price.lemon
            updateMyInventoryUI()
            updateSuppliesUI()
        }
    }
    
    @IBAction func suppliesAddIceCubeButton(sender: UIButton) {
        if (myInventory.money >= price.iceCube) {
            myInventory.numIceCubes += 1
            iceCubesToBuy += 1
            myInventory.money -= price.iceCube
            updateMyInventoryUI()
            updateSuppliesUI()
        } else {
            showAlertWithText(message: "You have no money left to buy inventory")
        }
    }
    
    @IBAction func suppliesSubtractIceCubeLemonButton(sender: UIButton) {
        if myInventory.numIceCubes > 0 {
            myInventory.numIceCubes -= 1
            iceCubesToBuy -= 1
            myInventory.money += price.iceCube
            updateMyInventoryUI()
            updateSuppliesUI()
        }
    }

    @IBAction func mixAddLemonButton(sender: UIButton) {
        lemonsToMix += 1
        mixLemonsLabel.text = "\(lemonsToMix)"
    }
    
    @IBAction func mixSubtractLemonButton(sender: UIButton) {
        if lemonsToMix > 0 {
            lemonsToMix -= 1
            mixLemonsLabel.text = "\(lemonsToMix)"
        }
    }
    
    @IBAction func mixAddIceCubeButton(sender: UIButton) {
        iceCubesToMix += 1
        mixIceCubesLabel.text = "\(iceCubesToMix)"
    }
    
    @IBAction func mixSubtractIceCubeButton(sender: UIButton) {
        if iceCubesToMix > 0 {
            iceCubesToMix -= 1
            mixIceCubesLabel.text = "\(iceCubesToMix)"
        }
    }
    
    @IBAction func startDayButton(sender: UIButton) {
        if (myInventory.numLemons == 0) {
            showAlertWithText(message: "You have no lemons to make lemonade!!")
            return
        }

        if (myInventory.numIceCubes == 0) {
            showAlertWithText(message: "You have no ice bues to make lemonade!!")
            return
        }
        
        if (lemonsToMix > myInventory.numLemons) {
            showAlertWithText(message: "You are trying to mix more lemons than you have!!")
            return
        }

        if (iceCubesToMix > myInventory.numIceCubes) {
            showAlertWithText(message: "You are trying to mix more ice cubes than you have!!")
            return
        }
        
        let lemonadeRatio = Float(lemonsToMix) / Float(iceCubesToMix)
        var numCustomers = Int(arc4random_uniform(UInt32(11)))
        var customerPreferences:[Float] = []
        let weather = Int(arc4random_uniform(UInt32(3)))
        
        switch (weather) {
        case 1:
            if numCustomers > 3 {
                numCustomers -= 3
            } else {
                numCustomers = 0
            }
            weatherToday.image = UIImage(named: "cold")
            break
        case 3:
            numCustomers += 4
            weatherToday.image = UIImage(named: "warm")
            break
        default:
            weatherToday.image = UIImage(named: "mild")
            break
        }
        
        for _ in 0 ..< numCustomers {
            let taste:Float = Float(arc4random_uniform(101)) / 100
            customerPreferences.append(taste)
        }
        
        for x in 0 ..< numCustomers {
            if customerPreferences[x] < 0.4 && lemonadeRatio > 1 {
                myInventory.money += 1
                print("Paid!  Preference Value = " + String(customerPreferences[x]))
            } else if customerPreferences[x] >= 0.4 && customerPreferences[x] < 0.6 && lemonadeRatio == 1 {
                myInventory.money += 1
                print("Paid!  Preference Value = " + String(customerPreferences[x]))
            } else if customerPreferences[x] >= 0.6 && customerPreferences[x] <= 1 && lemonadeRatio < 1 {
                myInventory.money += 1
                print("Paid!  Preference Value = " + String(customerPreferences[x]))
            } else {
                print("No Match, No Revenue.  Preference Value = " + String(customerPreferences[x]))
            }
        }
        
        myInventory.numLemons -= lemonsToMix
        myInventory.numIceCubes -= iceCubesToMix
        
        lemonsToBuy = 0
        iceCubesToBuy = 0
        
        updateMyInventoryUI()
        updateSuppliesUI()
        
        if myInventory.money == 0 {
            showAlertWithText(message: "You are out of money!  Your lemonade stand is busted!!!")
        }
   }
    
    func showAlertWithText(header: String = "Warning", message: String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateMyInventoryUI() {
        moneyIHaveLabel.text = "$\(myInventory.money)"
        lemonsIHaveLabel.text = "\(myInventory.numLemons) Lemons"
        iceCubesIHaveLabel.text = "\(myInventory.numIceCubes) Ice Cubes"
    }
    
    func updateSuppliesUI() {
        suppliesNumLemonsLabel.text = "\(lemonsToBuy)"
        suppliesNumIceCubesLabel.text = "\(iceCubesToBuy)"
        
    }
}

