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
    var tabChecklistItem = [ChecklistItem]()
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return documentDirectory.appendingPathComponent("CheckLists").appendingPathExtension("json")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = list.name
    }
    
    override func awakeFromNib() {
        loadChecklistItems()
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
        saveChecklistItems()
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
            editItemVC?.itemToEdit = tabChecklistItem[index.row]
            editItemVC?.delegate = self
        }
    }
    
    
    @IBAction func addDummyTodo(_ sender: Any) {
        self.tabChecklistItem.append(ChecklistItem(text: "Le petit Nicolas"))
        let indexPath : IndexPath = IndexPath(row: self.tabChecklistItem.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveChecklistItems(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(tabChecklistItem)
        try? data?.write(to: dataFileUrl)
        print(String(data: data!, encoding: .utf8)!)
    }
    
    func loadChecklistItems(){
        let decoder = JSONDecoder()
        do{
            let s = try String(contentsOf: dataFileUrl, encoding: .utf8).data(using: .utf8)
            let data = try decoder.decode([ChecklistItem].self, from:s!)
            self.tabChecklistItem = data
        }
        catch{}
    }
    
}

// MARK: - ItemDetailViewControllerDelegate
extension ChecklistViewController: ItemDetailViewControllerDelegate{
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        tabChecklistItem.append(item)
        let indexPath : IndexPath = IndexPath(row: tabChecklistItem.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem){
        let itemIndex = tabChecklistItem.index(where:{ $0 === item })!
        tableView.reloadRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
        saveChecklistItems()
    }
}



