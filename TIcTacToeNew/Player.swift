//
//  Player.swift
//  TIcTacToeNew
//
//  Created by Hieu Vo on 4/27/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import GameplayKit

// phai thuoc class : GKGameModelPlayer
class Player : NSObject, GKGameModelPlayer {
    //tao enum de lay gia tri nguoi choi , trong do co gia tri, hinh anh va ten
    enum values : Int {
        case brain = 1
        case zombie = 2
    
        var name : String {
            switch self {
            case .brain :
                return "Brain"
            case .zombie :
                return "Zombie"
            }
        }
        
        var nameImage : String {
            switch self {
            case .brain:
                return "brain"
            case .zombie :
                return "zombie-head"
            }
        }
        
    }
    
    var value : values
    var name : String
    var playerId : Int
    var nameImage : String
    
    //conform GKGameModelPlayer : tao mot bien chua tat ca cac player , va tao ra bien playerId
    static var allPlayers = [Player(.brain),Player(.zombie)]
    
    init(_ value : values) {
        self.value = value
        self.name = value.name
        playerId = value.rawValue
        nameImage = value.nameImage
    }
    
    //thay doi opponent player
    var opponent : Player {
        if value == .brain {
            return Player.allPlayers[1]
        }else {
            return Player.allPlayers[0]
        }
    }
    
}
