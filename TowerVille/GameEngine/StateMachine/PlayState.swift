import Foundation
import UIKit



class PlayState : State {
    
    static var activeGame : PlayState!
    
    let mapSize : Int = 10  // size of 1 side of the map (length and width)
    var map : Map = Map()
    let shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "MarkusFragmentShader.glsl")

    
    let tower : Tower
    var gold : Int = 0
    var lives : Int = 20

    let spawner : MinionSpawner
    var minions : [Minion] = []
    var farms   : [VisualObject] = []
    var selectedTile : Tile?
    
    var camera : Camera!
    
    // flags
    var isSelectingStructure = false;
    var isPickingStructure = false;
    
    // Mark: - Debug variables
    var debugFarm : Farm?
    
    
    override init(replacing : Bool = true, viewController : ViewController) {
        
        camera = OrthoCamPrefab(viewableTiles: self.mapSize)
        Camera.ActiveCamera = camera
        
        spawner = MinionSpawner(minion: Minion(shader: shader))

        tower = Tower(8.0, -7.0, shader:shader)
        tower.zScale = 0.3
        tower.yScale = 0.7
        tower.xScale = 0.3
        
        
        super.init(replacing: replacing, viewController: viewController)
        
        PlayState.activeGame = self
        map.setupMap(fromShader: self.shader, mapSize: self.mapSize)
        setupLights()
        
        self.debugFarm = Farm(self, shader)
        map.Tiles[5][5].SetStructure(debugFarm!)
        farms.append(debugFarm!)
    }
    
    override func update(dt: TimeInterval) {
        
        tower.update(dt: dt)

        for f in farms {
            f.update(dt: dt)
        }
        spawner.update(dt: dt)
        
        for guy in minions {
            //print(minions.count)
            guy.update(dt: dt)
        }
        
    }
    
    override func draw() {
        shader.prepareToDraw()
        
        tower.draw()

        for row in map.Tiles {
            for vo in row {
                vo.draw()
            }
        }
        
        for f in farms {
            f.draw()
        }
        
        // debug display values
        getViewController()?.debug_updateUiDisplay("Gold: \(self.gold) | Lives: \(self.lives)")

        for guy in minions {
            guy.draw()
        }
        
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
        case UIActionType.BuildTowerBasic:
            // TODO: Tower stuff
            break
        case .BuildResourceFarm:
            if createFarm(tile: selectedTile!)
            {
                selectedTile = nil
                getViewController()?.showBuildMenu(isShown: false)
                isPickingStructure = false
            }
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
        tile.SetStructure(newFarm)
        farms.append(newFarm)
        self.gold -= Farm.COST
        
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
