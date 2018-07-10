//
//  ViewController.swift
//  Todoey
//
//  Created by MACBOOK on 6/30/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//Library/Developer/CoreSimulator/Devices/B46B2855-6E0B-45A3-89AA-B0317228321D/data/Containers/Data/Application/FBC3D758-433D-4104-83CA-2311BA0B41B2/



import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
   let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
   


    
    var selectedCategory : Category? {
        didSet{
      loadItems()
        }
    }
    
 
    
    //MARK: -decalre variables
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

      
        
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: -TableView datasource method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

          if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Ternary Operator ==>
            // value = condition ? valueIfTrue : ValueIfFalse

            cell.accessoryType = item.done ?  .checkmark  : .none

        } else{
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }

    // MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
            
               item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)


    }

    
    // MARK: - Add new items
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
       var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user click the Add Item button on our UIAlert
            
            
                
            if let currentCategory =  self.selectedCategory{
                do{
                     try self.realm.write {
                        let newItem = Item( )
                        newItem.title = alertText.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                       self.realm.add(newItem)
                }
            }catch{
                print("Error saving data\(error)")
            }
            
       
         }
           self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Please add new item"
           alertText = alertTextField
         }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
     
    }
    
    // MARK:  - Model Manipulation Methods
   
        
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
//       todoItems =  realm.objects(Item.self)
//
//        tableView.reloadData()
    }
  
    
}
// MARK:  - Search bar method


extension ToDoListViewController :  UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
       tableView.reloadData()
    }
    
    
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//     let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! )
//
//        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate : predicate )


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()


            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }
}
