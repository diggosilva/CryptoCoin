//
//  CoinsViewController.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import UIKit

class CoinsViewController: UIViewController {
    
    let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        service.getCoins { coins in
            print("COINS AQUI: \(coins)")
        } onError: { error in
            
        }
    }
}
