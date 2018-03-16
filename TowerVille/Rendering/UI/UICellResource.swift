//
//  UICellResource.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-01.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import UIKit

class UICellResource: UICollectionViewCell {
    
    @IBOutlet var towerImage: UIImageView!
    @IBOutlet var towerLabel: UILabel!
    
    func displayContent(image: UIImage, title: String)
    {
        towerImage.image = image
        towerLabel.text = title
    }
    
}
