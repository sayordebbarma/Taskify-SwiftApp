//
//  ViewController.swift
//  Taskify
//
//  Created by Sayor Debbarma on 18/04/23.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var ItemsArray = [Items]()
    // to get access to our AppDelegate as an object -> (UIApplication.shared.delegate as! AppDelegate)
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
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
        
//        context.delete(ItemsArray[indexPath.row])
//        ItemsArray.remove(at: indexPath.row)
        
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
                        
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
        do {
            try context.save()
        } catch {
            print("Error saving the context: \(error)")
        }
        
        self.tableView.reloadData() // to show append item in the tableView
    }
    
    func loadItems(with request: NSFetchRequest<Items> = Items.fetchRequest()) {
//        let request : NSFetchRequest<Items> = Items.fetchRequest()
        do {
            ItemsArray = try context.fetch(request)
        } catch {
            print("Error loading: \(error)")
        }
    }
}

//MARK: - searchBarDelegate extension
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
        tableView.reloadData()
    }
}
