//
//  SearchViewModel.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation
import Combine

protocol SearchViewModel {
    var state: PassthroughSubject<StateController, Never> { get }
    var searchItemList: [SearchItem] { get }
    
    var pagingInfo: Paging? { get }
    var currentQuery: String { get }
    
    func search(query: String)
    func loadMoreResults()
}

final class SearchViewModelImp: SearchViewModel {
    var state: PassthroughSubject<StateController, Never>
    
    private let loadSearchUseCase: LoadSearchUseCase
    private var searchItems: [SearchItem] = []
    private var pagingInfoInternal: Paging?
    private var currentQueryInternal: String = ""
    private var isLoading = false
    
    init(state: PassthroughSubject<StateController, Never>, loadSearchUseCase: LoadSearchUseCase) {
        self.loadSearchUseCase = loadSearchUseCase
        self.state = state
    }
    
    var searchItemList: [SearchItem] {
        return searchItems
    }
    
    var pagingInfo: Paging? {
        return pagingInfoInternal
    }
    
    var currentQuery: String {
        return currentQueryInternal
    }
    
    func search(query: String) {
        state.send(.loading)
        currentQueryInternal = query
        searchItems = []
        pagingInfoInternal = nil
        fetchResults(query: query, offset: 0)
    }
    
    func loadMoreResults() {
        guard let paging = pagingInfoInternal, !isLoading else { return }
        if searchItems.count < paging.total {
            isLoading = true
            fetchResults(query: currentQueryInternal, offset: searchItems.count)
        }
    }
    
    private func fetchResults(query: String, offset: Int) {
        Task {
            do {
                let limit = AppConstants.itemsPerPage
                let (items, paging) = try await loadSearchUseCase.execute(query: query, offset: offset, limit: limit)
                searchItems.append(contentsOf: items)
                pagingInfoInternal = paging
                isLoading = false
                state.send(.success)
                Logger.log("Success loading search results", level: .info)
            } catch {
                isLoading = false
                let errorMessage = "Error loading search results: \(error.localizedDescription)"
                state.send(.fail(error: errorMessage))
                Logger.log(errorMessage, level: .error)
            }
        }
    }
}
