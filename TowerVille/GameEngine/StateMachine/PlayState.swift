import Foundation
import UIKit



class PlayState : State {
    
    static var activeGame : PlayState!
    
    let mapSize : Int = 10  // size of 1 side of the map (length and width)
    var map : Map = Map()
    let shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "MarkusFragmentShader.glsl")

    //let minion : Minion
    var towers : [Tower] = []
    var gold : Int = 0
    private var _lives : Int = 10
    var lives : Int {
        get { return _lives }
        set {
            if newValue <= 0 { gameOver() }
            else { _lives = newValue }
        }
    }

    var spawner : MinionSpawner?
    var minions : [Minion] = []
    var farms   : [VisualObject] = []
    var selectedTile : Tile?
    
    var camera : Camera!
    
    // flags
    var isSelectingStructure = false;   // selected a tile w/ a structure
    var isPickingStructure = false;     // selected a tile w/o a structure
    
    // Mark: - Debug variables
    var debugFarm : Farm?
    
    
    override init(replacing : Bool = true, viewController : ViewController) {
        super.init(replacing: replacing, viewController: viewController)
        PlayState.activeGame = self
        
        camera = OrthoCamPrefab(viewableTiles: self.mapSize)
        Camera.ActiveCamera = camera
        
        map.setupMap(fromShader: self.shader, mapSize: self.mapSize)
        setupLights()
        
        restart()
    }
    
    func restart()
    {
        // clean up
        towers.removeAll()
        farms.removeAll()
        minions.removeAll()
        lives = 10
        gold = 0
        
        // initiailze
        spawner = MinionSpawner(minion: Minion(shader: shader))
        map.setupPathFromWaypoints(waypoints: (spawner?.wayPoints)!)
        
        let tower1 = Tower(8.0, -7.0, shader:shader, color: Color(1, 1, 0, 1))
        tower1.zScale = 0.3
        tower1.yScale = 0.7
        tower1.xScale = 0.3
        towers.append(tower1)
        
        let slowTower1 = SlowTower(3.0, -6.0, shader:shader, color: Color(0, 1, 1, 1))
        slowTower1.zScale = 0.3
        slowTower1.yScale = 0.7
        slowTower1.xScale = 0.3
        towers.append(slowTower1)
        
        self.debugFarm = Farm(self, shader)
        map.Tiles[5][5].SetStructure(debugFarm!)
        farms.append(debugFarm!)
    }
    
    func gameOver()
    {
        restart()
    }
    
    override func update(dt: TimeInterval) {
        
        for t in towers {
            t.update(dt: dt)
        }
        
        for f in farms {
            f.update(dt: dt)
        }
        spawner?.update(dt: dt)
        
        for guy in minions {
            //print(minions.count)
            guy.update(dt: dt)
        }
        
    }
    
    override func draw() {
        shader.prepareToDraw()
        
        for t in towers{
            t.draw()
        }

        for row in map.Tiles {
            for vo in row {
                vo.draw()
            }
        }
        
        for f in farms {
            f.draw()
        }
        
        for guy in minions {
            guy.draw()
        }
        
        // update ui
        updateUi()
        
        // debug display values
        // getViewController()?.debug_updateUiDisplay("Gold: \(self.gold) | Lives: \(self.lives)")
    }
    
    
    func updateUi()
    {
        viewController.healthLabel.text = "\(self.lives)"
        viewController.goldLabel.text = "\(self.gold)"
        viewController.wavesLabel.text = "WAVE: 1"
        viewController.enemiesLabel.text = "ENEMIES: 10"
    }
    
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        NSLog("PlayState processInput \(x) \(z), \(u) \(v)")
        if (isPickingStructure)
        {
            // clicking out of build menu - deselect
            selectedTile = nil;
            getViewController()?.showBuildMenu(isShown: false)
            isPickingStructure = false
        }
        else
        {
            // clicking on tile (no menus open) - select
            selectedTile = self.map.Tiles[Int(round(x))][Int(round(-z))]
            if selectedTile?.type == TileType.Grass
            {
                getViewController()?.showBuildMenu(isShown: true)
                isPickingStructure = true
            }
        }
        
    }
    
    override func processUiInput(action: UIActionType) {
        
        switch action {
        case .BuildTowerBasic:
            if createBasicTower(tile: selectedTile!)
            {
                selectedTile = nil
                viewController.showBuildMenu(isShown: false)
                isPickingStructure = false
            }
            break
        case .BuildTowerSpecial:
            if createSlowTower(tile: selectedTile!)
            {
                selectedTile = nil
                viewController.showBuildMenu(isShown: false)
                isPickingStructure = false
            }
            break
        case .BuildResourceFarm:
            if createFarm(tile: selectedTile!)
            {
                selectedTile = nil
                getViewController()?.showBuildMenu(isShown: false)
                isPickingStructure = false
            }
            break
        case .BackSelected:
            if (isPickingStructure)
            {
                selectedTile = nil
                viewController.showBuildMenu(isShown: false)
            }
            // else if (isSelectingStructure) ...
            else
            {
                NSLog("Back to intro")
                StateMachine.Instance.lastState()
            }
            break
        default:
            NSLog("This action hasn't been implemented yet!")
        }
    
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
    func createFarm(tile : Tile) -> Bool {
        if (self.gold < Farm.COST) { return false }
        if (tile.structure != nil) { return false }
        if (tile.type != TileType.Grass) { return false }
        
        let newFarm = Farm(self, shader)
        newFarm.SetValue(x: tile.x, y: tile.z)
        tile.SetStructure(newFarm)
        farms.append(newFarm)
        self.gold -= Farm.COST
        
        return true
    }
    
    func createBasicTower(tile : Tile) -> Bool {
        if (self.gold < Tower.COST) { return false }
        if (tile.structure != nil) { return false }
        if (tile.type != TileType.Grass) { return false }
        
        let newTower = Tower(0, 0, shader:shader, color: Color(1, 1, 0, 1))
        tile.SetStructure(newTower)
        towers.append(newTower)
        self.gold -= Tower.COST
        
        return true
    }
    
    func createSlowTower(tile : Tile) -> Bool {
        if (self.gold < SlowTower.COST) { return false }
        if (tile.structure != nil) { return false }
        if (tile.type != TileType.Grass) { return false }
        
        let newTower = SlowTower(0, 0, shader:shader, color: Color(0, 1, 1, 1))
        tile.SetStructure(newTower)
        towers.append(newTower)
        self.gold -= SlowTower.COST
        
        return true
    }
        
    func getViewController() -> ViewController? {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // forcefully cast as ViewController type
            return topController as? ViewController
        }
        return nil
    }

    
    override func enter() {
        viewController.showScreen(screenType: .GameScreen);
    }
    
    override func exit() {
        NSLog("Playstate Exit")
        viewController.hideScreen(screenType: .GameScreen);
        towers.removeAll()
        farms.removeAll()
        minions.removeAll()
        PlayState.activeGame = nil;
        Camera.ActiveCamera = nil;
    }
    
}

// MARK: - Game initialization
extension PlayState
{

    
    func setupLights()
    {
        let directionalLight = DirectionalLight()
        directionalLight.xDir = 1
        directionalLight.yDir = -1
        directionalLight.zDir = -1
        directionalLight.lightIntensity = 0.125
        directionalLight.lightColor = Color(1,1,1,1)
        
        let pointLightLeft = PointLight()
        pointLightLeft.x = 4.0
        pointLightLeft.y = 5.0
        pointLightLeft.z = -4.0
        pointLightLeft.lightIntensity = 1.0
        pointLightLeft.lightColor = Color(222/255,107/255,40/255,1)
        
        let pointLightRename = PointLight()
        pointLightRename.x = 14.0
        pointLightRename.y = 5.0
        pointLightRename.z = -14.0
        pointLightRename.lightIntensity = 1.0
        pointLightRename.lightColor = Color(67/255,134/255,150/255,1)
    }
}

// pathetic swift doesn't even have a basic error type
enum MyError : Error {
    case RunTimeError(String)
}
