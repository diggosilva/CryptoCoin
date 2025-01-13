//
//  CoinsViewController.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import UIKit

class CoinsViewController: UIViewController {
    
    let coinView = CoinView()
    let viewModel: CoinsViewModelProtocol = CoinsViewModel()
    
    override func loadView() {
        super.loadView()
        view = coinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
        handleStates()
        viewModel.fetchCoins()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavBar() {
        let dollar = UIAction(title: "Dólar", image: UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)) { action in
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            self.coinView.searchBar.text = ""
            self.viewModel.fetchCoins()
        }
        
        let real = UIAction(title: "Real", image: UIImage(systemName: "brazilianrealsign.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)) { action in
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "brazilianrealsign.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            self.coinView.searchBar.text = ""
            self.viewModel.fetchCoinsBR()
        }
        
        let menu = UIMenu(title: "Conversão da Moeda para:".uppercased(), options: .singleSelection, children: [dollar, real])
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), menu: menu)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Preços Online"
    }
    
    private func setDelegatesAndDataSources() {
        coinView.searchBar.delegate = self
        coinView.collectionView.delegate = self
        coinView.collectionView.dataSource = self
        coinView.tableview.delegate = self
        coinView.tableview.dataSource = self
    }
    
    private func handleStates() {
        viewModel.state.bind { state in
            switch state {
            case .loading:
                return self.showLoadingState()
            case .loaded:
                return self.showLoadedState()
            case .error:
                return self.showErrorState()
            }
        }
    }
    
    private func showLoadingState() {
        coinView.removeFromSuperview()
    }
    
    private func showLoadedState() {
        coinView.top10Label.text = "Top \(viewModel.numberOfItemsInSection()) Maiores variações"
        coinView.collectionView.reloadData()
        coinView.tableview.reloadData()
        coinView.spinner.stopAnimating()
    }
    
    private func showErrorState() {
        let attempt = viewModel.attempts()
        attempt < 3 ? alertError(title: "Ops... Algo deu errado!", message: "Tentar novamente?") : alertFinal(title: "Desculpe 😔", message: "Tente mais tarde!")
    }
    
    func alertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Sim", style: .default) { action in
            self.viewModel.fetchCoins()
        }
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertFinal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Entendi", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension CoinsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBar(textDidChange: searchText)
        coinView.tableview.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CoinsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        
        if viewModel.isRealCoin {
            cell.configureBR(model: viewModel.cellForItemAt(indexPath: indexPath))
        } else {
            cell.configure(model: viewModel.cellForItemAt(indexPath: indexPath))
        }
        return cell
    }
}

extension CoinsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else { return UITableViewCell() }
       
        if viewModel.isRealCoin {
            cell.configureBR(model: viewModel.cellForRowAt(indexPath: indexPath))
        } else {
            cell.configure(model: viewModel.cellForRowAt(indexPath: indexPath))
        }
        return cell
    }
}
