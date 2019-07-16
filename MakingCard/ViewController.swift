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
    
    @IBOutlet weak var playCardView: PlayCardView!{
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playCardView.addGestureRecognizer(swipe)
            let pinch = UIPinchGestureRecognizer(target: playCardView, action: #selector(PlayCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            playCardView.addGestureRecognizer(pinch)
        }
    }
    
    @objc func nextCard(){
        if let card = deck.draw(){
            playCardView.rank = card.rank.order
            playCardView.suit = card.suit.debugDescription
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        playCardView.isfacedUp = !playCardView.isfacedUp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...10{
            if let card = deck.draw(){
//                print("\(card)")
            }
        }
        // Do any additional setup after loading the view.
    }


}

