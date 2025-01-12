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

func configCellForCollection(_ cell: UIView) {
    cell.backgroundColor = .systemBackground
    cell.layer.borderWidth = 1
    cell.layer.borderColor = UIColor.lightGray.cgColor
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 5, height: 5)
    cell.layer.shadowOpacity = 0.3
    cell.layer.shadowRadius = 5
    cell.layer.cornerRadius = 10
}

func formatCurrencyUS(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    guard let formattedString = formatter.string(from: NSNumber(value: value)) else { return "" }
    return formattedString
}

func formatCurrencyBR(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.numberStyle = .currency
    formatter.currencyCode = "BRL"
    guard let formattedString = formatter.string(from: NSNumber(value: value)) else { return "" }
    return formattedString
}
