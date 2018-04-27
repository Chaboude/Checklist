//
//  ImagePickerViewController.swift
//  Checklists
//
//  Created by iem on 27/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

protocol ImagePickerViewControllerDelegate : class {
    func imagePickerViewControllerDidCancel(_ controller: ItemDetailViewController)
    func imagePickerViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func imagePickerViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ImagePickerViewController: UITableViewController {
    
    
}

