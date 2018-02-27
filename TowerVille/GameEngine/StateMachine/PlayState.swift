import Foundation
import UIKit

class PlayState : State {
    
    let mapSize : Int = 10  // size of 1 side of the map (length and width)
    var map : Map = Map()
    let shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "MarkusFragmentShader.glsl")
    let minion : Minion
    let tower : Tower
    var gold : Int = 0
    var farms : [VisualObject] = []
    var camera : Camera!
    
    // Mark: - Debug variables
    var debugFarm : Farm?

    override init(replacing : Bool = true) {
        minion = Minion(shader: shader)
        
        tower = Tower(8.0, -7.0, shader:shader)
        tower.setMinion(min: minion)
        
        camera = OrthoCamPrefab(viewableTiles: self.mapSize)
        Camera.ActiveCamera = camera
        
        super.init(replacing: replacing)
        
        map.setupMap(fromShader: self.shader, mapSize: self.mapSize)
        setupLights()
        
        self.debugFarm = Farm(self, shader)
        map.Tiles[5][5].SetStructure(debugFarm!)
        farms.append(debugFarm!)
    }
    
    override func update(dt: TimeInterval) {
        minion.update(dt: dt)
        tower.update(dt: dt)
        for f in farms {
            f.update(dt: dt)
        }
    }
    
    override func draw() {
        shader.prepareToDraw()
        
        tower.draw()
        minion.draw()

        for row in map.Tiles {
            for vo in row {
                vo.draw()
            }
        }
        
        for f in farms {
            f.draw()
        }
        
        // debug display values
        do {
            try getViewController().debug_updateUiDisplay("Gold: \(self.gold)")
        } catch MyError.RunTimeError(let errorMessage) {
            print(errorMessage)
        } catch {
            print("ERROR: ?")
        }
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        NSLog("PlayState processInput \(x) \(z), \(u) \(v)")
        createFarm(x: Int(round(x)), y: -Int(round(z)))
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
    func createFarm(x: Int, y: Int) -> Bool {
        if (self.gold < Farm.COST) { return false }
        if (self.map.Tiles[x][y].structure != nil) { return false }
        if (self.map.Tiles[x][y].type != TileType.Grass) { return false }
        
        let newFarm = Farm(self, shader)
        map.Tiles[x][y].SetStructure(newFarm)
        farms.append(newFarm)
        self.gold -= Farm.COST
        
        return true
    }
    
    func getViewController() throws -> ViewController {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // forcefully cast as ViewController type
            return topController as! ViewController
        }
        throw MyError.RunTimeError("Could not find ViewController")
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
