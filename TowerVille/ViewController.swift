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

    @IBOutlet var debugDisplay: UILabel!
    
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    
    var shader : ShaderProgram!
   
    var debugVisualObjects : [VisualObject] = []
    
    //initilization
    override func viewDidLoad() {
        super.viewDidLoad()

        // pregame setup
        setupGLcontext()
        setupCamera()       // this retrieves aspect ratio for all Camera objects

        // init updater and game
        setupGLupdater()
        
//        setupShader()
//        debug_SetupCamera()
//        debug_SetupRenderObject()
//        debug_SetupTiledMap()
//        debug_SetupLights()
    }
    
    @IBAction func OnTap(_ sender: UITapGestureRecognizer)
    {
        if sender.state == .ended
        {
            let touchLocation = sender.location(in:sender.view)
            let x = Float(touchLocation.x / sender.view!.frame.width)
            let y = Float(0.5 - touchLocation.y / sender.view!.frame.height)
            printScreenToWorld(screen_x: x, screen_y: y)
            StateMachine.Instance.processInput(x: x, z: y, u: Float(touchLocation.x), v: Float(touchLocation.y))
        }
    }
    
    func printScreenToWorld(screen_x: Float, screen_y: Float)
    {
        // undo scaling
        let temp_x = screen_x * 2 / Camera.ActiveCamera!.projectionMatrix.m00
        var temp_z = screen_y * 2 / Camera.ActiveCamera!.projectionMatrix.m11
        
        // undo second rotation
        temp_z *= sqrt(3)
        
        // undo first rotation
        var world_x = (temp_x - temp_z) / sqrt(2)
        var world_z = -(temp_x + temp_z) / sqrt(2)
        
        // undo first rotation
        world_x += Float(DebugData.Instance.displaySize - 2) / 2
        world_z -= Float(DebugData.Instance.displaySize - 2) / 2
        
        print("world x : \(world_x)")
        print("world z : \(world_z)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.2, 0.4, 0.6, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))

        StateMachine.Instance.draw()
        
//         shader.prepareToDraw()
//        for vo in debugVisualObjects
//        {
//            vo.draw()
//        }
    }

    func debug_updateUiDisplay(_ text : String)
    {
        debugDisplay.text = text 
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
    
    func setupCamera()
    {
        let aspectRatio = self.view.frame.width / self.view.frame.height
        Camera.initialize(aspectRatio)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupShader() {
        self.shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "MarkusFragmentShader.glsl")
    }
    
    func debug_SetupCamera()
    {
        let aspectRatio = self.view.frame.width / self.view.frame.height
        print("Aspect ratio \(aspectRatio)")
        
        Camera.initialize(aspectRatio)
        var cam = OrthoCamPrefab(viewableTiles: 10)
        Camera.ActiveCamera = cam
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
        vo.linkRenderObject(ro)
        vo.x = 8
        vo.z = -4
        vo.xRot = 15
        
        let vo2 = VisualObject()
        vo2.linkRenderObject(ro2)
        vo2.x = 12
        vo2.z = -4
        vo2.yRot = 55
        
        // TODO: Should be auto gen by GameObject
        vo.id = "Debug VO 1"
        vo2.id = "Debug VO 2"
        let vo3 = VisualObject()
        vo3.linkRenderObject(ro3)
        vo3.x = 8
        vo3.z = -12
        vo3.xRot = 60

        let vo4 = VisualObject()
        vo4.linkRenderObject(ro3)
        vo4.x = 12
        vo4.z = -12
        vo4.yRot = 30
        
        let prefab = CubePrefab(shader)
        prefab.x = 10
        prefab.z = -10
    
        self.debugVisualObjects.append(vo)
        self.debugVisualObjects.append(vo2)
        self.debugVisualObjects.append(vo3)
        self.debugVisualObjects.append(vo4)
        self.debugVisualObjects.append(prefab)
    }
    
    func debug_SetupLights()
    {
        var directionalLight = DirectionalLight()
        directionalLight.xDir = 1
        directionalLight.yDir = -1
        directionalLight.zDir = -1
        directionalLight.lightIntensity = 0.125
        directionalLight.lightColor = Color(1,1,1,1)
        
        var pointLight1 = PointLight()
        pointLight1.x = 4.0
        pointLight1.y = 5.0
        pointLight1.z = -4.0
        pointLight1.lightIntensity = 1.0
        pointLight1.lightColor = Color(222/255,107/255,40/255,1)
        
        var pointLight2 = PointLight()
        pointLight2.x = 14.0
        pointLight2.y = 5.0
        pointLight2.z = -14.0
        pointLight2.lightIntensity = 1.0
        pointLight2.lightColor = Color(67/255,134/255,150/255,1)
        
        var pointLight4 = PointLight()
    }
    
    func debug_SetupTiledMap()
    {
        let displaySize: Int = DebugData.Instance.displaySize // screen size in tiles
        let gridSize: Int = DebugData.Instance.gridSize // size of actual game grid data representation
        
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
                if (x + y >= gridSize / 2 && x + y < gridSize + gridSize / 2 && abs(x - y) <= gridSize / 2)
                {
                    var newTile = Tile()
                    newTile.x = Float(x)
                    newTile.z = Float(-y)
                    if (x + y == gridSize / 2 || x + y == gridSize + gridSize / 2 - 1 || abs(x - y) == gridSize / 2) {
                        newTile.linkRenderObject(mountainRo)
                    } else {
                        newTile.linkRenderObject(grassRo)
                    }
                    debugVisualObjects.append(newTile)
                }
            }
        }
        
        var objLoader : ObjLoader = ObjLoader()
        objLoader.Read(fileName : "sphere")

        var ro = RenderObject(fromShader: shader, fromVertices: objLoader.vertexDataArray, fromIndices: objLoader.indexDataArray)
        ro.material = highlightOrigin
        
        var vo = VisualObject()
        vo.x = 8
        vo.y = 4
        vo.z = -6
        vo.linkRenderObject(ro)
        
        debugVisualObjects.append(vo)
    }
}

// OPENGL DELEGATE (Update handler)
class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : GLKViewController!
    
    init(glkViewController : GLKViewController) {
        self.glkViewController = glkViewController
        StateMachine.Instance.run(state: IntroState())
    }
    
    // Update Game Logic
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        StateMachine.Instance.nextState()   // check if next state is available and switch if there is one
        StateMachine.Instance.update(dt: controller.timeSinceLastUpdate)
    }
}


