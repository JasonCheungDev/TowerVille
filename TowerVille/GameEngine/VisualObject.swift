//
//  VisualObject.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

import Foundation


class VisualObject : GameObject{
    
    var RenderObject : RenderObject?
    
    func LinkRenderObject(_ renderObj : RenderObject)
    {
        self.RenderObject?.gameObject = nil // unlink RO if one is already set
        self.RenderObject = renderObj
        renderObj.gameObject = self
    }
    
    func UnlinkRenderObject()
    {
        self.RenderObject?.gameObject = nil // unlink RO if set
        self.RenderObject = nil
    }
    
    /* Consider below. This would allow RO's to be shared across multiple VO's. 
     func Draw()
     {
        RenderObject.SetVisualObject(self);
        RenderObject.Draw();
        RenderObject.SetVisualObject(null);    // optional
     }
     */
    
}
