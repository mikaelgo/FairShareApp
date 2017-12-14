//
//  ProductListViewController.swift
//  FairShareDemo
//
//  Created by Mikael on 13/11/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit
import CoreData

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var context: NSManagedObjectContext?
    var productListItems: [ProductListItem]?
    
    //Function to open the fair share window
    @IBAction func productListToFsPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toFairShareID", sender: self)
    }
    
    //Different function for the use of tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productListItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productListCell", for: indexPath) as! ProductListCell
        if let productListItem = productListItems?[indexPath.row] {
            cell.setup(productListItem: productListItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            guard let itemToDelete = productListItems?[indexPath.row] else { return }
            self.deleleteProductListItem(item: itemToDelete)
        }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Showing the tableviewcells and populating them with the scanned products
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.tableView.register(UINib.init(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "productListCell")
        fetchProductListItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Function for fetching the items from the product list item data entity in Core Data
    func fetchProductListItems() {
        guard let dataContext = self.context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductListItem")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try dataContext.fetch(request)
            self.productListItems = results as? [ProductListItem]
            self.tableView.reloadData()
        } catch {
            print("Couldn't fetch the product from the ProductListItem")
            print(error)
        }
    }
    
    //Function for deleting the items from the product list in Core Data
    func deleleteProductListItem(item: ProductListItem) {
        guard let dataContext = self.context else { return }
        dataContext.delete(item)
        self.fetchProductListItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? FairShareViewController, let listItems = self.productListItems {
            destVC.productListItems = listItems
        }
    }
    
    

}
