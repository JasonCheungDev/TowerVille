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
        // debug_SetupTiledMap()
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
            vo.yRot += 0.5
            vo.RenderObject?.Draw()
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
        self.shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "LambertFragmentShader.glsl")
    }
    
    func debug_setup()
    {
        let aspectRatio = self.view.frame.width / self.view.frame.height
        print("Aspect ratio \(aspectRatio)")
        DebugData.Instance.initialize(aspectRatio)
    }
    
    func debug_SetupRenderObject()
    {
        let vo = VisualObject()
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubePositionData, fromNormals: DebugData.cubeNormalData, fromIndices: DebugData.indices)
        let mat = LambertMaterial(shader)
        
        mat.SurfaceColor = Color(1,0,0,1)
        ro.Material = mat
        vo.LinkRenderObject(ro)
        vo.x = 10
        vo.yRot = 180
        
        let vo2 = VisualObject()
        let ro2 = RenderObject(fromShader: shader, fromVertices: DebugData.cubePositionData, fromNormals: DebugData.cubeNormalData, fromIndices: DebugData.indices)
        let mat2 = LambertMaterial(shader)
        mat2.SurfaceColor = Color(0,1,0,1)
        ro2.Material = mat2
        vo2.LinkRenderObject(ro2)
        vo2.y = 2
        vo2.x = 5
        vo2.xRot = 15
        vo2.yRot = 230
        
        // TODO: Should be auto gen by GameObject
        vo.ID = "Debug VO 1"
        vo2.ID = "Debug VO 2"
        
        self.debugVisualObjects.append(vo)
        self.debugVisualObjects.append(vo2)
    }
    
    func debug_SetupTiledMap()
    {
        let gridSize: Int = 10
        // let tileRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        let grassTileMat = FlatColorMaterial(shader)
        grassTileMat.color = Color(0,1,0,1)
        let mountainTileMat = FlatColorMaterial(shader)
        mountainTileMat.color = Color(0,0,0,1)
        let highlightOrigin = FlatColorMaterial(shader)
        highlightOrigin.color = Color(1,0,0,1)
        
        for x in 0..<gridSize {
            for y in 0..<gridSize {
                var newTile = Tile()
                newTile.x = Float(x)
                // newTile.xCoord = uint(x) // or x - maxSize/2
                newTile.z = Float(y)
                // newTile.yCoord = uint(y) // or y - maxSize/2

                let newTileRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromNormals: Tile.normalData, fromIndices: Tile.indexData)

                if (x == 0 && y == 0)
                {
                    newTileRo.Material = highlightOrigin
                }
                else if (x == 0 || x == gridSize - 1 || y == 0 || y == gridSize - 1)
                {
                    newTileRo.Material = mountainTileMat
                }
                else
                {
                    newTileRo.Material = grassTileMat
                }
                
                newTile.LinkRenderObject(newTileRo)

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

class DebugData {
    
    static let Instance = DebugData()
    
    // Can't share data (for cubes) when normals/UV's are required
    static let cubePositionData : [Vertex] = [
        // Front
        Vertex( 1, -1, 1),
        Vertex( 1,  1, 1),
        Vertex(-1,  1, 1),
        Vertex(-1, -1, 1),
        // Back
        Vertex(-1, -1, -1),
        Vertex(-1,  1, -1),
        Vertex( 1,  1, -1),
        Vertex( 1, -1, -1),
        // Left
        Vertex(-1, -1,  1),
        Vertex(-1,  1,  1),
        Vertex(-1,  1, -1),
        Vertex(-1, -1, -1),
        // Right
        Vertex( 1, -1, -1),
        Vertex( 1,  1, -1),
        Vertex( 1,  1,  1),
        Vertex( 1, -1,  1),
        // Top
        Vertex( 1,  1,  1),
        Vertex( 1,  1, -1),
        Vertex(-1,  1, -1),
        Vertex(-1,  1,  1),
        // Bottom
        Vertex( 1, -1, -1),
        Vertex( 1, -1,  1),
        Vertex(-1, -1,  1),
        Vertex(-1, -1, -1),
    ]
    
    static let cubeNormalData : [Vertex] = [
        Vertex( 0, 0, 1),
        Vertex( 0, 0, 1),
        Vertex( 0, 0, 1),
        Vertex( 0, 0, 1),
        Vertex( 0, 0,-1),
        Vertex( 0, 0,-1),
        Vertex( 0, 0,-1),
        Vertex( 0, 0,-1),
        Vertex(-1, 0, 0),
        Vertex(-1, 0, 0),
        Vertex(-1, 0, 0),
        Vertex(-1, 0, 0),
        Vertex( 1, 0, 0),
        Vertex( 1, 0, 0),
        Vertex( 1, 0, 0),
        Vertex( 1, 0, 0),
        Vertex( 0, 1, 0),
        Vertex( 0, 1, 0),
        Vertex( 0, 1, 0),
        Vertex( 0, 1, 0),
        Vertex( 0,-1, 0),
        Vertex( 0,-1, 0),
        Vertex( 0,-1, 0),
        Vertex( 0,-1, 0)
    ]
    
    static let indices : [GLubyte] = [
        // Front
        0, 1, 2,
        2, 3, 0,
        // Back
        4, 5, 6,
        6, 7, 4,
        // Left
        8, 9, 10,
        10, 11, 8,
        // Right
        12, 13, 14,
        14, 15, 12,
        // Top
        16, 17, 18,
        18, 19, 16,
        // Bottom
        20, 21, 22,
        22, 23, 20
    ]
    
    var projectionMatrix : GLKMatrix4!
    var viewMatrix : GLKMatrix4!
    var modelMatrixCube : GLKMatrix4!   // debug transformation for the cube
    var aspectRatio : CGFloat
    var colorBuffer : GLuint = 0
    
    private init()
    {
        self.aspectRatio = 1.0
    }
    
    func initialize(_ aspectRatio : CGFloat)
    {
        var viewPos = GLKVector3Make(10, -10, -10)
        var viewTar = GLKVector3Make(0, 0, 0)
        viewMatrix = GLKMatrix4MakeLookAt(viewPos.x, viewPos.y, viewPos.z, // camera position
                                          viewTar.x, viewTar.y, viewTar.z, // target position
                                          -1, -1, 1) // camera up vector
        
        var size : Float = 10 * sqrt(2) // screen width in tiles
        projectionMatrix = GLKMatrix4MakeOrtho(0.0, size, -size / 2 / Float(aspectRatio), size / 2 / Float(aspectRatio), 0, 100.0)
    }
    
    private func setupBuffers()
    {
//        glGenBuffers(GLsizei(1), &colorBuffer)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
//        let ccount = DebugData.cubeColorData.count
//        let csize =  MemoryLayout<Color>.size
//        glBufferData(GLenum(GL_ARRAY_BUFFER), ccount * csize, DebugData.cubeColorData, GLenum(GL_STATIC_DRAW))
    }
}

// // COPY PASTE THIS CODE TO VIEWCONTROLLER DRAW FUNC TO GET A RAINBOW CUBE.
//  var vertexBuffer : GLuint = 0
//  var colorBuffer : GLuint = 0
//  var indexBuffer : GLuint = 0
//
//func setupVertexBuffer() {
//    glGenBuffers(GLsizei(1), &vertexBuffer)
//    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
//    let count = DebugData.cubePositionData.count
//    let size =  MemoryLayout<Vertex>.size
//    glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, DebugData.cubePositionData, GLenum(GL_STATIC_DRAW))
//    
//    glGenBuffers(GLsizei(1), &colorBuffer)
//    glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
//    let ccount = DebugData.cubeColorData.count
//    let csize =  MemoryLayout<Color>.size
//    glBufferData(GLenum(GL_ARRAY_BUFFER), ccount * csize, DebugData.cubeColorData, GLenum(GL_STATIC_DRAW))
//    
//    glGenBuffers(GLsizei(1), &indexBuffer)
//    glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
//    glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), DebugData.indices.count * MemoryLayout<GLubyte>.size, DebugData.indices, GLenum(GL_STATIC_DRAW))
//}
//func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
//    let ptr: UnsafeRawPointer? = nil
//    return ptr! + n * MemoryLayout<Void>.size
//}
//        var mvp =
//            // GLKMatrix4Multiply(debugData.viewMatrix, debugData.modelMatrixCube)
//            GLKMatrix4Multiply(DebugData.Instance.projectionMatrix, DebugData.Instance.viewMatrix)
//        mvp = GLKMatrix4Multiply(mvp, DebugData.Instance.modelMatrixCube)
//        glUniformMatrix4fv(shader.mvpUniform, 1, GLboolean(GL_FALSE), mvp.array)
//
//        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
//        glVertexAttribPointer(
//            VertexAttributes.position.rawValue,
//            3,
//            GLenum(GL_FLOAT),
//            GLboolean(GL_FALSE),
//            GLsizei(MemoryLayout<Vertex>.size), nil) // or BUFFER_OFFSET(0)
//
//        glEnableVertexAttribArray(VertexAttributes.colour.rawValue)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
//        glVertexAttribPointer(
//            VertexAttributes.colour.rawValue,
//            4,
//            GLenum(GL_FLOAT),
//            GLboolean(GL_FALSE),
//            GLsizei(MemoryLayout<Color>.size), nil) // or BUFFER_OFFSET(0)
//
//        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
//
//        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(DebugData.indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
//
//        // glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(DebugData.cubePositionData.count))
//
//        glDisableVertexAttribArray(VertexAttributes.position.rawValue)
//        glDisableVertexAttribArray(VertexAttributes.colour.rawValue)
