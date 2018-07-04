//
//  ViewController.swift
//  Todoey
//
//  Created by MACBOOK on 6/30/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//Library/Developer/CoreSimulator/Devices/B46B2855-6E0B-45A3-89AA-B0317228321D/data/Containers/Data/Application/FBC3D758-433D-4104-83CA-2311BA0B41B2/



import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath)
       

        loadItems()
        
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
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                  itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding system array \(error)")
            }
        }
    }
}

