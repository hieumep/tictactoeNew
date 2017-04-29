//
//  GameScene.swift
//  TIcTacToeNew
//
//  Created by Hieu Vo on 4/27/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import SpriteKit
import GameplayKit

// tao enum luu gia tri location va phan nao cua board.
enum positionXY {
    case left, mid,right
    var value : CGFloat {
        switch(self) {
        case .left :
            return -130
        case .mid:
            return 0
        case .right:
            return 130
        }
    }
    var index : Int {
        switch (self) {
        case .left:
            return 0
        case .mid:
            return 1
        case .right:
            return 2
        }
    }
}

class GameScene: SKScene {
    //node ve Label
    var informationLabel : SKLabelNode!
    let boardNode = SKSpriteNode(imageNamed: "Board")
    var board = Board()
    // tao bien luu nguoi choi chien thang
    var playerWinner : Player? = nil
    //tao bien luu het cac node danh. De khi reset tao action cho tung bien trg SKNode
    var playNodes = [SKNode]()
    //tao ra bien ve chien thuat AI
    var strategist: Strategist!
    var statGame : String? = nil
    
    override func didMove(to view: SKView) {
        
        //set diem goc la diem o giua
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let boardWidth = view.frame.width - 24
        let heightBanner = (view.frame.height - boardWidth)/2
        //khoi tao background
        let backGroundNote = SKSpriteNode(imageNamed: "wood-bg")
     //   backGroundNote.position = CGPoint(x: 0, y: 0)
        addChild(backGroundNote)
        
        // khoi tao board node
        
        
        boardNode.size = CGSize(width: boardWidth, height: boardWidth)
        boardNode.position = CGPoint(x: 0, y: -heightBanner/2)
        addChild(boardNode)
        
        // tao header Node 
        let headerNode = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: view.frame.width, height: heightBanner))
        headerNode.alpha = 0.65
        headerNode.position = CGPoint(x: 0, y: view.frame.height/2 - heightBanner / 2)
        headerNode.zPosition = 2
        addChild(headerNode)
        
        informationLabel = SKLabelNode()
        informationLabel.fontSize = UIDevice.current.userInterfaceIdiom == .pad ? 63 : 40
        informationLabel.fontColor = .blue
        informationLabel.position = headerNode.position
        informationLabel.verticalAlignmentMode = .center
        informationLabel.text = "'s turn"
        informationLabel.zPosition = 3
        addChild(informationLabel)
       
        strategist = Strategist(board: board)
        
        resetGame()
        updateGame()
        
    }
  
    // ham lay vi tri cua ban co tu cho tap.
    func getPositionCell(_ touch : UITouch){
        // lay gia tri X cua cot o giua
        let positionXMidColum = boardNode.size.width / 6
        // lay gia tri Y cua cot o giua
        let postionYMidColum = boardNode.size.height / 6
        
        let positionX = touch.location(in: self).x
        let positionY = touch.location(in: self).y
        
        let partX = getPartoFBoard(position: positionX, positionCompareMin: -positionXMidColum, positionCompareMax: postionYMidColum)
        //do toa do Y bi doi xuong , nen vi vay gia tri Y se tinh them do doi ah
        let partY = getPartoFBoard(position: positionY, positionCompareMin: -postionYMidColum + boardNode.position.y, positionCompareMax: postionYMidColum + boardNode.position.y)
        
        print("x : \(partX.value)")
        print("y : \(partY.value)")
        updateBoardWithNote(x: partX, y: partY)
    }
    
    // Ham kiem tra xem van co da ket thuc chua va neu chua se chuyen nguoi choi. va nguoi choi neu la zombie thi se de AI choi
    fileprivate func updateGame() {
        var gameOverTitle: String? = nil
        
        if let playerWinner = playerWinner, playerWinner == board.currentPlayer {
            gameOverTitle = "\(playerWinner.name) Wins!"
        } else if board.checkBoardFull() {
            gameOverTitle = "Draw"
        }
        
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { _ in
                self.resetGame()
                self.updateGame()
            }
            
            alert.addAction(alertAction)
            view?.window?.rootViewController?.present(alert, animated: true)
            
            return
        }
        // chuyen doi nguoi choi
        board.currentPlayer = board.currentPlayer.opponent
        informationLabel.text = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.value == .zombie {
            processAIMove()
        }
    }

    // tao node len ban co
    func updateBoardWithNote(x : positionXY, y : positionXY) {
        let player = board.currentPlayer
        if board.checkAvaible(x: x.index, y: y.index) {
        board[x.index,y.index] = player.playerId
        let playNode = SKSpriteNode(imageNamed: player.nameImage)
        //lay kich thuoc cua node
        let playNodeSize = boardNode.size.width / 6 - 20
        playNode.size = CGSize(width: playNodeSize, height: playNodeSize)
        // vi boardNode dieu chinh vi tri y nen vi vay phai cong them khoang nay ah
        let newY = y.value + boardNode.position.y
        playNode.position = CGPoint(x: x.value, y: newY)
        playNode.zPosition = 5
        addChild(playNode)
        playNodes.append(playNode)
            // tao action phong to
        let playAction = SKAction.scale(by: 2.0, duration: 0.5)
        playNode.run(playAction)
        if board.checkPossibleWin(playerID: player.playerId) == .win {
            playerWinner = player
        }
        updateGame()
        }
     //   let spire
    }
    
    //ham dung de so sanh gia tri location va dua re se la o nao cua ban co
    func getPartoFBoard(position : CGFloat, positionCompareMin : CGFloat, positionCompareMax : CGFloat) -> positionXY {
        print("postion : \(position) & positionCompare : \(positionCompareMin)")
        if position < positionCompareMin {
            return positionXY.left
        }
        if position > positionCompareMin && position < positionCompareMax {
            return positionXY.mid
        }
        return positionXY.right
    }
    
    // ham xoa het va khoi tao lai ban co
    func resetGame() {
        let actions = [
        SKAction.scale(by: 0, duration: 0.25),
        SKAction.customAction(withDuration: 0.5, actionBlock: { (node, duration) in
            node.removeFromParent()
        })
        ]
        
        playNodes.forEach{ node in
            node.run(SKAction.sequence(actions))
        }
        
        playNodes.removeAll()
        board = Board()
        strategist.board = board
        playerWinner = nil
    }
    
    fileprivate func processAIMove() {
        // tao bo xu ly khong dong bo (phai thuc hien nuoc di cua AI truoc khi nguoi choi co the danh)
        DispatchQueue.global().async { [unowned self] in
            // lay thoi gian can thiet de AI suy nghi
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let positionCell = self.strategist.position else {
                return
            }
            // khoang thoi gian chenh lech sau khi AI quyet dinh va thoi gian can thiet de AI suy nghi
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 0.75
            // so sanh thoi gian can theit va thoi gian toi da de danh co
            let delay = max(delta, aiTimeCeiling)
            // 5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let positionX = self.postionXYFromValue(x: positionCell.x)
                let positionY = self.postionXYFromValue(x: positionCell.y)
                self.updateBoardWithNote(x: positionX, y: positionY)
            }
        }
    }
    // ham chuyen doi gia tri x, y thanh positionXY
    func postionXYFromValue(x : Int) -> positionXY {
        switch x {
        case 0:
            return .left
        case 1:
            return .mid
        case 2 :
            return .right
        default :
            return .left
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if board.currentPlayer.value == .zombie {
            return
        }
        for touch in touches {
            for node in nodes(at: touch.location(in: self)) {
                if node == boardNode {
                    // kiem tra co click tren node board, neu co thi goi ham processTouchOnBoard va gui gia tri touch de lay position
                   // processTouchOnBoard(touch: touch)
                    print("ngay bang")
                    getPositionCell(touch)
                }
            }
        }

        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
