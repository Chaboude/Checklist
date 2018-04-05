//
//  CheckList.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CheckList {
    var items = [ChecklistItem]()
    var name: String
    
    init(name: String, items: [ChecklistItem] = [])
    {
        self.name = name
        self.items = items
    }
}
