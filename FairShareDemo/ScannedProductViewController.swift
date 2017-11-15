//
//  ScannedProductViewController.swift
//  FairShareDemo
//
//  Created by Mikael on 09/11/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit
import CoreData

class ScannedProductViewController: UIViewController {
    
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productHeight: UILabel!
    @IBOutlet weak var productLength: UILabel!
    @IBOutlet weak var productDepth: UILabel!
    @IBOutlet weak var productFaces: UITextField!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productProducer: UILabel!
    @IBOutlet weak var productVolume: UILabel!
    
    var product: Product?
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productCode.text = product?.eancode
        self.productName.text = product?.productname
        self.productHeight.text = product?.productheight
        self.productLength.text = product?.productlength
        self.productDepth.text = product?.productdepth
        self.productCategory.text = product?.productcategory
        self.productProducer.text = product?.productlabel
        if let prodVolume = product?.productvolume {
            self.productVolume.text = String(describing: prodVolume)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.context = appDelegate.persistentContainer.viewContext
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.productFaces.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
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
    
    //MARK: Actions
    
    @IBAction func nextProductPressed(_ sender: Any) {
        addProductToList()
        performSegue(withIdentifier: "unwindToScanner", sender: self)
        
    }
    
    @IBAction func finishScanningPressed(_ sender: Any) {
        addProductToList()
        self.performSegue(withIdentifier: "toProductList", sender: self)
    }
    
    //Function that adds product item to core data product list
    func addProductToList() {
        guard let dataContext = self.context else { return }
        guard let amountText = productFaces.text else { return }
        let productListItem = NSEntityDescription.insertNewObject(forEntityName: "ProductListItem", into: dataContext)
        
        productListItem.setValue(product, forKey: "product")
        productListItem.setValue(Int16(amountText), forKey: "amount")
        
        do {
            try dataContext.save()
            print("DATA SAVED")
        }
        catch {
            print("Content couldn't be saved!")
            print(error)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductListItem")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try dataContext.fetch(request)
            if results.count > 0 {
                for result in results as! [ProductListItem] {
                    print(result)
                }
            }
        } catch {
            print("Content couldn't be retrieved!")
            print(error)
        }
    }
}
