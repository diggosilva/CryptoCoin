//
//  Extensions.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 09/01/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach({ addSubview($0) })
    }
}
