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
    var rangedSpawner : MinionSpawner?
    var minions : [Minion] = []
    var farms   : [Farm] = []
    var selectedTile : Tile?
    
    var camera : Camera!
    
    // flags
    var isSelectingStructure = false;   // selected a tile w/ a structure
    var isPickingStructure = false;     // selected a tile w/o a structure
    
    // Mark: - Debug variables
    var debugFarm : Farm?
    
    // Mark: - Performance measurement
    var updateDuration : Double = 0
    var drawDuration : Double = 0
    
    
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
        spawner = MinionSpawner(minion: Minion(shader: shader), waypoints: MinionSpawner.WAYPOINTS_LVL1)
        rangedSpawner = MinionSpawner(minion: RangeMinion(shader: shader), waypoints: MinionSpawner.WAYPOINTS_LVL1)
        rangedSpawner?.spawnTime = 0.5
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

        let explodeTower1 = ExplodeTower(10.0, -12.0, shader:shader, color: Color(1, 0, 1, 1))
        explodeTower1.zScale = 0.3
        explodeTower1.yScale = 0.7
        explodeTower1.xScale = 0.3
        towers.append(explodeTower1)
        
        let fragTower1 = FragmentationTower(13.0, -9.0, shader:shader, color: Color(0, 0, 1, 1))
        fragTower1.zScale = 0.3
        fragTower1.yScale = 0.7
        fragTower1.xScale = 0.3
        towers.append(fragTower1)
        
        let laserTower = LaserTower(12, -4, shader: shader, color: Color(1,0,0,1))
        towers.append(laserTower)
        
        self.debugFarm = Farm(self, shader)
        map.Tiles[5][5].SetStructure(debugFarm!)
        farms.append(debugFarm!)
    }
    
    func gameOver()
    {
        restart()
    }
    
    override func update(dt: TimeInterval) {
        
        let startTime = Date()
        
        for t in towers {
            t.update(dt: dt)
        }
        
        for f in farms {
            f.update(dt: dt)
        }
        
        spawner?.update(dt: dt)
        rangedSpawner?.update(dt: dt)
        
        for guy in minions {
            //print(minions.count)
            guy.update(dt: dt)
        }
        
        updateDuration = startTime.timeIntervalSinceNow
    }
    
    override func draw() {
        
        let startTime = Date()
        
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
        
        drawDuration = startTime.timeIntervalSinceNow
        
        // update ui
        updateUi()
        
        let s = String(format: "Update: %.2f Draw: %.2f", updateDuration * -1000, drawDuration * -1000)
        
        viewController.debug_updateUiDisplay(s)
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
            viewController.showBuildMenu(isShown: false)
            isPickingStructure = false
        }
        else
        {
            // clicking on tile (no menus open) - select
            selectedTile = self.map.Tiles[Int(round(x))][Int(round(-z))]
            
            if selectedTile?.type == TileType.Grass
            {
                if let structure = selectedTile?.structure
                {
                    viewController.showStructureMenu(structure)
                    isSelectingStructure = true
                }
                else
                {
                    viewController.showBuildMenu(isShown: true)
                    isPickingStructure = true
                }
            }
        }
    }
    
    override func processUiInput(action: UIActionType) {
        
        switch action {
            
            // BUILD MENU
        
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
                viewController.showBuildMenu(isShown: false)
                isPickingStructure = false
            }
            break
            
            // STRUCTURE SELECTION MENU
        
        case .UpgradeStructure:
            let structure = selectedTile!.structure!
            if gold >= structure.upgradeCost
            {
                gold -= structure.upgradeCost
                structure.upgrade()
            }
            viewController.hideStructureMenu()
            break
        case .RepairStructure:
            let structure = selectedTile!.structure!
            if gold >= structure.getRepairCost()
            {
                gold -= structure.getRepairCost()
                structure.health = structure.maxHealth
            }
            viewController.hideStructureMenu()
            break
        case .SellStructure:
            let structure = selectedTile!.structure!
            gold += structure.getSellCost()
            
            selectedTile?.structure = nil
            if let i = towers.index(where: { $0 === structure }) {
                towers.remove(at: i)
            } else if let i = farms.index(where: { $0 === structure }) {
                farms.remove(at: i)
            }
            viewController.hideStructureMenu()
            break
            
            // ETC.
        
        case .BackSelected:
            if (isPickingStructure)
            {
                // deselect
                selectedTile = nil
                // hide all menus
                viewController.showBuildMenu(isShown: false)
                viewController.hideStructureMenu()
                // lower all flags
                isPickingStructure = false
                isSelectingStructure = false
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
