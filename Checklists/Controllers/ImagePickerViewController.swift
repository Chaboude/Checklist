//
//  ImagePickerViewController.swift
//  Checklists
//
//  Created by iem on 27/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

protocol ImagePickerViewControllerDelegate : class {
    func imagePickerViewControllerDidCancel(_ controller: ImagePickerViewController)
    func imagePickerViewController(_ controller: ImagePickerViewController, didFinishAddingItem icon: IconAsset)
}

class ImagePickerViewController: UITableViewController {
    
    var delegate: ImagePickerViewControllerDelegate?
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.imagePickerViewControllerDidCancel(self)
    }
    

    
}

