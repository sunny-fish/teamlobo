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
	var cups = [SCNNode]()
	var positions = [SCNVector3]()
	var ballOriginalPosition: SCNVector3
	var ballPositionDeltas = [Float]()
    
    var cupGame: CupShuffle

	override init() {
		cupNode = scene.rootNode.childNode(withName: "Cup", recursively: true)!
		ballNode = scene.rootNode.childNode(withName: "Ball", recursively: true)!
        
        cupGame = CupShuffle(cups: cupCount)
        ballOriginalPosition = ballNode.position
		super.init()
        
        cupGame.AddBall()
        
		cupNode.removeFromParentNode()
		
        for i in 0..<cupCount {
			let cupCopy: SCNNode = cupNode.clone()
			cups.append(cupCopy)
			cupCopy.position = SCNVector3(cupCopy.position.x + (0.3 * Float(i)), cupCopy.position.y, cupCopy.position.z)
			scene.rootNode.addChildNode(cupCopy)
		}
        
		positions = cups.map({ (node) -> SCNVector3 in
			return node.position
		})
        
		for i in 0..<cupCount {
			let first = positions[0]
			let this = positions[i]
			ballPositionDeltas.append(this.x - first.x)
		}
	}

	func parentCup(from node: SCNNode) -> SCNNode? {
		if node.name == "Cup" {
			return node
		}
		guard let parent = node.parent else {
			return nil
		}
		return parentCup(from:parent)
	}

	func lift(cup: SCNNode) {
		guard let parentCup = parentCup(from: cup) else {
			return
		}
        
        ballNode.isHidden = false
		let destination = SCNVector3(parentCup.position.x, parentCup.position.y + 0.3, parentCup.position.z)

        let action = SCNAction.move(to: destination, duration: 0.5)
		parentCup.runAction(action)
	}

	func moveCups() {
        let move = cupGame.ShuffleCupsOnce()
        
        let fromPosition = positions[move.from]
        let toPosition = positions[move.to]
        
        let act1 = moveCup(from: move.from, to: move.to)
        let act2 = moveCup(from: move.to, to: move.from)
        
		self.cups[move.from].runAction(act1)
        self.cups[move.to].runAction(act2)
        
        positions[move.from] = toPosition
        positions[move.to] = fromPosition
        
        if (cupGame.gameCups.cups[move.from].hasBall) {
            self.moveBall(to: move.to)
        }
        
        if (cupGame.gameCups.cups[move.to].hasBall) {
            self.moveBall(to: move.from)
        }
	}
    
    func moveCup(from: Int, to: Int) -> SCNAction {
        let zDirection: Float = from > to ? -1 : 1
        
        let fromPosition = positions[from]
        let toPosition = positions[to]
        
        let halfPosition = SCNVector3(((toPosition.x - fromPosition.x) / 2.0) +
            fromPosition.x, toPosition.y, toPosition.z + (0.2 * zDirection))
        
        let first = SCNAction.move(to: halfPosition, duration: 0.5)
        let second = SCNAction.move(to: toPosition, duration: 0.5)
        let sequence = SCNAction.sequence([first, second])
        
        return sequence
    }

	func moveBall(to position: Int) {
		ballNode.position = SCNVector3(ballNode.position.x + ballPositionDeltas[position], ballNode.position.y, ballNode.position.z)
	}
    
	func reset() {
		for i in 0..<cupCount {
			let cup = cups[i]
			let position = positions[i]
			let upPosition = SCNVector3(position.x, position.y + 0.3, position.z)
			cup.position = upPosition
			let action = SCNAction.move(to: position, duration: 0.8)
			cup.runAction(action)
		}
		let ballWait = SCNAction.wait(duration: 0.8)
		let ballHide = SCNAction.hide()
		let ballSequence = SCNAction.sequence([ballWait, ballHide])
            ballNode.runAction(ballSequence)
        
        cupGame.AddBall()
	}
}
