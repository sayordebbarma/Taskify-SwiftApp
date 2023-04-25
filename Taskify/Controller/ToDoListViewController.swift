//
//  ViewController.swift
//  Taskify
//
//  Created by Sayor Debbarma on 18/04/23.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var ItemsArray = [Item]()
    //["Do coding", "watch anime", "DO more works"]
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let newItem = Item()
        newItem.title = "Do coding"
        ItemsArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Watch anime"
        ItemsArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Do laundry"
        ItemsArray.append(newItem2)
        
        
        // to retrive data
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            ItemsArray = items
        }
        
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = ItemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if ItemsArray[indexPath.row].done == false {
//            ItemsArray[indexPath.row].done = true
//        } else {
//            ItemsArray[indexPath.row].done = false
//        }
        
        ItemsArray[indexPath.row].done = !ItemsArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen if we click the add button
            let newItem = Item()
            newItem.title = textField.text!
            
            self.ItemsArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Create new Task"
            textField = addTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: - model manupulation methods
    
    func saveItems() {
        //to prevent memory lost after app terminate
        //self.defaults.set(self.ItemsArray, forKey: "ToDoListArray")
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(ItemsArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding the task: \(error)")
        }
        
        self.tableView.reloadData() // to show append item in the tableView
    }
}

