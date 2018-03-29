//
//  AddItemViewController.swift
//  Checklists
//
//  Created by iem on 08/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var toDoItem: UITextField!
    var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    @IBAction func done(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = toDoItem.text!
            self.delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        }
        else{
            self.delegate?.itemDetailViewController(self, didFinishAddingItem: ChecklistItem(text: self.toDoItem.text!))
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.toDoItem.becomeFirstResponder()
        self.toDoItem.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.delegate != nil){
            navigationItem.title = "Edit Item"
            toDoItem.text = itemToEdit?.text
        }
    }
    
    //MARK: delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,with: string)
            navigationItem.rightBarButtonItem?.isEnabled = (newString.count == 0) ? false : true
        }
        return true
    }
}
