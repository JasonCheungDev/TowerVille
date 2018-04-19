//
//  UIModelTower.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-02-28.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import UIKit

class UIModelStructure
{
    var image : UIImage = UIImage(named: "wip.png")!
    var name : String = "Structure"
    var description : String = "A generic structure"
    var cost : Int = 0
    var actionType : UIActionType = UIActionType.NOT_IMPLEMENTED
    
    
    init() {}
    
    init(fromType Structure : Structure.Type)
    {
        name = Structure.NAME
        cost = Structure.COST
        image = UIImage(named: Structure.ICON)!
    }
}
