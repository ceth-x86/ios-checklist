//
//  ViewController.swift
//  Checklists
//
//  Created by demas on 06/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, AddItemViewControllerDelegate {

    var items: [CheckListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadChecklistItems()
    }
    
    func loadChecklistItems() {
        
        let path = dataFileDir()
        if FileManager.default.fileExists(atPath: path.path) {
            let data = NSData.init(contentsOfFile: path.path)
            
            do {
                if let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data! as Data) as? [CheckListItem] {
                    items = result
                }                
            } catch {
                print("couldn't read file")
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem") as! UITableViewCell
        let item = items[indexPath.row]
        configureTextForLabel(cell: cell, withChecklistItem: item)
        configureCheckmarkForCell(cell: cell, withCheclistItem: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell: cell, withCheclistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withCheclistItem  item: CheckListItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForLabel(cell: UITableViewCell, withChecklistItem item: CheckListItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    func addItemViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
        saveChecklistItems()
    }
    
    func addItemViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForLabel(cell: cell, withChecklistItem: item)
            }
        }
        
        dismiss(animated: true, completion: nil)
        saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        if segue.identifier == "EditItem" {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // store
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFileDir() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        
        print("save \(dataFileDir())")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
            try data.write(to: dataFileDir())
        } catch {
            print("couldn't write file")
        }
    }
}

