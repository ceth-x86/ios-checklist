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
        
        let row0item = CheckListItem()
        row0item.text = "one"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = CheckListItem()
        row1item.text = "two"
        row1item.checked = false
        items.append(row1item)
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
    }
    
    func addItemViewControllerDidCancel(controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemTableViewController, didFinishAddingItem item: CheckListItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemTableViewController, didFinishEditingItem item: CheckListItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForLabel(cell: cell, withChecklistItem: item)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! AddItemTableViewController
            controller.delegate = self
            
        if segue.identifier == "EditItem" {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}

