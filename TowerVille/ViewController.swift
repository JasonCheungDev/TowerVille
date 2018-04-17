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
    @IBOutlet var highscoreScreen: UIView!
    @IBOutlet var loadingScreen: UIView!

    
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
    
    @IBOutlet var structureSelectedView: StructureSelectedView!
    
    @IBOutlet var endMenu: UIView!
    @IBOutlet var endWaveLabel: UILabel!
    @IBOutlet var endGoldLabel: UILabel!
    
    
    // Highscore Screen
    @IBOutlet var highscoreText: UITextView!
    
    
    // OpenGL
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    
    // TODO: Remove debug variables
    @IBOutlet var debugDisplay: UILabel!

    
    //initilization
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup UI
        setupBuildMenu()
        structureSelectedView.viewController = self
        
        // pregame setup
        setupGLcontext()
        setupCamera()       // this retrieves aspect ratio for all Camera objects
        
        // init updater and game
        setupGLupdater()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
//        glClearColor(pow(175/255, 2.2), pow(238/255, 2.2), pow(238/255, 2.2), 1.0);
//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        StateMachine.Instance.draw()
    }

    func debug_updateUiDisplay(_ text : String)
    {
        debugDisplay.text = text 
    }
    
    @IBAction func onButtonPress(_ sender: UIButton) {
        
        // handle anything in view controller first
        switch sender.tag
        {
        case UIActionType.PlaySelected.rawValue:
            NSLog("Play btn pressed")
            showScreen(screenType: .GameScreen)
            break
        case UIActionType.HelpSelected.rawValue:
            NSLog("Help btn pressed")
            showScreen(screenType: .HelpScreen)
            break
        case UIActionType.SettingsSelected.rawValue:
            NSLog("Settings btn pressed")
            break
        case UIActionType.HighscoreSelected.rawValue:
            loadHighscoreView()
            showScreen(screenType: .ScoreScreen)
            NSLog("Highscore btn pressed")
            break
        case UIActionType.BackSelected.rawValue:
            hideScreen(screenType: .HelpScreen)
            hideScreen(screenType: .ScoreScreen)
            NSLog("Back btn pressed")
            break
        default:
            NSLog("Unknown btn pressed \(sender.tag)")
            break
        }
        
        // pass action to state machine
        StateMachine.Instance.processUiAction(action: UIActionType(rawValue: sender.tag)!)
    }
    
}

// USER INTERFACE
extension ViewController {
    
    func loadHighscoreView()
    {
        let scores = LoadScores()
        var scoreString = ""
        for i in (0..<scores.count).reversed() 
        {
            scoreString += "\(scores.count-i). \(scores[i]) \n"
        }
        highscoreText.text = scoreString
    }
    
    func setupBuildMenu()
    {
        // Tower (top section)
        let basicTower = UIModelStructure(fromType: Tower.self)
        basicTower.actionType = UIActionType.BuildTowerBasic
        let slowTower = UIModelStructure(fromType: SlowTower.self)
        slowTower.actionType = UIActionType.BuildTowerSlow
        let explodeTower = UIModelStructure(fromType: ExplodeTower.self)
        explodeTower.actionType = UIActionType.BuildTowerExplosion
        let fragTower = UIModelStructure(fromType: FragmentationTower.self)
        fragTower.actionType = UIActionType.BuildTowerFragment
        let laserTower = UIModelStructure(fromType: LaserTower.self)
        laserTower.actionType = UIActionType.BuildTowerLaser

        buildTowerOptions.append(contentsOf: [basicTower, slowTower, explodeTower, fragTower, laserTower])
        
        // Resource (bottom section)
        let farm = UIModelStructure(fromType: Farm.self)
        farm.actionType = UIActionType.BuildResourceFarm
        let mill = UIModelStructure(fromType: SawMill.self)
        mill.actionType = UIActionType.BuildResourceSawMill
        let mine = UIModelStructure(fromType: Mine.self)
        mine.actionType = UIActionType.BuildResourceMine
        
        buildResourceOptions.append(contentsOf: [farm, mill, mine])
    }
    
    func showBuildMenu(isShown : Bool)
    {
        buildMenuView.isHidden = !isShown
    }
    
    func showStructureMenu(_ structure : Structure)
    {
        structureSelectedView.displayContent(structure)
        structureSelectedView.isHidden = false
        
//        if structure is Tower
//        {
//            let tower = structure as! Tower
//        }
//        else if structure is Farm
//        {
//            let farm = structure as! Farm
//        }
//        else
//        {
//            NSLog("ERROR: showing structure for unknown type")
//        }
    }
    
    func hideStructureMenu()
    {
        structureSelectedView.isHidden = true
    }
    
    func showGameOverMenu(wavesCompleted waves : Int, goldEarned gold : Int)
    {
        endWaveLabel.text = "WAVE: \(waves)"
        endGoldLabel.text = "TOTAL GOLD: \(gold)"
        endMenu.isHidden = false
    }
    
    func hideGameOverMenu()
    {
        endMenu.isHidden = true
    }
    
    func showHighscoreMenu(isShown : Bool)
    {
        // TODO
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
        case .ScoreScreen:
            highscoreScreen.isHidden = false
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
        case .ScoreScreen:
            highscoreScreen.isHidden = true
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
            cell.displayContent(image: tower.image, title: tower.name, cost: tower.cost)
        }
        else // buildCollectionView
        {
            let generator = buildResourceOptions[indexPath.row]
            cell.displayContent(image: generator.image, title: generator.name, cost: generator.cost)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == towerCollectionView)
        {
            let tower = buildTowerOptions[indexPath.row]
            StateMachine.Instance.processUiAction(action: tower.actionType)
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
        let DEBUG_MAPSIZE = 10 // TODO UPDATE THIS
        world_x += Float(DEBUG_MAPSIZE - 2) / 2
        world_z -= Float(DEBUG_MAPSIZE - 2) / 2
        
        print("world x : \(world_x)")
        print("world z : \(world_z)")
        
        return Vertex(world_x, 0, world_z)
    }
    
    func LoadScores() -> [Int]{
        let scores = UserDefaults.standard.object(forKey: "HighScoreArray")
        return (scores != nil) ? scores as? [Int] ?? [Int]() : []
    }
    
    func SaveScore(score: Int){
        var array = LoadScores()
        array.append(score)
        array.sort()
        array = Array(array.suffix(5))
        UserDefaults.standard.set(array, forKey: "HighScoreArray")
    }
    
}

// OPENGL SETUP
extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)!
        glkView.drawableDepthFormat = .format16         // for depth testing
        glkView.drawableColorFormat = GLKViewDrawableColorFormat.SRGBA8888
        self.preferredFramesPerSecond = 60
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


