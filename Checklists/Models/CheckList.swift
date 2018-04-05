//
//  CheckList.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CheckList : Codable {
    var items = [ChecklistItem]()
    var name: String
    var icon: IconAsset
    var uncheckedItemsCount: Int{
        get{
            var nbChecked: Int = 0
            for item in items{
                if(item.checked){
                    nbChecked += 1
                }
            }
            return nbChecked
        }
    }
    
    init(name: String, items: [ChecklistItem] = [], icon: IconAsset = IconAsset.NoIcon)
    {
        self.name = name
        self.items = items
        self.icon = icon
    }
}
