//
//  ItemVC.swift
//  Todoey App
//
//  Created by Ajinkya Sonar on 09/08/18.
//  Copyright © 2018 Ajinkya Sonar. All rights reserved.
//

import UIKit
import CoreData

class ItemVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchData()
    }
    
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text
            newItem.done = false
            newItem.date = Date()
            newItem.parentCategory = self.selectedCategory
            
            self.items.append(newItem)
            
            do{
                try self.context.save()
                
            } catch{
                
                print("Unable to save data", error.localizedDescription)
            }
            
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

// Mark: - TableView Functions and Delegate Methods

extension ItemVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        
        cell.titleLbl.text = item.title
        
        cell.dateLbl.text = DateFormatter.localizedString(from: item.date!, dateStyle: .medium, timeStyle: .medium)
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            context.delete(items[indexPath.row])
            
            items.remove(at: indexPath.row)
            
            do{
                
                try context.save()
            } catch {
                
                print("Unable to delete data", error.localizedDescription)
            }
            
            tableView.reloadData()
            
        }
    }
    
    
}

// Mark: - Search Bar Functionality

extension ItemVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchData(with: request, predicate: predicate)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        fetchData()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchBar.text?.count == 0 {
            
            fetchData()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
            
        }
        
        
    }
    
    
}


// Mark: - Core Data Functionality

extension ItemVC {
    
    func fetchData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (self.selectedCategory!.name!))
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        }
        else {
            
            request.predicate = categoryPredicate
        }
        
        do {
            
            items = try context.fetch(request)
            
        } catch {
            
            print("Unable to Fetch Data", error.localizedDescription)
        }
        
        tableView.reloadData()
        
    }
    
    
    
}












