//
//  Move.swift
//  TIcTacToeNew
//
//  Created by Hieu Vo on 4/27/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import GameplayKit

//tao struct chua nuoc di
struct positionCell {
        var x : Int
        var y : Int
        init( x: Int, y : Int){
            self.x = x
            self.y = y
        }
        
    }

class Move : NSObject, GKGameModelUpdate {
    // conform GKGameModelUpdate , gia tri value va gia tri tuong ung su dung (nhu vi du nay la vi tri cua ban co, de biet danh thu o dau)
    var value : Int = 0
    
    var position: positionCell
    
    init(position : positionCell){
        self.position = position
    }
}
