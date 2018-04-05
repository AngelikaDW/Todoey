//
//  ViewController.swift
//  Todoey
//
//  Created by AngelikaDW on 04/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["go to the movies", "meditate", "work"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row) //Prints the number of the row which was selected
        //print(itemArray[indexPath.row])
        
        //Adds checkmark Accessory to selected cell and removes it when the cell is deselected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
            
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

