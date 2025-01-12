//
//  CollectionCell.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 09/01/25.
//

import UIKit
import SDWebImage

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
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    
    lazy var currentPriceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.6
        lbl.textColor = .secondaryLabel
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    
    lazy var percentage24HLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configure(model: CoinModel) {
        guard let url = URL(string: model.image) else { return }
        coinImage.sd_setImage(with: url)
        symbolLabel.text = model.symbol.uppercased()
        currentPriceLabel.text = formatCurrencyUS(model.currentPrice)
        percentage24HLabel.text = "\(String(format: "%.2f", model.priceChangePercentage24H))%"
    }
    
    func configureBR(model: CoinModel) {
        guard let url = URL(string: model.image) else { return }
        coinImage.sd_setImage(with: url)
        symbolLabel.text = model.symbol.uppercased()
        currentPriceLabel.text = formatCurrencyBR(model.currentPrice)
        percentage24HLabel.text = "\(String(format: "%.2f", model.priceChangePercentage24H))%"
    }
    
    private func setHierarchy() {
        addSubviews([coinImage, symbolLabel, currentPriceLabel, percentage24HLabel])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            coinImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            coinImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinImage.widthAnchor.constraint(equalToConstant: 35),
            coinImage.heightAnchor.constraint(equalTo: coinImage.widthAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: coinImage.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: coinImage.trailingAnchor, constant: 5),
            
            currentPriceLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            currentPriceLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 5),
            currentPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            
            percentage24HLabel.bottomAnchor.constraint(equalTo: coinImage.bottomAnchor),
            percentage24HLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
        ])
    }
}
