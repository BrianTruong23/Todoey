//
//  ViewController.swift
//  Todoey
//
//  Created by MACBOOK on 6/30/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath)
        let newItem = Item()
        newItem.title = "Find Mike"
       itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mice"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Milk"
        itemArray.append(newItem3)
//     if let item  = defaults.array(forKey: "ToDoListArray") as? [Item] {
//          itemArray = item
//        }
    }
    // 
    // MARK : TableView datasource method
    
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
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    
    // MARK : TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      print(itemArray[indexPath.row])
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        saveItems()
//        if tableView.cellForRow(at:  indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at:  indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at:  indexPath)?.accessoryType = .checkmark
//        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK : Add new items
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
       var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user click the Add Item button on our UIAlert
            let newItem = Item()
            newItem.title = alertText.text!
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
    
    
    // MARK  - Model Manipulation Methods
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding array \(error)")
        }
        
        
       self.tableView.reloadData()
    }
    
}

