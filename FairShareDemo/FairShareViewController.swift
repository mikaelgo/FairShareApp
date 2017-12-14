//
//  FairShareViewController.swift
//  FairShareDemo
//
//  Created by Mikael on 17/11/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit

class FairShareViewController: UIViewController {

    @IBOutlet weak var mtCurrentFS: UILabel!
    @IBOutlet weak var scaCurrentFS: UILabel!
    @IBOutlet weak var plCurrentFS: UILabel!
    @IBOutlet weak var otherCurrentFS: UILabel!
    
    //Make an empty Product list item array
    var productListItems: [ProductListItem] = []
    
    //Function to handle the finish session button being pressed and directing it to the main page
    @IBAction func finnishSessionPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBarcodeID", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateFairShare()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function to calculate the fair share of the scanned items
    func calculateFairShare() {
        
        //Filter through the different producers in Core Data and add the correct items to the correct 'label names'
        let sca = self.productListItems.filter { $0.product?.productlabel == "SCA" }
        let mt = self.productListItems.filter { $0.product?.productlabel == "MT" }
        let kesko = self.productListItems.filter { $0.product?.productlabel == "Ruokakesko Oy" }
        let other = self.productListItems.filter { $0.product?.productlabel != "Ruokakesko Oy" && $0.product?.productlabel != "SCA" && $0.product?.productlabel != "MT" }
        print("SCA: \(sca)\nMT: \(mt)\nKesko: \(kesko)\nOther: \(other)")
        
        //Calculate the product volume correctly for all the different producers
        let scaVolume = sca.reduce(0) {volume, sca in
            if let productVolume = sca.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(sca.amount)
                let productDepth = Int((sca.product?.productdepth)!)
                let productsInTheShelf: Float = (Float(800 / productDepth!))
                return volume + (prodVolume * productAmount * Int(productsInTheShelf))
            }
            return volume
        }
        
        let mtVolume = mt.reduce(0) {volume, mt in
            if let productVolume = mt.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(mt.amount)
                let productDepth = Int((mt.product?.productdepth)!)
                let productsInTheShelf: Float = (Float(800 / productDepth!))
                print("Tuotteita hyllyssä!! " , productsInTheShelf)
                return volume + (prodVolume * productAmount * Int(productsInTheShelf))
            }
            return volume
        }
        
        
        let keskoVolume = kesko.reduce(0) {volume, kesko in
            if let productVolume = kesko.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(kesko.amount)
                let productDepth = Int((kesko.product?.productdepth)!)
                let productsInTheShelf: Float = (Float(800 / productDepth!))
                return volume + (prodVolume * productAmount * Int(productsInTheShelf))
            }
            return volume
        }
        
        let otherVolume = other.reduce(0) {volume, other in
            if let productVolume = other.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(other.amount)
                let productDepth = Int((other.product?.productdepth)!)
                let productsInTheShelf: Float = (Float(800 / productDepth!))
                return volume + (prodVolume * productAmount * Int(productsInTheShelf))
            }
            return volume
        }
        
        
        print("SCA: \(scaVolume)\nMT: \(mtVolume)\nKesko: \(keskoVolume)\nOther: \(otherVolume)")
        
        let overallVolume: Int = mtVolume + scaVolume + keskoVolume + otherVolume
       
        //Calculate the fair share for all the different producers
        let mtFairShare: Int = Int((Float(mtVolume) / Float(overallVolume)) * 100.0)
        let scaFairShare: Int = Int((Float(scaVolume) / Float(overallVolume)) * 100.0)
        let plFairShare: Int = Int((Float(keskoVolume) / Float(overallVolume)) * 100.0)
        let otherFairShare: Int = Int((Float(otherVolume) / Float(overallVolume)) * 100.0)
        
        self.mtCurrentFS.text = String(mtFairShare)
        self.scaCurrentFS.text = String(scaFairShare)
        self.plCurrentFS.text = String(plFairShare)
        self.otherCurrentFS.text = String(otherFairShare)
        
        print("FairSHareOfMT: ", mtFairShare ,"%")
    }

}
