//
//  CoinsView.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 09/01/25.
//

import UIKit

class CoinView: UIView {
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Buscar moedas..."
        sb.searchBarStyle = .minimal
        sb.autocorrectionType = .no
        sb.enablesReturnKeyAutomatically = true
        sb.enablesReturnKeyAutomatically = true
        return sb
    }()
    
    // MARK: COLLECTIONVIEW
    lazy var top10Label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .headline)
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 140, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        cv.alwaysBounceHorizontal = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray4
        return divider
    }()
    
    // MARK: TABLEVIEW
    lazy var allCoinsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Todas as Moedas"
        lbl.font = .preferredFont(forTextStyle: .headline)
        return lbl
    }()
    
    lazy var coinLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Moeda"
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    lazy var priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Preço"
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .secondaryLabel
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)
        tv.allowsSelection = false
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tv
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()
    
    lazy var loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Carregando..."
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setLoadingState() {
        spinner.startAnimating()
        loadingLabel.isHidden = false
        collectionView.isHidden = true
        tableview.isHidden = true
    }
    
    func setLoadedState() {
        spinner.stopAnimating()
        loadingLabel.isHidden = true
        collectionView.isHidden = false
        tableview.isHidden = false
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        backgroundColor = .systemBackground
        addSubviews([searchBar, top10Label, collectionView, divider, allCoinsLabel, coinLabel, priceLabel, tableview, spinner, loadingLabel])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            top10Label.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            top10Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            top10Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: top10Label.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            divider.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.4),
        ])
        
        NSLayoutConstraint.activate([
            allCoinsLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            allCoinsLabel.leadingAnchor.constraint(equalTo: top10Label.leadingAnchor),
            
            coinLabel.topAnchor.constraint(equalTo: allCoinsLabel.bottomAnchor, constant: 20),
            coinLabel.leadingAnchor.constraint(equalTo: allCoinsLabel.leadingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: coinLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tableview.topAnchor.constraint(equalTo: coinLabel.bottomAnchor, constant: 10),
            tableview.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            loadingLabel.centerXAnchor.constraint(equalTo: spinner.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor),
        ])
    }
}
