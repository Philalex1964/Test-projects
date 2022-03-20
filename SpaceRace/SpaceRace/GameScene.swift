//
//  GameScene.swift
//  SpaceRace
//
//  Created by Alexander Filippov on 19.3.22..
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield:SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var enemyCreatedInterval: Double = 1.0
    var enemiesGeneratedCount: Int = 0
    
    var isGameOver = false {
        didSet {
            gameTimer?.invalidate()
            
            showGameOver()
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score:\(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 20, y: 20)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        startTimer()
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        enemiesGeneratedCount += 1
        if enemiesGeneratedCount.isMultiple(of: 20) {
            enemyCreatedInterval -= 0.1
            startTimer()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    func gameOver() {
        guard children.contains(player) else { return }
        
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameOver()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameOver()
    }
    
    func startTimer() {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: enemyCreatedInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func showGameOver() {
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        let finalScore = SKLabelNode(fontNamed: "Chalkduster")
        finalScore.fontSize = 48
        finalScore.horizontalAlignmentMode = .center
        finalScore.position = CGPoint(x: 512, y: 454)
        finalScore.text = "Final score: \(score)"
        addChild(finalScore)
    }
}
