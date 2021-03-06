//
//  Asteroid.swift
//  ARSpace
//
//  Created by Alexander Apfel on 05.11.17.
//  Copyright © 2017 Florian Gramß. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class Asteroid{
    var asteroidnode: SCNNode?
    var sceneView : ARSCNView
//    var startPoint : SCNVector3
//    var endPoint : SCNVector3
//    var animationTime : Double
    var plannode : SCNNode
    let fadeOutTime : Double = 0.72
    
    func createAsteroid(startPoint : SCNVector3, endPoint : SCNVector3, animationTime : Double){
        
        
        let box = SCNBox(width: 0.06, height: 0.06, length: 0.06, chamferRadius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.init(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
        box.firstMaterial = material
        
        asteroidnode = SCNNode(geometry: box)

        asteroidnode!.position = startPoint
        
        let moveShip = SCNAction.move(to: endPoint, duration: animationTime)
        let fadeOut = SCNAction.fadeOut(duration: fadeOutTime)
        let routine = SCNAction.sequence([moveShip, fadeOut])
        __myrunAction(routine)
        
        //sceneView.scene.rootNode.addChildNode(asteroidnode!)
        plannode.addChildNode(asteroidnode!)
    }
    
    func randomCGFloat() -> CGFloat {
        let min : CGFloat = 0
        let max : CGFloat = 1
        return (CGFloat(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    init(_ sceneViewInit: ARSCNView, _ planenode: SCNNode ){
        NSLog("Asteroid created")
        sceneView = sceneViewInit
        self.plannode = planenode
//        self.startPoint = startPoint
//        self.endPoint = endPoint
//        self.animationTime = animationTime
//
//        self.createAsteroid()
        }
    
    func __myrunAction(_ routine: SCNAction){
        let nodeArray = asteroidnode?.childNodes
        
//        for childNode in nodeArray! {
//            childNode.runAction(routine)
//        }
        asteroidnode?.runAction(routine)
    }
}

