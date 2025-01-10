//
//  CollectionCell.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 09/01/25.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    static let identifier = "CollectionCell"
    
    lazy var coinImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "bitcoinsign.circle.fill")
        img.layer.cornerRadius = 35/2
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var symbolLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "BTC"
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var currentPriceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "R$ 9,876,54"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.6
        lbl.textColor = .secondaryLabel
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var percentage24HLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "1.23%"
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .systemGreen
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        configCellForCollection(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews([coinImage, symbolLabel, currentPriceLabel, percentage24HLabel])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            coinImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            coinImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            coinImage.widthAnchor.constraint(equalToConstant: 35),
            coinImage.heightAnchor.constraint(equalTo: coinImage.widthAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: coinImage.bottomAnchor, constant: 20),
            symbolLabel.leadingAnchor.constraint(equalTo: coinImage.leadingAnchor),
            
            currentPriceLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            currentPriceLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 5),
            currentPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            
            percentage24HLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor),
            percentage24HLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
        ])
    }
}
