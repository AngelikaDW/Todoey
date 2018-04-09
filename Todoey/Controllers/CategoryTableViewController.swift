//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by AngelikaDW on 09/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row] //Current item (the value of the cell) in the tableview
        
        cell.textLabel?.text = category.name
        return cell
        
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Data manipulation Methods
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        //reload data to show added item
        self.tableView.reloadData()
    }
    //external and internal parameters and also a default value
    func loadCategory(with request: NSFetchRequest<Category>  = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error catching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add new Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "So much to do", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //Completion Block: what will happen once the user clicks the add item button on the alert
            
            let newCategory = Category(context: self.context) //Is the row inside the table
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
