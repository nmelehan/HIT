//
//  PulledCardViewController.swift
//  HIT
//
//  Created by Nathan Melehan on 2/2/16.
//  Copyright © 2016 Nathan Melehan. All rights reserved.
//

import UIKit

class PulledCardViewController: UIViewController, PulledCardViewDelegate {

    @IBOutlet weak var pulledCardView: PulledCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    // Data controller
    
    let dataSource: MantraDataSource = UserMantraDataManager.sharedManager
    
    override func viewDidLayoutSubviews() {
        if pulledCardView.delegate == nil {
            pulledCardView.delegate = self
        }
    }
    
    func pulledCard() -> CardView?
    {
        let card = CardView()
        card.annotation = dataSource.currentMantra
        return CardView()
    }
    
    func cardsDisplayedInStack() -> [CardView]
    {
        return (1..<5)
            .map { dataSource.mantraWithId($0)! }
            .map {
                let card = CardView()
                card.annotation = $0
                return card
            }
    }
}