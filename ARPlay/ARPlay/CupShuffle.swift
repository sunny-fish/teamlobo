//
//  CupShuffle.swift
//  ARPlay
//
//  Created by Daniel Giralte on 7/22/17.
//  Copyright © 2017 Sunny Fish. All rights reserved.
//

import Foundation

struct Cup {
    var hasBall: Bool
    var position: Int
    var emptyPos: Bool
}

struct CupGame {
    var cups: [Cup]
}

class CupShuffle {
    
    var gameCups = CupGame(cups:[])
    
    init(cups: Int) {
        let postions = cups + 2
        
        for i in 1...postions {
            if i == 1 {
                gameCups.cups.append(Cup(hasBall: false, position: i, emptyPos: true))
                continue
            }
            
            if i == postions {
                gameCups.cups.append(Cup(hasBall: false, position: i, emptyPos: true))
                continue
            }
            
            gameCups.cups.append(Cup(hasBall: false, position: i, emptyPos: false))
        }
    }
    
    func AddBall() {
        gameCups.cups[self.RandomValidCupIndex(not: -1)].hasBall = true
    }
    
    func RandomValidCupIndex(not: Int?) -> Int {
        arc4random_stir()
        let theCup = Int(arc4random_uniform(UInt32(gameCups.cups.count)))
        
        if !gameCups.cups[theCup].emptyPos && theCup != not {
            return theCup
        } else {
            return RandomValidCupIndex(not: not)
        }
    }
    
    func ShuffleCups(times: Int) {
        for _ in 1...times {
            let moveFrom = RandomValidCupIndex(not: -1)
            let moveTo = RandomValidCupIndex(not: moveFrom)
            
            print ("MoveFrom: \(moveFrom) - MoveTo: \(moveTo)")
            
            ShuffleCupStep(fromPos: moveFrom, toPos: moveTo)
        }
    }
    
    func ShuffleCupStep(fromPos: Int, toPos: Int) {
        var arr = gameCups.cups
        let element = arr.remove(at: fromPos)
        arr.insert(element, at: toPos)
        
        gameCups.cups = arr
        
        let cupElements = gameCups.cups.count - 1
        
        // update positons
        for i in 0...cupElements {
            gameCups.cups[i].position = i + 1
        }
        
        print ("\n\n")
        for i in 0...cupElements {
            printCupAt(i)
        }
    }
    
    func printCupAt(_ index: Int) {
        print ("Has Ball \(gameCups.cups[index].hasBall) - Empty \(gameCups.cups[index].emptyPos)")
    }
}

