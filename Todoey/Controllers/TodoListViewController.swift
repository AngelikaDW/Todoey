//
//  ViewController.swift
//  Todoey
//
//  Created by AngelikaDW on 04/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //var itemArray = ["go to the movies", "meditate", "work"]
    // Create new items using the custom data model
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create objects from custom data model
        let newItem = Item()
        newItem.title = "go to the movies"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "meditate"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "work"
        itemArray.append(newItem2)
        
        //Load date from userDefaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row] //Current item (the value of the cell) in the tableview
        
        //cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        // Reads: "Set the cell's accessoryType depending on whether the item.done is true. If it is true, set it to checkmark, if it is false set it to none
        cell.accessoryType = item.done ? .checkmark : .none
        
        // Long Version
        //        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row) //Prints the number of the row which was selected
        //print(itemArray[indexPath.row])
        
        //Adds checkmark Accessory to selected cell and removes it when the cell is deselected
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        //Set current row property to the opposite of what it is now REVERSE. So to avoid that the checkmark appears when the cell is being reloaded again and gets again the checkmark it got before
            //Long version:
//        if itemArray[indexPath.row].done == true {
//            itemArray[indexPath.row].done = false
//        } else {
//            itemArray[indexPath.row].done = true
//        }
            // Elegant swifty version
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // UI that the selected Row just flashes grey to indicate its highlighted and then goes back to normal
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK - Add new Items to list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Create a local variable to put in value of TextField, textField disappears once alert is closed
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //Completion Block: what will happen once the user clicks the add item button on the alert
            //print("Success! The alert Action works")
            
            //Append value of textField to itemArray
            //self.itemArray.append(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            
            //Save new itemArray to UserDefaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //reload data to show added item
            self.tableView.reloadData()
            
        }
        // alert is being shown
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

