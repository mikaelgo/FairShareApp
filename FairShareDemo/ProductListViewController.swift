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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.tableView.register(UINib.init(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "productListCell")
        fetchProductListItems()
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
    
    func fetchProductListItems() {
        guard let dataContext = self.context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductListItem")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try dataContext.fetch(request)
            self.productListItems = results as? [ProductListItem]
            self.tableView.reloadData()
        } catch {
            //ERROR HANDLING
        }
    }
    
    

}
