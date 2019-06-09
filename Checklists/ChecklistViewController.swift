//
//  ViewController.swift
//  Checklists
//
//  Created by demas on 06/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, AddItemViewControllerDelegate {

    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = checklist.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem") as! UITableViewCell
        let item = checklist.items[indexPath.row]
        configureTextForLabel(cell: cell, withChecklistItem: item)
        configureCheckmarkForCell(cell: cell, withCheclistItem: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell: cell, withCheclistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withCheclistItem  item: CheckListItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
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
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func addItemViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForLabel(cell: cell, withChecklistItem: item)
            }
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        if segue.identifier == "EditItem" {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}

