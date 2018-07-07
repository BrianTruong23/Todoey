//
//  ViewController.swift
//  Todoey
//
//  Created by MACBOOK on 6/30/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//Library/Developer/CoreSimulator/Devices/B46B2855-6E0B-45A3-89AA-B0317228321D/data/Containers/Data/Application/FBC3D758-433D-4104-83CA-2311BA0B41B2/



import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    

    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
 
    
    //MARK: -decalre variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
        
    }
    // 
    // MARK: -TableView datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       // Ternary Operator ==>
        // value = condition ? valueIfTrue : ValueIfFalse
        
        cell.accessoryType = item.done ?  .checkmark  : .none
        

        return cell
    }
    
    // MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
      
       context.delete(itemArray[indexPath.row])
          itemArray.remove(at: indexPath.row)
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add new items
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
       var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user click the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context )
            newItem.title = alertText.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
       
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Please add new item"
           alertText = alertTextField
          
        }
        
        
        alert.addAction(action)
        
        
       present(alert, animated: true, completion: nil)
    }
    
    
    // MARK:  - Model Manipulation Methods
    func saveItems(){
      
        do {
           try  context.save()
        }
        catch {
          print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
           request.predicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate , categoryPredicate])

        }else{
            request.predicate = categoryPredicate
        }
     
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fectching data \(error)")
        }
        tableView.reloadData()
    }
  
    
}
// MARK:  - Search bar method
extension ToDoListViewController :  UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
     let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! )
     
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate : predicate )
     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
           
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}
