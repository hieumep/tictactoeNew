//
//  strategis.swift
//  TIcTacToeNew
//
//  Created by Hieu Vo on 4/28/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import GameplayKit

//tao strategist (AI)
struct Strategist {
    //khoi tao Strategist
    private let strategist: GKMinmaxStrategist = {
        let strategist = GKMinmaxStrategist()
        //Muc do suy nghi (bao nhieu nuoc ke tiep)
        strategist.maxLookAheadDepth = 2
        // neu kha nang bang nhau thi se random
        strategist.randomSource = GKARC4RandomSource()
        return strategist
    }()
    
    // cho biet gia tri ban co - do la lop con cua gameModel
    var board: Board {
        didSet {
            strategist.gameModel = board
        }
    }
    
    // tra ve vi tri cua nuoc di tot nhat
    var position : positionCell? {
        if let move = strategist.bestMove(for: board.activePlayer!) as? Move {
            return move.position
        }
        return nil
    }
    
}
