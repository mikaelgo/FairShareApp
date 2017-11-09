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
    var eanCodeList = ["6411300000494", "6413600014409" ]
    var scannedCode: String = "6411300000494"
    
    @IBOutlet weak var scanerButton: UIButton!
    @IBOutlet weak var storePickerTextField: UITextField!
    
    
    
    @IBAction func handleScan(_ sender: Any) {
        controller.title = "Button Scanner"
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
        }
        catch {
            //ERROR HANDLING
        }
        
        //SAVING CORE DATA
        /*let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Products", into: context)
        
        newProduct.setValue("Test Product 1", forKey: "productname")
        newProduct.setValue("6411300000494", forKey: "eancode")
        newProduct.setValue("205", forKey: "productheight")
        newProduct.setValue("415", forKey: "productlength")
        newProduct.setValue("215", forKey: "productdepth")
        
        
        
        do {
            try context.save()
            print("SAVED")
        }
        catch {
            //ERROR HANDLING
        }*/
        
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
    
}

//BarcodeScanner functions

extension BarcodeScannerViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        
        if eanCodeList.contains(code) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let scannedProdViewController = storyboard.instantiateViewController(withIdentifier: "ScannedProductPageIdentifier") as! ScannedProductViewController
            scannedProdViewController.title = "Scanned Product"
            scannedProdViewController.testCode = code
            navigationController?.pushViewController(scannedProdViewController, animated: true)
            
            let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                controller.dismiss(animated: true, completion: nil)
                controller.resetWithError()
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
