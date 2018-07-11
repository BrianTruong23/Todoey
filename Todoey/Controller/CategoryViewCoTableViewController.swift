//
//  CategoryViewCoTableViewController.swift
//  Todoey
//
//  Created by MACBOOK on 7/5/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewCoTableViewController: SwipeTableViewController  {
    let realm = try! Realm()
    
    var categoryArrays : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
         loadCategory()
        
    }
    
    
 //MARK: -Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what happens when user click the add button
            let newCategory = Category()
            newCategory.name = alertText.text!
            
          
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
             alertText =  alertTextField
             alertText.placeholder = "Please add new items"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
       loadCategory()
        
    }
   
    //MARK: -TableView datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrays?.count ?? 1
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
       cell.textLabel?.text = categoryArrays?[indexPath.row].name ?? "No Category Added Yet"

        
        return cell
        
    }
     //MARK: -TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArrays?[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation method
    
    func save(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error saving data\(error)")
            
        }
           tableView.reloadData()
    }
    
    func loadCategory(){
        categoryArrays = realm.objects(Category.self)

        tableView.reloadData()

    }
    // MARK : -Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
if let categoryForDeletion = self.categoryArrays?[indexPath.row] {
    do {
        try self.realm.write {
            self.realm.delete(categoryForDeletion)
        }
    }catch {
        print("Error deleting data \(error)")
    }

}
        
    }
    
    
}
