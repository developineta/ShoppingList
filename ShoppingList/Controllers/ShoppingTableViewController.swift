//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by ineta.magone on 17/11/2021.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    var shopping = [Shopping]()
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Shopping> = Shopping.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            shopping = result!
            tableView.reloadData()
        }catch{
            fatalError("error in loading core data item")
        }
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
        }catch{
            fatalError("error in saving in core data item")
        }
        loadData()
    }
    
    func deleteAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        let delete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try managedObjectContext?.execute(delete)
            saveData()
        }catch let err {
            print(err.localizedDescription)
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Shopping Item", message: "What do you want to add?", preferredStyle: .alert)
       
        
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                textField.placeholder = "item name..."

            })

            // add textfield at index 1
            alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                textField.placeholder = "quantity..."
            })
        
        let addActionButton = UIAlertAction(title: "Add", style: .default) { action in
            let itemField = alertController.textFields?[0]
            let quantityField = alertController.textFields?[1]
            
            let entity = NSEntityDescription.entity(forEntityName: "Shopping", in: self.managedObjectContext!)
            let shop = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            shop.setValue(itemField?.text, forKey: "item")
            shop.setValue(quantityField?.text, forKey: "count")
         
            
            self.saveData()
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func deleteItems(_ sender: Any) {
        if shopping.count != 0 {
            let alertController = UIAlertController(title: "Delete All Shopping items?", message: "Do you want to delete them all?", preferredStyle: .actionSheet)
            let addActionButton = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.deleteAllData()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(addActionButton)
            alertController.addAction(cancelButton)
            
            present(alertController, animated: true, completion: nil)
        }else{
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shopping.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        let shop = shopping[indexPath.row]
        cell.textLabel?.text = "Item:  \(shop.value(forKey: "item") ?? "")"
        cell.detailTextLabel?.text = "Count: \(shop.value(forKey: "count") ?? "")"
        cell.accessoryType = shop.completed ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view delegate
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(shopping[indexPath.row])
        }
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shopping[indexPath.row].completed = !shopping[indexPath.row].completed
        saveData()
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "shopping"{
             // Get the new view controller using segue.destination.
             let vc = segue.destination as! InfoViewController
             // Pass the selected object to the new view controller.
             vc.infoText = "\tThis is an amazing shopping application that lets You choose anything You want! By anything we mean from pencil ✏️ to airplane ✈️\n\tAnything from A to Z. Additionally you can choose any quantity for your order. We will take care for the rest.\nEnjoy Your Shopping! 😊"
         }
     }
 }

    


