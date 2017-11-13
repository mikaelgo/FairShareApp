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
    
    let controller = BarcodeScannerController()
    var storePickerList = ["Kauppakeskus Sello", "Malakies", "Iso Omena"]
    var productList: [Product] = []
    var shouldDisplayScanner: Bool = false
    
    @IBOutlet weak var scanerButton: UIButton!
    @IBOutlet weak var storePickerTextField: UITextField!
    
    var scannedProduct: Product?
    
    @IBAction func handleScan(_ sender: Any) {
        //controller.title = "Button Scanner"
        present(controller, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        storePickerTextField.inputView = pickerView
        
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        //STORE CORE DATA
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        //FETCH CORE DATA
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        request.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(request)

            if results.count > 0 {

                for result in results as! [Product] {


                    productList.append(result)


                   /* if let productname = result.value(forKey: "productname") as? String {
                        print(productname)
                    }
                    if let eancode = result.value(forKey: "eancode") as? String {
                        productList.append(eancode)
                        print("Ean code list: \(productList)\n")
                    }*/
                }
            }
        }
        catch {
            //ERROR HANDLING
        }
        
//        //SAVING CORE DATA
//        let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
//
//        newProduct.setValue("Test Product 1", forKey: "productname")
//        newProduct.setValue("6413600014409", forKey: "eancode")
//        newProduct.setValue("215", forKey: "productheight")
//        newProduct.setValue("515", forKey: "productlength")
//        newProduct.setValue("315", forKey: "productdepth")
//
//
//
//        do {
//            try context.save()
//            print("SAVED")
//        }
//        catch {
//            //ERROR HANDLING
//        }
        
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
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

extension BarcodeScannerViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
