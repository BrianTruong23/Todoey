//
//  CategoryViewCoTableViewController.swift
//  Todoey
//
//  Created by MACBOOK on 7/5/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryViewCoTableViewController: UITableViewController  {
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
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
       cell.textLabel?.text = categoryArrays?[indexPath.row].name ?? "No Category Added Yet"
       cell.delegate = self
        
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
}

// MARK: - Swipe Cell Delegate
extension CategoryViewCoTableViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted")
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }

}
