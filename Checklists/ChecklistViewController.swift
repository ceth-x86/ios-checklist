//
//  ViewController.swift
//  Checklists
//
//  Created by demas on 06/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {

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
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureTextForLabel(cell: UITableViewCell, withChecklistItem item: CheckListItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}

