//
//  ViewController.swift
//  Taskify
//
//  Created by Sayor Debbarma on 18/04/23.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var ItemsArray = ["Do coding", "watch anime", "DO more works"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // to retrive data
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            ItemsArray = items
        }
        
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = ItemsArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen if we click the add button
            self.ItemsArray.append(textField.text!)
            
            //to prevent memory lost after app terminate
            self.defaults.set(self.ItemsArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData() // to show append item in the tableView
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Create new Task"
            textField = addTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

