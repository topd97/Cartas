//
//  PlayCard.swift
//  MakingCard
//
//  Created by Thiago Outeiro Pereira Damasceno on 12/07/19.
//  Copyright © 2019 Thiago Outeiro Pereira Damasceno. All rights reserved.
//

import UIKit

struct PlayCard: CustomDebugStringConvertible{
    var debugDescription: String{ return "\(rank) \(suit)"}
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomDebugStringConvertible{
        case espadas = "♠️"
        case copas = "❤️"
        case paus = "♣️"
        case ouros = "♦️"
        
        static var all = [Suit.copas,.espadas,.ouros,.paus]
        
        var debugDescription: String { return rawValue}
    }
    enum Rank: CustomDebugStringConvertible{
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int{
            switch self{
            case .ace: return 1
            case .numeric(let number): return number
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        static var all: [Rank]{
            var allRanks = [Rank.ace]
            for number in 2...10{
                allRanks.append(Rank.numeric(number))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        var debugDescription: String{
            switch self {
            case .ace: return "A"
            case .numeric(let number): return String(number)
            case .face(let kind): return kind
            }
        }
    }
    
    
}
