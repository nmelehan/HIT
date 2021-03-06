//
//  UserMantraDataManager+CollapsedCardStackViewDataSource.swift
//  HIT
//
//  Created by Nathan Melehan on 2/8/16.
//  Copyright © 2016 Nathan Melehan. All rights reserved.
//

import Foundation

extension UserMantraDataManager: CollapsedCardStackViewDataSource
{
    func numberOfItems() -> Int
    {
        return mantras.count
    }
    
    func cardViewForItem(item: Int) -> CardView
    {
        let cardView = TestCardView()
        let cardColor = UIColor.randomColor()//.colorWithAlphaComponent(0.25)
        cardView.backgroundView.backgroundColor = cardColor
        cardView.mantra = mantras[item]
        return cardView
    }
    
    func commitDeletionForItem(item: Int)
    {
        let mantra = mantras[item]
        userMantras.removeValueForKey(mantra.id)
    }
}