//
//  ViewController.swift
//  MyToDoApp
//
//  Created by Sridhar MS on 29/7/19.
//  Copyright © 2019 Sridhar MS. All rights reserved.
//

import UIKit

class MyToDoList: UITableViewController {

    var listArray = ["veggie", "lentils", "soap"]
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        listArray = defaults.array(forKey: "nsrdefault") as! [String]
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "todolist", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark{
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textFieldText: UITextField?
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertaction) in
            
            let text = textFieldText?.text
            if text != nil {
                self.listArray.append(text!)
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

