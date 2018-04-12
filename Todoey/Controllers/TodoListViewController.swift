//
//  ViewController.swift
//  Todoey
//
//  Created by AngelikaDW on 04/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //If toDoItems is not nill then do the following:
        if let item = toDoItems?[indexPath.row] {
            //Current item (the value of the cell) in the tableview
            cell.textLabel?.text = item.title
            
            // Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else { //if it is nill or it fails
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //UPDATE IN CRUD
        
        //check if the toDoList Item at this row is not nill
        if let item = toDoItems?[indexPath.row] {
            do {
                //if it is not nill, then we pick the done property and change it to its opposite
                //realm.write updates the DB
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
            
            tableView.reloadData()
            
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
            //Check if thethe selectedCategory is not nill
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        //Done is set to false default in the Item class
                        //Date created is set already to Date() in the Item 
                        //items is a List of Item Objects created in the Class Category
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
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
    
    // MARK - Model Manipulation Method
    
    func loadItems(){
     
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
}

////MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            //dismiss the searchbar as first Responder
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


