//
//  TableCell.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 09/01/25.
//

import UIKit
import SDWebImage

class TableCell: UITableViewCell {
    static let identifier = "TableCell"
    
    lazy var marketCapRankLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .secondaryLabel
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    
    lazy var coinImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "dollarsign.circle.fill")
        img.layer.cornerRadius = 35/2
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
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
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    
    lazy var percentage24HLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    func configure(model: CoinResponse) {
        guard let url = URL(string: model.image) else { return }
        marketCapRankLabel.text = "\(model.marketCapRank)"
        coinImage.sd_setImage(with: url)
        nameLabel.text = model.name
        symbolLabel.text = model.symbol.uppercased()
        currentPriceLabel.text = formatCurrencyUS(model.currentPrice)
        percentage24HLabel.text = "\(String(format: "%.2f", model.priceChangePercentage24H))%"
        percentage24HLabel.textColor = model.priceChangePercentage24H > 0 ? .systemGreen : .systemRed
    }
    
    func configureBR(model: CoinResponse) {
        guard let url = URL(string: model.image) else { return }
        marketCapRankLabel.text = "\(model.marketCapRank)"
        coinImage.sd_setImage(with: url)
        nameLabel.text = model.name
        symbolLabel.text = model.symbol.uppercased()
        currentPriceLabel.text = formatCurrencyBR(model.currentPrice)
        percentage24HLabel.text = "\(String(format: "%.2f", model.priceChangePercentage24H))%"
        percentage24HLabel.textColor = model.priceChangePercentage24H > 0 ? .systemGreen : .systemRed
    }
    
    private func setHierarchy() {
        addSubviews([marketCapRankLabel, coinImage, nameLabel, symbolLabel, currentPriceLabel, percentage24HLabel])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            marketCapRankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            marketCapRankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            coinImage.centerYAnchor.constraint(equalTo: marketCapRankLabel.centerYAnchor),
            coinImage.leadingAnchor.constraint(equalTo: marketCapRankLabel.trailingAnchor, constant: 10),
            coinImage.widthAnchor.constraint(equalToConstant: 35),
            coinImage.heightAnchor.constraint(equalTo: coinImage.widthAnchor),
            coinImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            coinImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: coinImage.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: coinImage.trailingAnchor, constant: 10),
            
            symbolLabel.bottomAnchor.constraint(equalTo: coinImage.bottomAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            currentPriceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            currentPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            percentage24HLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            percentage24HLabel.trailingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor),
        ])
    }
}
