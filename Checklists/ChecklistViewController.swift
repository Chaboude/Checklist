//
//  ViewController.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit




class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {

    var tabChecklistItem = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabChecklistItem.append(ChecklistItem(text: "Go BloodBorne", checked: true))
        self.tabChecklistItem.append(ChecklistItem(text: "Go Guilty Gear"))
        self.tabChecklistItem.append(ChecklistItem(text: "Go Horizon"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tabChecklistItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        configureCheckmark(for: cell, withItem: tabChecklistItem[indexPath.row])
        configureText(for: cell, withItem: tabChecklistItem[indexPath.row])
        return cell
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let item = tabChecklistItem[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for:cell , withItem: item)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tabChecklistItem.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, withItem item: ChecklistItem) {
        let myCell = cell as! ChecklistItemCell
        myCell.labelChecked.isHidden = (item.checked) ? false : true
        
    }
    
    func configureText(for cell: UITableViewCell, withItem item: ChecklistItem) {
        let myCell = cell as! ChecklistItemCell
        myCell.labelToDo?.text = item.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addItem") {
            let segueDestination = segue.destination as? UINavigationController
            let addItemVC = segueDestination?.topViewController as? AddItemViewController
            addItemVC?.delegate = self
        }
        else if(segue.identifier == "editItem"){
            let segueDestination = segue.destination as? UINavigationController
            let editItemVC = segueDestination?.topViewController as? AddItemViewController
            let index = tableView.indexPath(for: sender as! ChecklistItemCell)!
            editItemVC?.itemToEdit = tabChecklistItem[index.row]
            editItemVC?.delegate = self
        }
    }
    
    
    @IBAction func addDummyTodo(_ sender: Any) {
        self.tabChecklistItem.append(ChecklistItem(text: "Le petit Nicolas"))
        let indexPath : IndexPath = IndexPath(row: self.tabChecklistItem.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}

extension ChecklistViewController {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        controller.dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
        tabChecklistItem.append(item)
        let indexPath : IndexPath = IndexPath(row: tabChecklistItem.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem){
        /*let index = tabChecklistItem.index(where: { $0 == item })
        tabChecklistItem[index!].text = item.text
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: IndexPath(row: index!, section: 0))
        configureText(for: cell, withItem: tabChecklistItem[index!])
        tableView.reloadData()
        dismiss(animated: true, completion: nil)*/
        let itemIndex = tabChecklistItem.index(where:{ $0 === item })!
        tableView.reloadRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
    }
}



