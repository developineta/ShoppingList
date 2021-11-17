//
//  InfoViewController.swift
//  ShoppingList
//
//  Created by ineta.magone on 17/11/2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var infoText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !infoText.isEmpty{
            descriptionLabel.text = infoText
        }
    }
}
