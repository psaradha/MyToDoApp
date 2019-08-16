//
//  CategoryViewController.swift
//  MyToDoApp
//
//  Created by Sridhar MS on 14/8/19.
//  Copyright © 2019 Sridhar MS. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var catList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
     retrieveData()
    }

    
    
    // MARK: - Table view data source

 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return catList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catList[indexPath.row].category
        return cell
    }
    
// MARK: Add category
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textFieldText: UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertaction) in
            
            let text = textFieldText?.text
            if text != nil {
                let category = Category(context: self.context)
                category.category = text
                self.catList.append(category)
                self.saveData()
            }
            
        }
        alert.addAction(action)
        alert.addTextField { (text) in
            text.placeholder = "Enter a new Category"
            textFieldText = text
        }
        present(alert, animated: true)
    
    }
    
    // MARK: save data context
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    // MARK: retrieve data from database
    
    func retrieveData(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        do {
            catList = try context.fetch(request)
        } catch  {
            print(error)
        }
        tableView.reloadData()
    }


    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     performSegue(withIdentifier: "goToItems", sender: self)
    }
    
   
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToItems" {
        let secondVC = segue.destination as! MyToDoList
        let index = tableView.indexPathForSelectedRow?.row
        secondVC.catName = catList[index!]
    }
    }
    
}
