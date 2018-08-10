//
//  CategoryVC.swift
//  Todoey App
//
//  Created by Ajinkya Sonar on 10/08/18.
//  Copyright © 2018 Ajinkya Sonar. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchData()
    }

    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// Mark: - TableView Data Source and Delegate Methods

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let individualCategory = categories[indexPath.row]
        
        cell.textLabel?.text = individualCategory.name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ItemVC") as! ItemVC
        
        destinationVC.selectedCategory = categories[indexPath.row]
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
    }
    
    
    
    
    
}

// Mark: - Core Data Functionality

extension CategoryVC {
    
    func saveData() {
        
        do{
            
            try self.context.save()
        } catch{
            
            print("Unable to save Category Data", error.localizedDescription)
        }
        
        self.tableView.reloadData()
        
    }
    
    
    
    func fetchData() {
        
        do{
            
            categories = try context.fetch(Category.fetchRequest())
            
        } catch{
            
            print("Unable to fetch category data", error.localizedDescription)
        }
        
        tableView.reloadData()
        
    }
    
}











