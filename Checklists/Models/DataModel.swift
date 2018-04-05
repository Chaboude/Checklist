//
//  DataModel.swift
//  Checklists
//
//  Created by iem on 05/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class DataModel {
    
    var cachedItems: [CheckList]
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return documentDirectory.appendingPathComponent("Checklists").appendingPathExtension("json")
    }
    
    static let sharedInstance = DataModel()
    
    private init(){
        self.cachedItems = []
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(save),
            name: .UIApplicationDidEnterBackground,
            object: nil)
    }
    
    @objc func save(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(cachedItems)
        try? data?.write(to: dataFileUrl)
        print(String(data: data!, encoding: .utf8)!)
    }
    
    func load(){
        let decoder = JSONDecoder()
        do{
            let s = try String(contentsOf: dataFileUrl, encoding: .utf8).data(using: .utf8)
            let data = try decoder.decode([CheckList].self, from:s!)
            self.cachedItems = data
        }
        catch{}
    }
    
    func sortChecklists(){
        self.cachedItems = cachedItems.sorted{ $0.name.localizedStandardCompare($1.name) == ComparisonResult.orderedAscending}
        for list in cachedItems{
            list.items = list.items.sorted{ $0.text.localizedStandardCompare($1.text) == ComparisonResult.orderedAscending}
        }
    }
    
}
