//
//  ViewController.swift
//  MyToDoApp
//
//  Created by Sridhar MS on 29/7/19.
//  Copyright © 2019 Sridhar MS. All rights reserved.
//

import UIKit
import CoreData

class MyToDoList: UITableViewController {

    var listArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catName: Category? {
        didSet{
            retrieveData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 //       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todolist", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row].listItemName
        cell.accessoryType = listArray[indexPath.row].checkedValue ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        listArray[indexPath.row].checkedValue = !listArray[indexPath.row].checkedValue
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
        
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textFieldText: UITextField?
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertaction) in
            
            let text = textFieldText?.text
            if text != nil {
                let item = Item(context: self.context)
                item.listItemName = text
                item.checkedValue = false
                item.parentCategory = self.catName
                self.listArray.append(item)
                self.saveData()
            }
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (text) in
            text.placeholder = "Enter new item"
            textFieldText = text
        }
        present(alert, animated: true)
    }
    
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func retrieveData(with predicate: NSPredicate? = nil )
    {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        if let predicateSearch = predicate{
        
          let predicateCategory = NSPredicate(format: "parentCategory == %@", catName!)
          request.predicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSearch, predicateCategory])
          request.sortDescriptors = [NSSortDescriptor(key: "listItemName", ascending: true) ]
        }else{
          request.predicate = NSPredicate(format: "parentCategory == %@", catName!)
        }
        
        do {
           
           listArray = try context.fetch(request)
        } catch  {
            print(error)
        }
        tableView.reloadData()
    }
}

extension MyToDoList: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        let predicateSearch = NSPredicate(format: "listItemName CONTAINS[cd] %@", searchBar.text!)
        retrieveData(with: predicateSearch)
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            retrieveData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        }
        
    }
    
    
}

