//
//  AddProductViewController.swift
//  FairShareDemo
//
//  Created by Mikael on 12/12/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController, UITextFieldDelegate {
    
    //Make an empty Product list
    var productList: [Product] = []
    
    //All the textfields in the Add Product page
    @IBOutlet weak var prodName: UITextField!
    @IBOutlet weak var prodEANCode: UITextField!
    @IBOutlet weak var prodCategory: UITextField!
    @IBOutlet weak var prodProducer: UITextField!
    @IBOutlet weak var prodHeight: UITextField!
    @IBOutlet weak var prodWidth: UITextField!
    @IBOutlet weak var prodDepth: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing the textfields
        self.prodName.delegate = self
        self.prodEANCode.delegate = self
        self.prodCategory.delegate = self
        self.prodProducer.delegate = self
        self.prodHeight.delegate = self
        self.prodWidth.delegate = self
        self.prodDepth.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Button function to when the Add Product button is pressed, also it opnes a new window with a seque
    @IBAction func addProductPressed(_ sender: UIButton) {
        addNewProduct()
        performSegue(withIdentifier: "toTheMainPage", sender: self)
        
    }
    
    //Function to close the keyboard after you have pressed Done in the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Function for the add new product, it includes Core Data functions for saving and fetching the data to Core Data
    func addNewProduct() {
        
        //Calculating the Volume of the new product
        let prodHeightInt: Int? = Int(prodHeight.text!)
        let prodWidthInt: Int? = Int(prodWidth.text!)
        let prodDepthInt: Int? = Int(prodDepth.text!)
        let prodVolume: Int32? = Int32(prodHeightInt! * prodWidthInt! * prodDepthInt!)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        //Creating a new entry for the 'Product' entity in Core Data
        let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
        
        //Setting the desired values to the right key names
        newProduct.setValue(prodName.text, forKey: "productname")
        newProduct.setValue(prodEANCode.text, forKey: "eancode")
        newProduct.setValue(prodCategory.text, forKey: "productcategory")
        newProduct.setValue(prodProducer.text, forKey: "productlabel")
        newProduct.setValue(prodHeight.text, forKey: "productheight")
        newProduct.setValue(prodWidth.text, forKey: "productlength")
        newProduct.setValue(prodDepth.text, forKey: "productdepth")
        newProduct.setValue(prodVolume, forKey: "productvolume")
        
        do{
            //Saving the data to Core Data
            try context.save()
            print("BRAND NEW PRODUCT SAVED!!!")
        }
        catch{
            print("COULDN'T SAVE NEW PRODUCT!!")
        }
        
        
        //FETCH CORE DATA
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [Product] {
                    productList.append(result)
                }
            }
        }
        catch {
            print("Couldn't fetch the products!")
            print(error)
        }
    }
    
    

}
