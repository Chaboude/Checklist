//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingList list: CheckList)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingList list: CheckList)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var toDoList: UITextField!
    var delegate: ListDetailViewControllerDelegate?
    var listToEdit: CheckList?
    
    @IBAction func done(_ sender: Any) {
        if let listToEdit = listToEdit {
            listToEdit.name = toDoList.text!
            self.delegate?.listDetailViewController(self, didFinishEditingList: listToEdit)
        }
        else{
            self.delegate?.listDetailViewController(self, didFinishAddingList: CheckList(name: self.toDoList.text!))
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.listDetailViewControllerDidCancel(self)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.toDoList.becomeFirstResponder()
//        self.toDoList.delegate = self
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let listToEdit = listToEdit{
            navigationItem.title = "Edit List"
            toDoList.text = listToEdit.name
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
