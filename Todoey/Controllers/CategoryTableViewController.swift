//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by AngelikaDW on 09/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    var realm: Realm!
    
    var categories: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        loadCategories()
        
        tableView.separatorStyle = .none
    

    }
    
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //Nil Coalescing Operator: if it is nil, jsut return 1
        //Save way to operate with the Optional, that could be nil
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get cell from the super class SwipeTableVC - inherenting from super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //Default value NIL COALESCING OPERATOR
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].color)!) ?? UIColor.flatLime
        
       //Set the textColor to contrast the backgroundColor
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
        
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //print("This is the row clicked: \(categoryArray[indexPath.row])")
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //MARK: - Data manipulation Methods
    
    // Parameter is category of the Type Category (Obejct class)
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        //reload data to show added item
        self.tableView.reloadData()
    }
  
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

    //MARK: - Delete Categories with Swipe
    //by calling and overriding SuperClass method  updateModel(at: indexPath)
    
    override func updateModel(at indexPath: IndexPath) {
        //call the superclass method
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category status: \(error)")
            }
        }
    }
    
    
    //MARK: - Add new Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "So much to do", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //Completion Block: what will happen once the user clicks the add item button on the alert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

