//
//  Renderer.swift
//  ARPlay
//
//  Created by Eric Berna on 7/22/17.
//  Copyright © 2017 Sunny Fish. All rights reserved.
//

import UIKit
import SceneKit

class Renderer: NSObject {

	let cupCount = 3
	let cupNode: SCNNode
	let ballNode: SCNNode
	let scene = SCNScene(named: "art.scnassets/RedPlasticCup.scn")!

	override init() {
		cupNode = scene.rootNode.childNode(withName: "Cup", recursively: true)!
		ballNode = scene.rootNode.childNode(withName: "Ball", recursively: true)!
		super.init()
		cupNode.removeFromParentNode()
		ballNode.removeFromParentNode()
		for i in 0..<cupCount {
			let cupCopy: SCNNode = cupNode.clone()
			cupCopy.position = SCNVector3(cupCopy.position.x + (0.3 * Float(i)), cupCopy.position.y, cupCopy.position.z)
			scene.rootNode.addChildNode(cupCopy)
		}
	}

}
