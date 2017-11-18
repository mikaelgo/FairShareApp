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
    
    @IBOutlet weak var mtPlannedFS: UILabel!
    @IBOutlet weak var scaPlannedFS: UILabel!
    @IBOutlet weak var plPlannedFS: UILabel!
    @IBOutlet weak var otherPlannedFS: UILabel!
    
    var productListItems: [ProductListItem] = []
    
    @IBAction func finnishSessionPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateFairShare()
        
        

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
    
    func calculateFairShare() {
        
        let sca = self.productListItems.filter { $0.product?.productlabel == "SCA" }
        let mt = self.productListItems.filter { $0.product?.productlabel == "MT" }
        let kesko = self.productListItems.filter { $0.product?.productlabel == "Ruokakesko Oy" }
        let other = self.productListItems.filter { $0.product?.productlabel != "Ruokakesko Oy" && $0.product?.productlabel != "SCA" && $0.product?.productlabel != "MT" }
        print("SCA: \(sca)\nMT: \(mt)\nKesko: \(kesko)\nOther: \(other)")
        
        let scaVolume = sca.reduce(0) {volume, sca in
            if let productVolume = sca.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(sca.amount)
                return volume + (prodVolume * productAmount)
            }
            return volume
        }
        
        let mtVolume = mt.reduce(0) {volume, mt in
            if let productVolume = mt.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(mt.amount)
                return volume + (prodVolume * productAmount)
            }
            return volume
        }
        
        let keskoVolume = kesko.reduce(0) {volume, kesko in
            if let productVolume = kesko.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(kesko.amount)
                return volume + (prodVolume * productAmount)
            }
            return volume
        }
        
        let otherVolume = other.reduce(0) {volume, other in
            if let productVolume = other.product?.productvolume {
                let prodVolume = Int(productVolume)
                let productAmount = Int(other.amount)
                return volume + (prodVolume * productAmount)
            }
            return volume
        }
        
        
        print("SCA: \(scaVolume)\nMT: \(mtVolume)\nKesko: \(keskoVolume)\nOther: \(otherVolume)")
       
        let mtFairShare: Int = Int((Float(mtVolume) / 17820000000.0) * 100.0)
        let scaFairShare: Int = Int((Float(scaVolume) / 17820000000.0) * 100.0)
        let plFairShare: Int = Int((Float(keskoVolume) / 17820000000.0) * 100.0)
        let otherFairShare: Int = Int((Float(otherVolume) / 17820000000.0) * 100.0)
        
        self.mtCurrentFS.text = String(mtFairShare)
        self.scaCurrentFS.text = String(scaFairShare)
        self.plCurrentFS.text = String(plFairShare)
        self.otherCurrentFS.text = String(otherFairShare)
        
        print("FairSHareOfMT: ", mtFairShare ,"%")
    }

}
