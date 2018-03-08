//
//  ChecklistItem.swift
//  Checklists
//
//  Created by iem on 08/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text: String
    var checked: Bool
    
    init(text: String, checked: Bool? = false){
        self.text = text
        self.checked = checked!
    }
    
    func toggleChecked() {
        self.checked = !checked
    }
    
}
