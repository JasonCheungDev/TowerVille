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
    
    var vertexBuffer : GLuint = 0
    var colorBuffer : GLuint = 0
    var indexBuffer : GLuint = 0
    var shader : ShaderProgram!
    var debugData : DebugData!
    
    //initilization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupShader()
        setupVertexBuffer()
        debug_setupCamera()
        
        print(debugData.projectionMatrix.array)
        print(debugData.viewMatrix.array)
        print(debugData.modelMatrixCube.array)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.2, 0.4, 0.6, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        // shader.begin() 이 더 나은거 같다.
        shader.prepareToDraw()
    
        var mvp =
            // GLKMatrix4Multiply(debugData.viewMatrix, debugData.modelMatrixCube)
            GLKMatrix4Multiply(debugData.projectionMatrix, debugData.viewMatrix)
        mvp = GLKMatrix4Multiply(mvp, debugData.modelMatrixCube)
        glUniformMatrix4fv(shader.mvpUniform, 1, GLboolean(GL_FALSE), mvp.array)

        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), nil) // or BUFFER_OFFSET(0)
        
        glEnableVertexAttribArray(VertexAttributes.colour.rawValue)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
        glVertexAttribPointer(
            VertexAttributes.colour.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Color>.size), nil) // or BUFFER_OFFSET(0)
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)

        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(DebugData.indices.count), GLenum(GL_UNSIGNED_BYTE), nil)

        // glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(DebugData.cubePositionData.count))
        
        glDisableVertexAttribArray(VertexAttributes.position.rawValue)
        glDisableVertexAttribArray(VertexAttributes.colour.rawValue)

        
    }

}

// OPENGL SETUP
extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(glkView.context)

    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupShader() {
        self.shader = ShaderProgram(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
    }
    
    func setupVertexBuffer() {
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let count = DebugData.cubePositionData.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, DebugData.cubePositionData, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &colorBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
        let ccount = DebugData.cubeColorData.count
        let csize =  MemoryLayout<Color>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), ccount * csize, DebugData.cubeColorData, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), DebugData.indices.count * MemoryLayout<GLubyte>.size, DebugData.indices, GLenum(GL_STATIC_DRAW))
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
        let ptr: UnsafeRawPointer? = nil
        return ptr! + n * MemoryLayout<Void>.size
    }
    
    func debug_setupCamera()
    {
        let aspectRatio = self.view.frame.width / self.view.frame.height
        // let aspectRatio = Float(glkView.drawableWidth) / Float(glkView.drawableHeight)
        print("Aspect ratio \(aspectRatio)")
        debugData = DebugData(aspectRatio)
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
//        Vertex(0.583,  0.771,  0.014),
//        Vertex(0.609,  0.115,  0.436),
//        Vertex(0.327,  0.483,  0.844),
//        Vertex(0.822,  0.569,  0.201),
//        Vertex(0.435,  0.602,  0.223),
//        Vertex(0.310,  0.747,  0.185),
//        Vertex(0.597,  0.770,  0.761),
//        Vertex(0.559,  0.436,  0.730),
//        Vertex(0.359,  0.583,  0.152),
//        Vertex(0.483,  0.596,  0.789),
//        Vertex(0.559,  0.861,  0.639),
//        Vertex(0.195,  0.548,  0.859),
//        Vertex(0.014,  0.184,  0.576),
//        Vertex(0.771,  0.328,  0.970),
//        Vertex(0.406,  0.615,  0.116),
//        Vertex(0.676,  0.977,  0.133),
//        Vertex(0.971,  0.572,  0.833),
//        Vertex(0.140,  0.616,  0.489),
//        Vertex(0.997,  0.513,  0.064),
//        Vertex(0.945,  0.719,  0.592),
//        Vertex(0.543,  0.021,  0.978),
//        Vertex(0.279,  0.317,  0.505),
//        Vertex(0.167,  0.620,  0.077),
//        Vertex(0.347,  0.857,  0.137),
//        Vertex(0.055,  0.953,  0.042),
//        Vertex(0.714,  0.505,  0.345),
//        Vertex(0.783,  0.290,  0.734),
//        Vertex(0.722,  0.645,  0.174),
//        Vertex(0.302,  0.455,  0.848),
//        Vertex(0.225,  0.587,  0.040),
//        Vertex(0.517,  0.713,  0.338),
//        Vertex(0.053,  0.959,  0.120),
//        Vertex(0.393,  0.621,  0.362),
//        Vertex(0.673,  0.211,  0.457),
//        Vertex(0.820,  0.883,  0.371),
//        Vertex(0.982,  0.099,  0.879)
    ]
    
    var projectionMatrix : GLKMatrix4!
    var viewMatrix : GLKMatrix4!
    var modelMatrixCube : GLKMatrix4!   // debug transformation for the cube
    var aspectRatio : CGFloat
    
    init(_ aspectRatio : CGFloat)
    {
        self.aspectRatio = aspectRatio
        projectionMatrix = GLKMatrix4MakeOrtho(-17.0, 17.0, -10.0, 10, 1.0, 10.0)
        projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), Float(aspectRatio), 0.0, 20.0)
        
        var viewPos = GLKVector3Make(2, -3, -10)
        var modelPos = GLKVector3Make(0, 1, -1)
        viewMatrix = GLKMatrix4MakeLookAt(
            viewPos.x, viewPos.y, viewPos.z,            // eye
            modelPos.x, modelPos.y, modelPos.z,   // target direction
            0, -1, 0)

        modelMatrixCube = GLKMatrix4Identity
        modelMatrixCube = GLKMatrix4Translate(modelMatrixCube, modelPos.x, modelPos.y, modelPos.z)
//        modelMatrixCube = GLKMatrix4RotateX(modelMatrixCube, GLKMathDegreesToRadians(30))
//        modelMatrixCube = GLKMatrix4RotateY(modelMatrixCube, GLKMathDegreesToRadians(60))
//        modelMatrixCube = GLKMatrix4RotateZ(modelMatrixCube, GLKMathDegreesToRadians(15))
//        modelMatrixCube = GLKMatrix4Scale(modelMatrixCube, 1, 1, 1)
    }
}

