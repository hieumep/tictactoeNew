//
//  Board.swift
//  TIcTacToeNew
//
//  Created by Hieu Vo on 4/27/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import GameplayKit

enum statPlay {
    case notWin
    case win
    case possibleWin
    case multiPossibleWin
}

class Board : NSObject {
    fileprivate var boardMap : [[Int]] = [
        [0,0,0],
        [0,0,0],
        [0,0,0]
    ]
    
    subscript (x : Int, y : Int) -> Int {
        get {
            return boardMap[x][y]
        }
        set {
            if boardMap[x][y] == 0 {
                boardMap[x][y] = newValue
            }
        }
    }
    
    var currentPlayer = Player.allPlayers[arc4random() % 2 == 0 ? 0 : 1]
    
    //kiem tra co the danh o do ko
    func checkAvaible(x: Int, y : Int) -> Bool {
        if boardMap[x][y] == 0 {
            return true
        }
        return false
    }
    
    // kiem tra hoa
    func checkBoardFull() -> Bool{
        for x in 0 ..< 3 {
            for y in 0 ..< 3 {
                if boardMap[x][y] == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    // kiem tra kha nang chien thang cua player
    func checkPossibleWin(playerID : Int) -> statPlay {
      //  var result : statPlay = .notWin
        var sequenceCount = 0
        var zeroCount = 0
        var possible = 0
        
        // find horicontal Win
        for x in 0 ..< 3 {
            sequenceCount = 0
            zeroCount = 0
            for y in 0 ..< 3 {
                if boardMap[x][y] == playerID {
                    sequenceCount += 1
                }else if (zeroCount == 0 && boardMap[x][y] == 0) {
                    zeroCount += 1
                    sequenceCount += 1
                }
            }
            if sequenceCount == 3 {
                if zeroCount > 0 {
                    possible += 1
                } else {
                    return .win
                }
            }
        }
        
        // find vertical Win
        for y in 0 ..< 3 {
            sequenceCount = 0
            zeroCount = 0
            for x in 0 ..< 3 {
                if boardMap[x][y] == playerID {
                    sequenceCount += 1
                }else if (zeroCount == 0 && boardMap[x][y] == 0) {
                    zeroCount += 1
                    sequenceCount += 1
                }
            }
            if sequenceCount == 3 {
                if zeroCount > 0 {
                    possible += 1
                } else {
                    return .win
                }
            }
        }
        
        // find diagonal win (upper left to bottom right)
        sequenceCount = 0
        zeroCount = 0
        for x in 0 ... 2{
            let y = x
            if boardMap[x][y] == playerID {
                sequenceCount += 1;
            } else if (zeroCount == 0 && boardMap[x][y] == 0) {
                zeroCount += 1;
                sequenceCount += 1;
            }
        }
        if sequenceCount == 3 {
            //NSLog("Diagonal (UL/BR) win for playerId %d", playerId)
            if sequenceCount == 3 {
                if zeroCount > 0 {
                    possible += 1
                } else {
                    return .win
                }
            }		}
        
        // find diagonal win (lower left to top right)
        sequenceCount = 0
        zeroCount = 0
        for y in 0 ... 2 {
            let x = 3 - y - 1
            if boardMap[x][y] == playerID {
                sequenceCount += 1;
            } else if (zeroCount == 0 && boardMap[x][y] == 0) {
                zeroCount += 1;
                sequenceCount += 1;
            }
        }
        if sequenceCount == 3 {
            if zeroCount > 0 {
                possible += 1
            } else {
                return .win
            }
        }
        
        if possible == 0 {
            return .notWin
        }else if possible == 1 {
            return .possibleWin
        }else if possible > 1{
            return .multiPossibleWin
        }      
        return .notWin
    }
}

extension Board : GKGameModel {
    // Day la cac bien cung nhu cac ham conform GKGameModel
    
    var players: [GKGameModelPlayer]? {
        //tra ve gia tri tat ca cac player
        return Player.allPlayers
    }
    
    // tra ve gia tri player dang choi
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    //ham conform va la ham kiem tra xem kha nang thang la khi nao
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else {
            return false
        }
        // goi ham kiem tra kha nang
        if checkPossibleWin(playerID: player.playerId) == .win {
            return true
        } else {
            return false
        }
    }
    
    // ham conform : dung de lay gia tri hien tai cua ban co
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            boardMap = board.boardMap
        }
    }
    
    // ham conform : dung de copy ban co
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        // 1
        guard let player = player as? Player else {
            return nil
        }
        
        // neu thang thi return nil, khong thi tra ve cac vi tri co the di chuyen
        if checkPossibleWin(playerID: player.playerId) == .win {
            return nil
        }
        
        var moves = [Move]()
        
        // kiem tra het bang , tat ca cac vi tri co danh
        for x in 0 ..< 3 {
            for y in 0 ..< 3 {
                if checkAvaible(x: x, y: y){
                    let position =  positionCell(x : x, y: y)
                    moves.append(Move(position: position))
                }
            }
        }
        
        return moves
    }
    
    //ham conform : de thuc hien buoc di cua AI
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard  let move = gameModelUpdate as? Move else {
            return
        }
        
        // 3
        self[move.position.x, move.position.y] = currentPlayer.playerId
        // sau khi gan buoc thi
        currentPlayer = currentPlayer.opponent
    }
    
    
    //xet gia tri cua moi buoc di
    func score(for player: GKGameModelPlayer) -> Int {
             let playerId = player.playerId
            var winScore = 0
            var dontLoseScore = 0
        
            var winAnalysis = checkPossibleWin(playerID: player.playerId)
        switch winAnalysis {
        case .win :
            winScore = 200
        case .multiPossibleWin:
            winScore = 100
        case .possibleWin :
            winScore = 75
        case .notWin :
            winScore = 0
        }
        
            for otherPlayer in players! {
              if otherPlayer.playerId != playerId {
                winAnalysis = checkPossibleWin(playerID: otherPlayer.playerId)
                switch winAnalysis {
                case .win :
                    dontLoseScore = 400
                case .multiPossibleWin:
                    dontLoseScore = 150
                case .possibleWin :
                    dontLoseScore = 25
                case .notWin :
                    dontLoseScore = 0
                }

              }
            }
        
        return winScore + dontLoseScore
    }
}
