//
//  CoinsViewController.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import UIKit

class CoinsViewController: UIViewController {
    
    let coinView = CoinView()
    
    override func loadView() {
        super.loadView()
        view = coinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        title = "Preços Online"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setDelegatesAndDataSources() {
        coinView.collectionView.delegate = self
        coinView.collectionView.dataSource = self
        coinView.tableview.delegate = self
        coinView.tableview.dataSource = self
    }
}

extension CoinsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        return cell
    }
}

extension CoinsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else { return UITableViewCell() }
        return cell
    }
}
