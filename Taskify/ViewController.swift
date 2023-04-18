//
//  ViewController.swift
//  Taskify
//
//  Created by Sayor Debbarma on 18/04/23.
//

import UIKit

class ViewController: UITableViewController {
    
    let ItemsArray = ["Do coding",  "watch anime", "DO more works"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCall", for: indexPath)
        
        cell.textLabel?.text = ItemsArray[indexPath.row]
        
        return cell
    }

}

