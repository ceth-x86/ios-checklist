//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by demas on 06/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(controller: ItemDetailViewController);
    func addItemViewController(controller: ItemDetailViewController,
                                                                        didFinishAddingItem item: CheckListItem)
    func addItemViewController(controller: ItemDetailViewController,
                               didFinishEditingItem item: CheckListItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddItemViewControllerDelegate?
    var itemToEdit: CheckListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = newText.length > 0
        return true
    }
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text ?? ""
            delegate?.addItemViewController(controller: self, didFinishEditingItem: item)
        } else {
            let item = CheckListItem()
            item.text = textField.text ?? ""
            item.checked = false
            delegate?.addItemViewController(controller: self, didFinishAddingItem: item)
        }
    }

}
