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

class ViewController: GLKViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // UI
    @IBOutlet var introScreen: UIView!
    @IBOutlet var gameScreen: UIView!
    @IBOutlet var helpScreen: UIView!
    
    // Game Screen
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var goldLabel: UILabel!
    @IBOutlet var wavesLabel: UILabel!
    @IBOutlet var enemiesLabel: UILabel!
    
    @IBOutlet var buildMenuView: UIView!
    @IBOutlet var towerCollectionView: UICollectionView!
    @IBOutlet var resourceCollectionView: UICollectionView!
    let cellIdentifier: String = "structureCollectionViewCell"
    var buildTowerOptions : [UIModelStructure] = []
    var buildResourceOptions : [UIModelStructure] = []
    
    // OpenGL
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    
    // TODO: Remove debug variables
    var shader : ShaderProgram!
    var debugVisualObjects : [VisualObject] = []
    @IBOutlet var debugDisplay: UILabel!

    
    //initilization
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup UI
        setupBuildMenu()
        
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.2, 0.4, 0.6, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))

        StateMachine.Instance.draw()
    }

    func debug_updateUiDisplay(_ text : String)
    {
        debugDisplay.text = text 
    }
    
    @IBAction func onButtonPress(_ sender: UIButton) {
        
        switch sender.tag
        {
        case UIActionType.PlaySelected.rawValue:
            NSLog("Play btn pressed")
            gameScreen.isHidden = false
            StateMachine.Instance.processUiAction(action: UIActionType.PlaySelected)
            break
        case UIActionType.HelpSelected.rawValue:
            NSLog("Help btn pressed")
            helpScreen.isHidden = false
            break
        case UIActionType.HelpSelected.rawValue:
            NSLog("Settings btn pressed")
            helpScreen.isHidden = false
            break
        case UIActionType.HighscoreSelected.rawValue:
            NSLog("Highscore btn pressed")
            break
        case UIActionType.BackSelected.rawValue:
            helpScreen.isHidden = true
            StateMachine.Instance.processUiAction(action: .BackSelected)
            NSLog("Back btn pressed")
            break
        default:
            NSLog("Unknown btn pressed \(sender.tag)")
            break
        }
        
    }
    
}

// USER INTERFACE
extension ViewController {
    
    func setupBuildMenu()
    {
        // Tower (top section)
        let basicTower = UIModelStructure()
        basicTower.name = "Basic"
        basicTower.image = UIImage(named: "watchtower.png")!
        basicTower.actionType = UIActionType.BuildTowerBasic
        let advancedTower = UIModelStructure()
        advancedTower.name = "Advanced"
        advancedTower.actionType = UIActionType.BuildTowerSpecial
        
        buildTowerOptions.append(basicTower)
        buildTowerOptions.append(advancedTower)
        
        // Resource (bottom section)
        let farm = UIModelStructure()
        farm.name = "Farm"
        farm.image = UIImage(named: "farm.png")!
        farm.actionType = UIActionType.BuildResourceFarm
        let mine = UIModelStructure()
        mine.name = "Mine"
        mine.actionType = UIActionType.BuildResourceSpecial
        
        buildResourceOptions.append(farm)
        buildResourceOptions.append(mine)
    }
    
    func showBuildMenu(isShown : Bool)
    {
        buildMenuView.isHidden = !isShown
    }
    
    func showScreen(screenType : UIScreens)
    {
        switch screenType
        {
        case .IntroScreen:
            introScreen.isHidden = false
            break
        case .GameScreen:
            gameScreen.isHidden = false
            break
        case .HelpScreen:
            helpScreen.isHidden = false
            break
        default:
            NSLog("Screen does not exist")
        }
    }
    
    func hideScreen(screenType : UIScreens)
    {
        switch screenType
        {
        case .IntroScreen:
            introScreen.isHidden = true
            break
        case .GameScreen:
            gameScreen.isHidden = true
            break
        case .HelpScreen:
            helpScreen.isHidden = true
            break
        default:
            NSLog("Screen does not exist")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == towerCollectionView)
        {
            return buildTowerOptions.count
        }
        else // resourceCollectionView
        {
            return buildResourceOptions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = towerCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UICellStructure
        
        if (collectionView == towerCollectionView)
        {
            let tower = buildTowerOptions[indexPath.row]
            cell.displayContent(image: tower.image, title: tower.name)
        }
        else // buildCollectionView
        {
            let generator = buildResourceOptions[indexPath.row]
            cell.displayContent(image: generator.image, title: generator.name)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == towerCollectionView)
        {
            let tower = buildTowerOptions[indexPath.row]
            print("Selected tower: \(tower.name)")
        }
        else // buildCollectionView
        {
            let generator = buildResourceOptions[indexPath.row]
            StateMachine.Instance.processUiAction(action: generator.actionType)
            print("Selected generator: \(generator.name)")
        }
    }
    
    @IBAction func OnTap(_ sender: UITapGestureRecognizer)
    {
        if sender.state == .ended
        {
            let touchLocation = sender.location(in:sender.view)
            let x = Float(touchLocation.x / sender.view!.frame.width)
            let y = Float(0.5 - touchLocation.y / sender.view!.frame.height)
            let world = getWorldFromScreen(screen_x: x, screen_y: y)
            StateMachine.Instance.processInput(x: world.x, z: world.z, u: Float(touchLocation.x), v: Float(touchLocation.y))
        }
    }
    
    func getWorldFromScreen(screen_x: Float, screen_y: Float) -> Vertex
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
        
        return Vertex(world_x, 0, world_z)
    }
    
    
    
}

// OPENGL SETUP
extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)!
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
    
        /*
        self.debugVisualObjects.append(vo)
        self.debugVisualObjects.append(vo2)
        self.debugVisualObjects.append(vo3)
        self.debugVisualObjects.append(vo4)
        self.debugVisualObjects.append(prefab)*/
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
        objLoader.smoothed = true
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
        StateMachine.Instance.run(state: IntroState(viewController: glkViewController as! ViewController))
    }
    
    // Update Game Logic
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        StateMachine.Instance.nextState()   // check if next state is available and switch if there is one
        StateMachine.Instance.update(dt: controller.timeSinceLastUpdate)
    }
}


