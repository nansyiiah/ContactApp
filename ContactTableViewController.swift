//
//  ViewController.swift
//  ContactApp
//
//  Created by Adrian K on 26/05/22.
//

import UIKit
import CoreData

class ContactTableViewController: UITableViewController{

    var contacts: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    func loadData(){
        //set up core data context
        let context = appDelegate.persistentContainer.viewContext
        //set up request
        let request = NSFetchRequest<NSManagedObject>(entityName: "UserListItem")
        //exe
        do{
            contacts = try context.fetch(request)
        }catch let err as NSError{
            print("Could not fetch data because \(err), \(err.userInfo)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactCount: Int = contacts.count
        return contactCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableCell", for: indexPath)
        
        let row: Int = indexPath.row
        let contact = contacts[row] as? UserListItem
        cell.textLabel?.text = contact?.firstName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedContact = contacts[indexPath.row] as? UserListItem
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ContactViewController")
                as? ContactViewController
            controller?.currentUser = selectedContact
            self.navigationController?.pushViewController(controller!, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Delete the row from the data source
              let contact = contacts[indexPath.row] as? UserListItem
              let context = appDelegate.persistentContainer.viewContext
              context.delete(contact!)
              do {
                  try context.save()
              }
              catch {
                  fatalError("Error saving context: \(error)")
              }
              loadData()
              tableView.deleteRows(at: [indexPath], with: .fade)
          } else if editingStyle == .insert {
              // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
          }
      }
}
