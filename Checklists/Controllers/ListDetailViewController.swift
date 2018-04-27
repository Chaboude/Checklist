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
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var toDoList: UITextField!
    @IBOutlet weak var labelIcon: UILabel!
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.toDoList.becomeFirstResponder()
        self.toDoList.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let listToEdit = listToEdit{
            navigationItem.title = "Edit List"
            labelIcon.text = listToEdit.icon.rawValue
            image.image = listToEdit.icon.image
        }
        else{
            navigationItem.title = "Add List"
            labelIcon.text = IconAsset.NoIcon.rawValue
            image.image = IconAsset.NoIcon.image
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "chooseIcon") {
            let segueDestination = segue.destination as? ImagePickerViewController
            segueDestination?.delegate = self
        }
    }
    
    

}

// MARK: - listDetailViewControllerDelegate
extension ListDetailViewController: ImagePickerViewControllerDelegate{
    func imagePickerViewControllerDidCancel(_ controller: ImagePickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func imagePickerViewController(_ controller: ImagePickerViewController, didFinishAddingItem icon: IconAsset) {
        /**/
    }
}
