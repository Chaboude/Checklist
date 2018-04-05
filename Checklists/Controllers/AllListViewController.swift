//
//  AllListViewController.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {
    
    var lists = [CheckList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        DataModel.sharedInstance.load()
        self.lists = DataModel.sharedInstance.cachedItems
        DataModel.sharedInstance.sortChecklists()
    }
    
    //MARK: - Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataModel.sharedInstance.sortChecklists()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name
        if(lists[indexPath.row].items.count == 0){
            cell.detailTextLabel?.text = "No items"
        }
        else if(lists[indexPath.row].uncheckedItemsCount == lists[indexPath.row].items.count){
            cell.detailTextLabel?.text = "All Done !"
        }
        else {
            cell.detailTextLabel?.text = "\(lists[indexPath.row].items.count - lists[indexPath.row].uncheckedItemsCount) Remaining"
        }
        cell.imageView?.image = lists[indexPath.row].icon.image
        return cell
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lists[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DataModel.sharedInstance.cachedItems = lists
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewList") {
            let segueDestination = segue.destination as? ChecklistViewController
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            segueDestination?.list = lists[index.row]
        }
        else if(segue.identifier == "addChecklist"){
            let segueDestination = segue.destination as? UINavigationController
            let addItemVC = segueDestination?.topViewController as? ListDetailViewController
            addItemVC?.delegate = self
        }
        else if (segue.identifier == "editChecklist"){
            let segueDestination = segue.destination as? UINavigationController
            let editItemVC = segueDestination?.topViewController as? ListDetailViewController
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            editItemVC?.listToEdit = lists[index.row]
            editItemVC?.delegate = self
        }
    }

}

// MARK: - listDetailViewControllerDelegate
extension AllListViewController: ListDetailViewControllerDelegate{
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingList list: CheckList) {
        lists.append(list)
        let indexPath : IndexPath = IndexPath(row: lists.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
        DataModel.sharedInstance.cachedItems = lists
        DataModel.sharedInstance.sortChecklists()
        lists = DataModel.sharedInstance.cachedItems
        tableView.reloadData()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingList list: CheckList) {
        let listIndex = lists.index(where:{ $0 === list })!
        tableView.reloadRows(at: [IndexPath(row: listIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
        DataModel.sharedInstance.cachedItems = lists
        DataModel.sharedInstance.sortChecklists()
        lists = DataModel.sharedInstance.cachedItems
        tableView.reloadData()
    }
}
