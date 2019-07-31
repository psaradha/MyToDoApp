//
//  ViewController.swift
//  MyToDoApp
//
//  Created by Sridhar MS on 29/7/19.
//  Copyright © 2019 Sridhar MS. All rights reserved.
//

import UIKit

class MyToDoList: UITableViewController {

    var listArray = [ListChecked]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let item1 = ListChecked()
        item1.listItemName = "veggie"
        listArray.append(item1)
        defaults.set(listArray, forKey: "nsrdefaults")
        
        let item = defaults.array(forKey: "nsrdefaults") as! [ListChecked]
        listArray = item
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todolist", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row].listItemName
        cell.accessoryType = listArray[indexPath.row].checkValue ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        listArray[indexPath.row].checkValue = !listArray[indexPath.row].checkValue
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textFieldText: UITextField?
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertaction) in
            
            let text = textFieldText?.text
            if text != nil {
                
                let newItem = ListChecked()
                newItem.listItemName = text!
                self.listArray.append(newItem)
                self.defaults.set(self.listArray, forKey: "nsrdefault")
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (text) in
            text.placeholder = "Enter new item"
            textFieldText = text
        }
    
        
        present(alert, animated: true)
    }
}

