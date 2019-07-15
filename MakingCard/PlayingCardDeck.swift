//
//  PlayingCardDeck.swift
//  MakingCard
//
//  Created by Thiago Outeiro Pereira Damasceno on 12/07/19.
//  Copyright © 2019 Thiago Outeiro Pereira Damasceno. All rights reserved.
//

import Foundation

struct PlayingCardDeck{
    private(set) var cards = [PlayCard]()
    
    init(){
        for suit in PlayCard.Suit.all{
            for rank in PlayCard.Rank.all{
                cards.append(PlayCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayCard? {
        if cards.count > 0 {
            return cards.remove(at: Int(arc4random_uniform(UInt32(cards.count))))
        } else{
            return nil
        }
    }
    
}
