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
        self.lists.append(CheckList(name: "Liste 1"))
        self.lists.append(CheckList(name: "Liste 2"))
        self.lists.append(CheckList(name: "Liste 3"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewList") {
            let segueDestination = segue.destination as? ChecklistViewController
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            segueDestination?.list = lists[index.row]
        }
    }

}
