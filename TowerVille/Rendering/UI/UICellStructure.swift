//
//  UICellTower.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-28.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import UIKit

class UICellStructure: UICollectionViewCell {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var label: UILabel!
    
    func displayContent(image: UIImage, title: String)
    {
        self.icon.image = image
        self.label.text = title
    }
    
}
