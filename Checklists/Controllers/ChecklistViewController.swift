//
//  ViewController.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit


class ChecklistViewController: UITableViewController {
    
    var list: CheckList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = list.name
    }
    
    //MARK: - Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        configureCheckmark(for: cell, withItem: list.items[indexPath.row])
        configureText(for: cell, withItem: list.items[indexPath.row])
        return cell
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let item = list.items[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for:cell , withItem: item)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        list.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DataModel.sharedInstance.cachedItems[indexPath.row] = list
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
            let addItemVC = segueDestination?.topViewController as? ItemDetailViewController
            addItemVC?.delegate = self
        }
        else if(segue.identifier == "editItem"){
            let segueDestination = segue.destination as? UINavigationController
            let editItemVC = segueDestination?.topViewController as? ItemDetailViewController
            let index = tableView.indexPath(for: sender as! ChecklistItemCell)!
            editItemVC?.itemToEdit = list.items[index.row]
            editItemVC?.delegate = self
        }
    }
    
    
    @IBAction func addDummyTodo(_ sender: Any) {
        self.list.items.append(ChecklistItem(text: "Le petit Nicolas"))
        let indexPath : IndexPath = IndexPath(row: self.list.items.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}

// MARK: - ItemDetailViewControllerDelegate
extension ChecklistViewController: ItemDetailViewControllerDelegate{
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        list.items.append(item)
        let indexPath : IndexPath = IndexPath(row: list.items.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
        DataModel.sharedInstance.sortChecklists()
        tableView.reloadData()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem){
        let itemIndex = list.items.index(where:{ $0 === item })!
        tableView.reloadRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
        DataModel.sharedInstance.cachedItems[itemIndex] = list
        DataModel.sharedInstance.sortChecklists()
        tableView.reloadData()
    }
}



