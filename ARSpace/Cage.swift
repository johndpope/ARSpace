//
//  Cage.swift
//  ARSpace
//
//  Created by Interaktion1718 on 16.11.17.
//  Copyright © 2017 Florian Gramß. All rights reserved.
//

import SceneKit

class Cage {
    var edges : [SCNVector3] = []           //Array for all 8 Edges
    var centerPos = SCNVector3()
    var width  : Float
    var length : Float
    var cageHeight : Float
    var drawNode : SCNNode
    init(_ planeNode : SCNNode, _ airplaneHeigth : Float,_ cageHeight : Float, _ node : SCNNode){
        centerPos = planeNode.position //Let's see if this works
        let centerX = centerPos.x
        let centerY = centerPos.z
        drawNode    = node
        self.cageHeight = cageHeight
//        let centerZ = centerPos.z
        NSLog("centerPos: %d %d %d", centerPos.x, centerPos.y, centerPos.z)
        
        
        var planeGeometry : SCNPlane
        planeGeometry = planeNode.geometry as! SCNPlane
        width = Float(planeGeometry.width)
        length = Float(planeGeometry.height)       //The plane is rotated by 90° so it's height is really it's length
        //CURRENTLY HERE!
        if(length > width ){
//            edges[0] = SCNVector3(
            NSLog("Length > Width")
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth, centerY - length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth, centerY - length/2))
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth, centerY + length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth, centerY + length/2))
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth + cageHeight, centerY - length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth + cageHeight, centerY - length/2))
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth + cageHeight, centerY + length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth + cageHeight, centerY + length/2))
        }
        else{
            NSLog("Width > Length")
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth, centerY + length/2))
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth, centerY - length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth, centerY + length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth, centerY - length/2))
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth + cageHeight, centerY + length/2))
            edges.append(SCNVector3Make(centerX - width/2, airplaneHeigth + cageHeight, centerY - length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth + cageHeight, centerY + length/2))
            edges.append(SCNVector3Make(centerX + width/2, airplaneHeigth + cageHeight, centerY - length/2))
        }
        //Correct edges[1] and [2]
        let distance01 = getDistance(vector1: edges[0], vector2: edges[1])
        let distance02 = getDistance(vector1: edges[0], vector2: edges[2])
        if distance01 < distance02 {
            NSLog("Alles richtig")
        }
        else{   //distance02 > distance01
            NSLog("Edge 1 ist zu weit weg")
            //Change edges 1 & 2
            var tempVector = edges[2]
            edges[2] = edges[1]
            edges[1] = tempVector
            //Change in upper layer too
            tempVector = edges[6]
            edges[6] = edges[5]
            edges[5] = tempVector
        }
        
        
        generateCube(vector: edges[0], color: UIColor.red,      node: node)
        generateCube(vector: edges[1], color: UIColor.blue,     node: node)
        generateCube(vector: edges[2], color: UIColor.green,    node: node)
        generateCube(vector: edges[3], color: UIColor.yellow,   node: node)
        generateCube(vector: edges[4], color: UIColor.black,    node: node)
        generateCube(vector: edges[5], color: UIColor.purple,   node: node)
        generateCube(vector: edges[6], color: UIColor.orange,   node: node)
        generateCube(vector: edges[7], color: UIColor.magenta,  node: node)
        generateCube(vector: SCNVector3Make(centerX, centerY, 0), color: UIColor.cyan, node: node)
        
        
    }
    
    func isInside(position : SCNVector3) -> Bool {
        //Calculate here
        if true {
            return true
        }
        else{
            
            return false
        }
    }
    func getSpawnPointAirplane() -> SCNVector3 {
        var spawnPoint = SCNVector3()
        spawnPoint.y = edges[0].y + cageHeight/2
//        spawnPoint = edges[0]
        if width < length {
            spawnPoint.x = (edges[1].x - edges[0].x)/2 + edges[0].x

            spawnPoint.z = edges[0].z
        }
        else{
            spawnPoint.x = edges[0].x

            spawnPoint.z = (edges[1].z - edges[0].z)/2 + edges[0].z
        }
        return spawnPoint
    }
    
    func generateCube(vector : SCNVector3, color : UIColor, node : SCNNode){
        //TEST
        let cube = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cube.firstMaterial = material
        let testnode = SCNNode(geometry: cube)
        
        testnode.simdPosition = float3(vector.x, vector.y, vector.z)
        node.addChildNode(testnode)
    }
    func getDistance(vector1 : SCNVector3, vector2: SCNVector3) -> Float {
        return sqrt(pow(vector1.x - vector2.x, 2) + pow(vector1.y - vector2.y, 2) + pow(vector1.z - vector2.z, 2))
    }
    //The Spawn-Field is divided into four different smaller Fields. ATTENTION: The Fields are not always on the same position (Field 1 can be down left or up right for example.)
    func getSpawnPointAsteroid(spawnField : Int) -> SCNVector3 {
        var spawnPoint = getSpawnPointAirplane()
        //Asteoriden liegen zwischen edges 2 und 3
        if(width > length){
            //Die Zufallszahlen beziehen sich auf die Mitte des Feldes
            let maxDeltaheight = cageHeight/Float(2)
            let maxDeltalength = length/Float(2)
            NSLog("maxHeight: %f", maxDeltaheight)
            
            let randDeltaheight = Float(arc4random_uniform(UInt32(maxDeltaheight * 1000)))/Float(1000)
            let randDeltalength = Float(arc4random_uniform(UInt32(maxDeltalength * 1000)))/Float(1000)
            NSLog("rand1: %f ; rand2 : %f", randDeltaheight, randDeltalength)
            //Test here if spawnpoint + width is enough, or sometimes -width is required
            spawnPoint.x = spawnPoint.x + width
            switch(spawnField){
            case 1:
                spawnPoint.y = spawnPoint.y + randDeltaheight
                spawnPoint.z = spawnPoint.z + randDeltalength
                break
            case 2:
                spawnPoint.y = spawnPoint.y + randDeltaheight
                spawnPoint.z = spawnPoint.z - randDeltalength
                break
            case 3:
                spawnPoint.y = spawnPoint.y - randDeltaheight
                spawnPoint.z = spawnPoint.z + randDeltalength
                break
            case 4:
                spawnPoint.y = spawnPoint.y - randDeltaheight
                spawnPoint.z = spawnPoint.z - randDeltalength
                break
            default: NSLog("Wrong Fieldnumber at Gespawnpointasteroid selected")
            }
            
        }
        else{   //Length > Width
//            var rand1 = arc4random_uniform(UInt32(width))
            
            let maxDeltaheight = cageHeight/Float(2)
            let maxDeltawidth  = width/Float(2)
            NSLog("maxHeight: %f", maxDeltaheight)
            
            let randDeltaheight = Float(arc4random_uniform(UInt32(maxDeltaheight * 1000)))/Float(1000)
            let randDeltawidth  = Float(arc4random_uniform(UInt32(maxDeltawidth  * 1000)))/Float(1000)
            NSLog("rand1: %f ; rand2 : %f", randDeltaheight, randDeltawidth)
            
            spawnPoint.z = spawnPoint.z + length
            
            switch(spawnField){
            case 1:
                spawnPoint.y = spawnPoint.y + randDeltaheight
                spawnPoint.x = spawnPoint.x + randDeltawidth
                break
            case 2:
                spawnPoint.y = spawnPoint.y + randDeltaheight
                spawnPoint.x = spawnPoint.x - randDeltawidth
                break
            case 3:
                spawnPoint.y = spawnPoint.y - randDeltaheight
                spawnPoint.x = spawnPoint.x + randDeltawidth
                break
            case 4:
                spawnPoint.y = spawnPoint.y - randDeltaheight
                spawnPoint.x = spawnPoint.x - randDeltawidth
                break
            default: NSLog("Wrong Fieldnumber at Gespawnpointasteroid selected")
            }
            
        }
        generateCube(vector: spawnPoint, color: UIColor.white, node: drawNode)
        
        return spawnPoint
        
    }
    
    
}
