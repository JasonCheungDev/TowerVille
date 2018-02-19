//
//  ViewController.swift
//  TowerVille
//
//  Created by Daniel Tian on 2018-01-24.
//  Copyright © 2018 The-Fighting-Mongeese. All rights reserved.
//

/*
OpenGL Notes (Read this to get basic understanding of the Glkit flow)
 1. Update (game logic) - GLKViewController -> GLViewControllerDelegate -> glkViewControllerUpdate()
 2. Render (opengl)     - GLKViewController -> glkView()
 3. Draw (display on screen)        - GlkView -> Draw()
*/

/*
 Performance notes:
 - Minimize switching programs (shaders)
 - Best Practices: https://developer.apple.com/library/content/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/TechniquesforWorkingwithVertexData/TechniquesforWorkingwithVertexData.html
 - VAO's can be used as a "profile" instead of individually switching VBO's
 */

import UIKit
import GLKit

class ViewController: GLKViewController { //UIViewController

    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    
    var shader : ShaderProgram!
   
    var debugVisualObjects : [VisualObject] = []
    
    //initilization
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGLcontext()
        setupGLupdater()
        setupShader()
        
        debug_setup()
        debug_SetupRenderObject()
        debug_SetupTiledMap()
    }
    
    @IBAction func OnTap(_ sender: UITapGestureRecognizer)
    {
        if sender.state == .ended
        {
            let touchLocation = sender.location(in:sender.view)
            let x = Float(touchLocation.x / sender.view!.frame.width)
            let y = Float(0.5 - touchLocation.y / sender.view!.frame.height)
            printScreenToWorld(screen_x: x, screen_y: y)
        }
    }
    
    func printScreenToWorld(screen_x: Float, screen_y: Float)
    {
        // undo scaling
        var temp_x = screen_x * 2 / DebugData.Instance.projectionMatrix.m00
        var temp_y = screen_y * 2 / DebugData.Instance.projectionMatrix.m11
        
        // undo second rotation
        temp_y *= sqrt(3)
        
        // undo first rotation
        var world_x = (temp_x - temp_y) / sqrt(2)
        var world_y = (temp_x + temp_y) / sqrt(2)
        
        print("world x : \(world_x)")
        print("world y : \(world_y)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.2, 0.4, 0.6, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))

        
        shader.prepareToDraw()  // warning: May need to move this to the RenderObject (to ensure right shader is used)
        
        for vo in debugVisualObjects
        {
            vo.yRot += 0.05 // test normals. don't do this in real code
            vo.Draw()
        }
    }

}

// OPENGL SETUP
extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES3)! // Warning: Doesn't work on iPods
        glkView.drawableDepthFormat = .format16         // for depth testing
        EAGLContext.setCurrent(glkView.context)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupShader() {
        self.shader = ShaderProgram(vertexShader: "MarkusVertexShader.glsl", fragmentShader: "MarkusFragmentShader.glsl")
    }
    
    func debug_setup()
    {
        let aspectRatio = self.view.frame.width / self.view.frame.height
        print("Aspect ratio \(aspectRatio)")
        DebugData.Instance.initialize(aspectRatio)
    }
    
    func debug_SetupRenderObject()
    {
        let mat = LambertMaterial(self.shader)
        mat.surfaceColor = Color(1,0,0,1)
        mat.loadTexture("dungeon_01.png")
        
        let mat2 = LambertMaterial(self.shader)
        mat.surfaceColor = Color(0,1,0,1)
        
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubeVertices, fromIndices: DebugData.cubeIndices)
        ro.material = mat
        
        let ro2 = RenderObject(fromShader: shader, fromVertices: DebugData.rectVertices, fromIndices: DebugData.cubeIndices)
        ro2.material = mat2
        
        let ro3 = RenderObject(fromShader: shader, fromVertices: DebugData.rectVertices, fromIndices: DebugData.cubeIndices)
        ro3.material = mat
        
        let vo = VisualObject()
        vo.LinkRenderObject(ro)
        vo.x = 4
        vo.xRot = 15
        
        let vo2 = VisualObject()
        vo2.LinkRenderObject(ro2)
        vo2.x = 8
        vo2.yRot = 55
        
        let vo3 = VisualObject()
        vo3.LinkRenderObject(ro3)
        vo3.x = 4
        vo3.z = -8
        vo3.xRot = 60

        let vo4 = VisualObject()
        vo4.LinkRenderObject(ro3)
        vo4.x = 8
        vo4.z = -8
        vo4.yRot = 30
        
        let prefab = CubePrefab(shader)
        prefab.x = 6
        prefab.z = -6
    
        self.debugVisualObjects.append(vo)
        self.debugVisualObjects.append(vo2)
        self.debugVisualObjects.append(vo3)
        self.debugVisualObjects.append(vo4)
        self.debugVisualObjects.append(prefab)
    }
    
    func debug_SetupTiledMap()
    {
        let gridSize: Int = 10
        
        // create some materials
        let grassTileMat = LambertMaterial(shader)
        grassTileMat.surfaceColor = Color(0,1,0,1)
        
        let mountainTileMat = LambertMaterial(shader)
        mountainTileMat.surfaceColor = Color(0,0,0,1)
        
        let highlightOrigin = LambertMaterial(shader)
        highlightOrigin.surfaceColor = Color(1,0,0,1)

        // create shared RO
        let grassRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        grassRo.material = grassTileMat
        let mountainRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        mountainRo.material = mountainTileMat
        let highlightRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        highlightRo.material = highlightOrigin
        
        for x in 0..<gridSize {
            for y in 0..<gridSize {
                var newTile = Tile()
                newTile.x = Float(x)
                newTile.z = Float(-y)
                
                if (x == 0 && y == 0)
                {
                    newTile.LinkRenderObject(highlightRo)
                }
                else if (x == 0 || x == gridSize - 1 || y == 0 || y == gridSize - 1)
                {
                    newTile.LinkRenderObject(mountainRo)
                }
                else
                {
                    newTile.LinkRenderObject(grassRo)
                }

                debugVisualObjects.append(newTile)
            }
        }
    }
}

// OPENGL DELEGATE (Update handler)
class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : GLKViewController!
    var _machine : StateMachine = StateMachine()
    
    init(glkViewController : GLKViewController) {
        self.glkViewController = glkViewController
        _machine.run(state: IntroState(machine : _machine))
    }
    
    // Update Game Logic
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        _machine.nextState()
        _machine.update(dt: controller.timeSinceLastUpdate)
        // collision detection ...
        // GameManager.instance.Update()
    }
}


