//
//  ViewController.swift
//  CoreDataNamesListLes
//
//  Created by mona aleid on 28/02/2022.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var namesArr = [ListNames]()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addedBtn: UIButton!
    @IBOutlet weak var namesListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namesListTableView.dataSource = self
        namesListTableView.delegate = self
        loadData()
        
        mainView.layer.cornerRadius = 10
        addedBtn.layer.cornerRadius = 10
    }

    @IBAction func addedBtnClick(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Create New Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            let newName = ListNames(context: self.context)
            newName.names = textField.text
            self.namesArr.append(newName)
            self.saveData()}
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Name Here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        }
    
}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return namesArr.count
       }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "namesCell", for: indexPath)
          cell.backgroundColor = .clear
          cell.textLabel?.text = namesArr[indexPath.row].names
        return cell
    
      }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Change Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Update Name", style: .default) { (action) in
            self.namesArr[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Name Here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if (editingStyle == .delete) {
        // handle delete (by removing the data from your array and updating the tableview)
        
        context.delete(namesArr[indexPath.row])
        namesArr.remove(at: indexPath.row)
        saveData()
        }
        }
    func saveData() {
          do {
          try context.save()
        } catch { print("Error saving context \(error)") }
        namesListTableView.reloadData()
        }

    func loadData() {
           let request : NSFetchRequest<ListNames> = ListNames.fetchRequest()
          do {
            namesArr = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")}
         namesListTableView.reloadData()
       }
}
