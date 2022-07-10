//
//  ShoppingTableViewController.swift
//  ClothesFinder
//
//  Created by Phil John on 1/31/22.
//

import UIKit
import WebKit
import SwiftyJSON

class ShoppingTableViewController: UITableViewController {
    
    var shoppingResultsJSON: JSON?
    var shoppingResultsJSONCount: Int?
    var shoppingList: [(item: String, link: String)]?
    
    override func viewWillAppear(_ animated: Bool) {
        if let jsonObjects = shoppingResultsJSON {
            shoppingList = []
            print(jsonObjects)
            for shoppingItem in jsonObjects {
                print(shoppingItem)
                shoppingList?.append((item: shoppingItem.1["title"].string!, link: shoppingItem.1["link"].string!))
            }
        }
        shoppingResultsJSONCount = shoppingList?.count
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.xibIdentifiers.resultCellNib, bundle: nil), forCellReuseIdentifier: K.tableViewIdentifiers.shoppingResultIdentifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingResultsJSONCount ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewIdentifiers.shoppingResultIdentifier, for: indexPath) as! ResultCell
        
        if let currShoppingItem = shoppingList?[indexPath.row] {
            cell.label.text = currShoppingItem.item
        } else {
            cell.label.text = "No items found"
        }

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = shoppingList?[indexPath.row] {
            print("Going to this link \(item.link)")
            performSegue(withIdentifier: K.segueToShoppingLink, sender: self)
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueToShoppingLink {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destination = segue.destination as? ShoppingWebViewController
                if let currItem = shoppingList?[indexPath.row]{
                    destination?.link = currItem.link
                }
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
