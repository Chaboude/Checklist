//
//  AddItemViewController.swift
//  Checklists
//
//  Created by iem on 08/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var toDoItem: UITextField!
    var delegate: AddItemViewControllerDelegate?
    
    @IBAction func done(_ sender: Any) {
        self.delegate?.addItemViewController(self, didFinishAddingItem: ChecklistItem(text: self.toDoItem.text!))
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.addItemViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.toDoItem.becomeFirstResponder()
        self.toDoItem.delegate = self
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
