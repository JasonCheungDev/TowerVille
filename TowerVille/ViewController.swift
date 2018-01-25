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
    var shader : ShaderProgram!

    let vertices : [Vertex] = [
        Vertex( 0.37, -0.12, 0.0),
        Vertex( 0.95,  0.30, 0.0),
        Vertex( 0.23,  0.30, 0.0),
        
        Vertex( 0.23,  0.30, 0.0),
        Vertex( 0.00,  0.90, 0.0),
        Vertex(-0.23,  0.30, 0.0),
        
        Vertex(-0.23,  0.30, 0.0),
        Vertex(-0.95,  0.30, 0.0),
        Vertex(-0.37, -0.12, 0.0),
        
        Vertex(-0.37, -0.12, 0.0),
        Vertex(-0.57, -0.81, 0.0),
        Vertex( 0.00, -0.40, 0.0),
        
        Vertex( 0.00, -0.40, 0.0),
        Vertex( 0.57, -0.81, 0.0),
        Vertex( 0.37, -0.12, 0.0),
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupShader()
        setupVertexBuffer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        // shader.begin() 이 더 나은거 같다.
        shader.prepareToDraw()
    
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), nil) // or BUFFER_OFFSET(0)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertices.count))
        
        glDisableVertexAttribArray(VertexAttributes.position.rawValue)
        
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
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
        let ptr: UnsafeRawPointer? = nil
        return ptr! + n * MemoryLayout<Void>.size
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
        
    }
}
