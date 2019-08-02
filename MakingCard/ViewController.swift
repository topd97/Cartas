//
//  ViewController.swift
//  MakingCard
//
//  Created by Thiago Outeiro Pereira Damasceno on 12/07/19.
//  Copyright © 2019 Thiago Outeiro Pereira Damasceno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayCardView]!
    
    @IBOutlet weak var testColider: UIView!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(behavior)
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0000001
        behavior.resistance = 0
        animator.addBehavior(behavior)
        return behavior
    }()
    
    override func viewDidLoad() {
        var cards = [PlayCard]()
        super.viewDidLoad()
        for _ in 1...5{
            if let card = deck.draw(){
                cards += [card,card]
            }
        }
        
        for cardView in cardViews{
            cardView.isfacedUp = false
            let card = cards.removeLast()
            cardView.rank = card.rank.order
            cardView.suit = card.suit.debugDescription
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            
            collisionBehavior.addItem(cardView)
            itemBehavior.addItem(cardView)
            let push = UIPushBehavior(items: [cardView], mode: .instantaneous)
            push.angle = CGFloat(arc4random_uniform(UInt32((2*CGFloat.pi))))
            push.magnitude = CGFloat(1.0) + CGFloat(arc4random_uniform(UInt32((2))))
            push.action = { [unowned push] in
                push.dynamicAnimator?.removeBehavior(push)
            }
            animator.addBehavior(push)
            
        }
    }
    
    var faceUpCards = [PlayCardView]()
    var cardsMatch : Bool{
        return faceUpCards.count == 2 &&
               faceUpCards[0].rank == faceUpCards[1].rank &&
               faceUpCards[0].suit == faceUpCards[1].suit
    }
    
    var turn : Bool{
        return faceUpCards.count == 2
    }
    
    func cardsMatched(){
        for card in self.faceUpCards{
            UIView.transition(with: card,
                              duration: 0.6,
                              options: [],
                              animations:{
                                card.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                              },
                              completion: { position in
                                UIView.transition(with: card,
                                                  duration: 0.6,
                                                  options: [],
                                                  animations:{
                                                    card.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                    card.alpha = 0
                                })
            })
            
            
        }
    }
    
    func cardsDontMatch(){
        for card in self.faceUpCards{
            UIView.transition(with: card,
                              duration: 0.6,
                              options: [.transitionFlipFromRight],
                              animations:{
                                card.isfacedUp = !card.isfacedUp
            })
            
            
        }
    }
    
        
    @objc func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayCardView{
                UIView.transition(with: chosenCardView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isfacedUp = !chosenCardView.isfacedUp
                                    self.faceUpCards.append(chosenCardView)
                                },
                                completion: { finished in
                                    print(self.faceUpCards)
                                    if self.cardsMatch {
                                        self.cardsMatched()
                                        self.faceUpCards.removeAll()
                                    }
                                    else if self.turn {
                                        self.cardsDontMatch()
                                        self.faceUpCards.removeAll()
                                    }
                                    
                                })
                
                }
        default:
            break
        }
    }
        
        // Do any additional setup after loading the view.
    


}

