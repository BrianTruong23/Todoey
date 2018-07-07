//
//  CategoryViewCoTableViewController.swift
//  Todoey
//
//  Created by MACBOOK on 7/5/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewCoTableViewController: UITableViewController {

    var categoryArrays = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadCategory()
    }
    
    
 //MARK: -Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what happens when user click the add button
            let newCategory = Category(context: self.context)
            newCategory.name = alertText.text!
            self.categoryArrays.append(newCategory)
            self.saveCategorys()
            
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
        return categoryArrays.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
       
        cell.textLabel?.text = categoryArrays[indexPath.row].name
      
        
        return cell
        
    }
     //MARK: -TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArrays[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation method
    
    func saveCategorys(){
        do {
            try context.save()
        } catch{
            print("Error saving data\(error)")
            
        }
           tableView.reloadData()
    }
    
    func loadCategory(){
        let request : NSFetchRequest<Category> =  Category.fetchRequest()
        
        do{
            
            categoryArrays = try context.fetch(request)
        } catch{
            print("Error loading items \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    
    
   
    
}
