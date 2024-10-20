//
//  SearchViewController.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 18/10/24.
//

import UIKit
import Combine

protocol SearchViewControllerCoordinator: AnyObject {
    func didSearchList(model: [SearchItem])
}

final class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModel
    private var cancellable = Set<AnyCancellable>()
    private weak var coordinator: SearchViewControllerCoordinator?
    
    init(viewModel: SearchViewModel, coordinator: SearchViewControllerCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBindings()
        navigationController?.navigationBar.barTintColor = .mainColor
        navigationController?.navigationBar.tintColor = .black
        
        let backBarButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "search_on_mercado_libre".localized
        searchBar.searchTextField.layer.cornerRadius = AppConstants.cornerRadiusSearchBar
        searchBar.searchTextField.layer.masksToBounds = true
    }
    
    private func setupBindings() {
        viewModel.state.receive(on: RunLoop.main).sink { [weak self] state in
            self?.hideSpinner()
            switch state {
            case .success:
                if self?.viewModel.searchItemList.isEmpty ?? true {
                    self?.presentAlert(message: "no_results".localized, title: "information".localized)
                    Logger.log("no_results".localized, level: .info)
                    return
                }
                let model = self?.viewModel.searchItemList
                self?.coordinator?.didSearchList(model: model ?? [])
                Logger.log("success".localized, level: .info)
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.presentAlert(message: error, title: "error".localized)
                Logger.log(error, level: .error)
            }
        }.store(in: &cancellable)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        Logger.log("User searched for: \(query)", level: .info)
        viewModel.search(query: query)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: SpinnerDisplayable {}
extension SearchViewController: MessageDisplayable {}
