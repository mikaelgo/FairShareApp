//
//  BarcodeScannerViewController.swift
//  FairShareDemo
//
//  Created by Mikael on 11/10/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit
import BarcodeScanner
import CoreData


class BarcodeScannerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Initialize Barcode Scanner and make couple of arrays for PickerView and "Product" Core Data entity
    let controller = BarcodeScannerController()
    var storePickerList = ["K-Citymarket Sello", "K-Market Perkkaa", "K-Market Töyrynummi"]
    var productList: [Product] = []
    var shouldDisplayScanner: Bool = false
    
    //UI Components
    @IBOutlet weak var scanerButton: UIButton!
    @IBOutlet weak var storePickerTextField: UITextField!
    
    @IBAction func addProductPressed(_ sender: UIButton) {
    }
    
    var scannedProduct: Product?
    
    @IBAction func handleScan(_ sender: Any) {
        //controller.title = "Button Scanner"
        present(controller, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize PickerView for use
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        storePickerTextField.inputView = pickerView
        
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        //Initialize Core Data for usage
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //At the moment the following bit of code where the json is parsed and the data is saved, needs to be commented after the initial build, otherwise the application will add every time the application starts it will add the full json list to the Core Data

        //Read products.json file and iterate through each item in the list
        //get path of resource file products.json added in the project->build phase
        if let path = Bundle.main.path(forResource: "products", ofType: "json") {
            do {
                //get the data of file if it's valid json
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                //parse/serialize json
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //get the array list "products" from jsonResult found from the root of json object and set it as allProducts
                if let jsonResult = jsonResult as? [String: Any], let allProducts = jsonResult["products"] as? [Any] {
                    //iterate through each json object in allProducts list
                    for product in allProducts {
                        //Add each product to core data if it's not already there
                        let productData = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
                        guard let productDict = product as? [String: Any] else { return }
                        //Switch case to add the correct value to the correct key in Core Data
                        for (key, value) in productDict {
                            switch(key) {
                            case "eancode":
                                productData.eancode = String(describing: value)
                                break
                            case "productname":
                                productData.productname = value as? String
                                break
                            case "productwidth":
                                productData.productlength =  String(describing: value)
                                break
                            case "productdepht":
                                productData.productdepth =  String(describing: value)
                                break
                            case "productheight":
                                productData.productheight =  String(describing: value)
                                break
                            case "productcategory":
                                productData.productcategory = value as? String
                                break
                            case "productlabel":
                                productData.productlabel = value as? String
                                break
                            case "productvolume":
                                guard let integerValue = value as? Int else { return }
                                productData.productvolume = Int32.init(truncating: integerValue as NSNumber)
                                break
                            default:
                                break
                            }
                        }
                        do {
                            //Save the given data to Core Data
                            try context.save()
                            print("Data Saved!")
                        }
                        catch {
                            print("Couldn't save the data!")
                            print(error)
                        }
                    }
                }else{
                    print("else")
                }
            } catch {
                print(error)
            }
        }
        
    
        //Fetch the data from Core Data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        request.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(request)

            if results.count > 0 {
                for result in results as! [Product] {
                    productList.append(result)
                    print(results)
                }
            }
        }
        catch {
            print("Couldn't Fetch the data")
            print(error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.shouldDisplayScanner {
            present(controller, animated: false)
            self.shouldDisplayScanner = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: PickerView delegate and datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storePickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return storePickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storePickerTextField.text = storePickerList[row]
        pickerView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? ScannedProductViewController, let product = self.scannedProduct {
            destVC.product = product
        }
    }
    
    @IBAction func unwindToScanner(segue: UIStoryboardSegue) {
        self.shouldDisplayScanner = true
    }
}

//BarcodeScanner functions

extension BarcodeScannerViewController: BarcodeScannerCodeDelegate {
    
    //Function when the barcode matches the Core Data EAN code list
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        //Filter through the Core Data and compare the scanned barcode to the EAN Code list in Core Data
        let filteredProducts = productList.filter { $0.eancode == code }
        if filteredProducts.count > 0 {
            self.scannedProduct = filteredProducts[0]
            self.performSegue(withIdentifier: "toScannedProduct", sender: self)

            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                controller.dismiss(animated: true, completion: nil)
                controller.reset(animated: true)
            }

        } else {
            let delayTime2 = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime2) {
                controller.resetWithError()

            }
        }
    }
}

extension BarcodeScannerViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}
//Display error when the scanner dosen't find barcode
extension BarcodeScannerViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    }

