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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGLcontext()
        setupGLupdater()
        setupShader()
        
        debug_setup()
        //debug_SetupRenderObject()
        debug_SetupTiledMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.2, 0.4, 0.6, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        shader.prepareToDraw()  // warning: May need to move this to the RenderObject (to ensure right shader is used)
        
        for vo in debugVisualObjects
        {
            vo.RenderObject?.Draw()
        }
    }

}

// OPENGL SETUP
extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES3)! // Warning: Doesn't work on iPods
        EAGLContext.setCurrent(glkView.context)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupShader() {
        self.shader = ShaderProgram(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
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
        let ro = RenderObject(fromShader: shader, fromVertices: DebugData.cubePositionData, fromIndices: DebugData.indices)
        let mat = LambertMaterial(shader)
        mat.color = Color(1,0,0,1)
        ro.Material = mat
        vo.LinkRenderObject(ro)
        
        let vo2 = VisualObject()
        let ro2 = RenderObject(fromShader: shader, fromVertices: DebugData.cubePositionData, fromIndices: DebugData.indices)
        let mat2 = LambertMaterial(shader)
        mat2.color = Color(0,1,0,1)
        ro2.Material = mat2
        vo2.LinkRenderObject(ro2)
        vo2.y = 2
        vo2.x = 2
        
        // TODO: Should be auto gen by GameObject
        vo.ID = "Debug VO 1"
        vo2.ID = "Debug VO 2"
        
        self.debugVisualObjects.append(vo)
        self.debugVisualObjects.append(vo2)
    }
    
    func debug_SetupTiledMap()
    {
        let halfWidth: Int = 10
        let halfHeight: Int  = 5
        // let tileRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)
        let grassTileMat = LambertMaterial(shader)
        grassTileMat.color = Color(0,1,0,1)
        let mountainTileMat = LambertMaterial(shader)
        mountainTileMat.color = Color(0,0,0,1)
        
        for x in -halfWidth...halfWidth {
            for y in -halfHeight...halfHeight {
                var newTile = Tile()
                newTile.x = Float(x)
                // newTile.xCoord = uint(x) // or x - maxSize/2
                newTile.z = Float(y)
                // newTile.yCoord = uint(y) // or y - maxSize/2

                let newTileRo = RenderObject(fromShader: shader, fromVertices: Tile.vertexData, fromIndices: Tile.indexData)

                if (x == -halfWidth || x == halfWidth || y == -halfHeight || y == halfHeight)
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
    
    init(glkViewController : GLKViewController) {
        self.glkViewController = glkViewController
    }
    
    // Update Game Logic
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        // collision detection ...
        // GameManager.instance.Update()
    }
}

class DebugData {
    
    static let Instance = DebugData()
    
    static let cubePositionData : [Vertex] = [
        Vertex(-1.0, -1.0, -1.0),
        Vertex( 1.0, -1.0, -1.0),
        Vertex( 1.0,  1.0, -1.0),
        Vertex(-1.0,  1.0, -1.0),
        Vertex(-1.0, -1.0,  1.0),
        Vertex( 1.0, -1.0,  1.0),
        Vertex( 1.0,  1.0,  1.0),
        Vertex(-1.0,  1.0,  1.0)
    ]
    
    static let indices : [GLubyte] = [
        0, 1, 2,    // front
        2, 3, 0,
        4, 5, 6,    // back
        6, 7, 4,
        1, 2, 5,    // right
        5, 6, 2,
        0, 3, 4,    // left
        4, 7, 3,
        2, 3, 6,    // top
        6, 7, 3,
        0, 1, 4,    // bot
        4, 5, 1
    ]
    
    static let cubeColorData : [Color] = [
        Color(1.0,  0.0,  0.0, 1.0),
        Color(0.0,  1.0,  0.0, 1.0),
        Color(0.0,  0.0,  1.0, 1.0),
        Color(1.0,  1.0,  0.0, 1.0),
        Color(1.0,  0.0,  0.0, 1.0),
        Color(0.0,  1.0,  0.0, 1.0),
        Color(0.0,  0.0,  1.0, 1.0),
        Color(1.0,  1.0,  0.0, 1.0),
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
        self.aspectRatio = aspectRatio
        projectionMatrix = GLKMatrix4MakeOrtho(-10.0, 10.0, -10.0 / Float(aspectRatio), 10 / Float(aspectRatio), 0.0, 100.0)
        // projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), Float(aspectRatio), 0.0, 20.0)
        
        var viewPos = GLKVector3Make(0, 10, 0)
        var viewTar = GLKVector3Make(0, 0, 0)
        viewMatrix = GLKMatrix4MakeLookAt(
            viewPos.x, viewPos.y, viewPos.z,            // eye
            viewTar.x, viewTar.y, viewTar.z,   // target direction
            0, 0, 1)
        
        modelMatrixCube = GLKMatrix4Identity
        modelMatrixCube = GLKMatrix4Translate(modelMatrixCube, viewTar.x, viewTar.y, viewTar.z)
        //        modelMatrixCube = GLKMatrix4RotateX(modelMatrixCube, GLKMathDegreesToRadians(30))
        //        modelMatrixCube = GLKMatrix4RotateY(modelMatrixCube, GLKMathDegreesToRadians(60))
        //        modelMatrixCube = GLKMatrix4RotateZ(modelMatrixCube, GLKMathDegreesToRadians(15))
        //        modelMatrixCube = GLKMatrix4Scale(modelMatrixCube, 1, 1, 1)
    }
    
    private func setupBuffers()
    {
        glGenBuffers(GLsizei(1), &colorBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
        let ccount = DebugData.cubeColorData.count
        let csize =  MemoryLayout<Color>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), ccount * csize, DebugData.cubeColorData, GLenum(GL_STATIC_DRAW))
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
