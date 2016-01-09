//
//  CardCollectionViewCell.swift
//  HIT
//
//  Created by Nathan Melehan on 12/28/15.
//  Copyright © 2015 Nathan Melehan. All rights reserved.
//

import UIKit

@IBDesignable class CardCollectionViewCell: UICollectionViewCell {
    
    var cardView: CardView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCardView()
    }
    
    func setupCardView() {
        cardView = CardView()
        self.contentView.addSubview(cardView)
        
        // pin cardView to self
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.pinItem(self.contentView, toItem: cardView, withAttribute: .Top).active = true
        NSLayoutConstraint.pinItem(self.contentView, toItem: cardView, withAttribute: .Leading).active = true
        NSLayoutConstraint.pinItem(self.contentView, toItem: cardView, withAttribute: .Trailing).active = true
        NSLayoutConstraint.pinItem(self.contentView, toItem: cardView, withAttribute: .Bottom).active = true
    }
}