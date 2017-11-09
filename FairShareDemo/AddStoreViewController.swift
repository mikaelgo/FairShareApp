//
//  addStoreViewController.swift
//  FairShareDemo
//
//  Created by Mikael on 25/10/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit


class AddStoreViewController: UIViewController {

    @IBAction func saveStoreDataButton(_ sender: UIBarButtonItem) {
        //SAVE DATA
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        print("SAVE BUTTON PUSHED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add store"
        
      

        // Do any additional setup after loading the view.
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

}
