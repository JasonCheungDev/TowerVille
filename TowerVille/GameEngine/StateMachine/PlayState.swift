import Foundation

class PlayState : State {
    
    let mapSize : Int = 10  // size of 1 side of the map (length and width)
    var map : Map = Map()
    let shader = ShaderProgram(vertexShader: "LambertVertexShader.glsl", fragmentShader: "MarkusFragmentShader.glsl")
    let minion : Minion
    
    var gameObjects : [GameObject] = []
    var visualObjects : [VisualObject] = []
    var camera : Camera!
    
    
    override init(replacing : Bool = true) {
        minion = Minion(shader: shader)
        
        camera = OrthoCamPrefab(viewableTiles: self.mapSize)
        Camera.ActiveCamera = camera
        
        super.init(replacing: replacing)
        
        setupMap(mapSize: self.mapSize)
        setupLights()
    }
    
    override func update(dt: TimeInterval) {
        minion.update(dt: dt)
    }
    
    override func draw() {
        shader.prepareToDraw()
        
        minion.draw()
        
        for vo in visualObjects {
            vo.draw()
        }
    }
    
    override func processInput(x: Float, z: Float, u: Float, v: Float) {
        
    }
    
    override func pause() {
        
    }
    
    override func resume() {
        
    }
    
}

// MARK: - Game initialization
extension PlayState
{
    func setupMap(mapSize mapSize: Int) {
        
        let gridSize = mapSize * 2 - 1
        
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
                    
                    visualObjects.append(newTile)
                }
            }
        }
    }
    
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
