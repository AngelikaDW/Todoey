//
//  ViewController.swift
//  Todoey
//
//  Created by AngelikaDW on 04/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
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
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        //Set the title in the nav bar
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else {fatalError() }
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBar(withHexCode: "1D9BF6")
    }

    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String){
         guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        //Style the searchBar appearance no borders and same color to match the scheme
        searchBar.barTintColor = navBarColor
        searchBar.backgroundImage = UIImage()
        
    }
    
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get cell from the super class SwipeTableVC - inherenting from super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        //TODO: Introduce the edit function for the text in the cell!
        
        //If toDoItems is not nill then do the following:
        if let item = toDoItems?[indexPath.row] {
            //Current item (the value of the cell) in the tableview
            cell.textLabel?.text = item.title
            
            //Create a gradient color scheme, based on the nbr of items the color gets darkend
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                
                cell.backgroundColor = color
                //Contrasting Text color white or black
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                //Set the color of the accessoryType (checkmark) to the color
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
            
            // Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
            
            
        } else { //if it is nill or it fails
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            //Check if the selectedCategory is not nill
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
        
        tableView.reloadData()
    }
    
   //MARK: - Delete Categories with Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }catch {
                print("Error deleting TodoItem: \(error)")
            }
        }
    }
}



//MARK: - Search bar methods

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


