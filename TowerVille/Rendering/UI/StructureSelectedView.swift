//
//  StructureSelectedModel.swift
//  TowerVille
//
//  Created by Jason Cheung on 2018-03-20.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class StructureSelectedView : UIView
{
    @IBOutlet var view: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var upgradeCostLabel: UILabel!
    @IBOutlet var repairCostLabel: UILabel!
    @IBOutlet var sellCostLabel: UILabel!
    
    var viewController : ViewController?
    
    
    func displayContent(_ structure : Structure)
    {
        let sType = type(of: structure)
        nameLabel.text = sType.NAME + " Lv." + String(structure.level)
        upgradeCostLabel.text = String(structure.upgradeCost)
        repairCostLabel.text = String(structure.getRepairCost())
        sellCostLabel.text = String(structure.getSellCost())
    }
    
    
    // Pass UI action to ViewController
    @IBAction func onButtonPress(_ sender: UIButton) {
        viewController?.onButtonPress(sender)
    }
    

    // Note: Below 3 functions load xib and show in storyboard
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        let bundle = Bundle(for: type(of: self))
        UINib(nibName: "StructureSelectedView", bundle: bundle).instantiate(withOwner: self, options: nil)
        
        addSubview(view)
        view.frame = bounds
    }

}
