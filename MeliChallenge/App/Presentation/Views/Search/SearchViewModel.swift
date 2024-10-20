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
    
    func search(query: String)
    func loadMoreResults()
}

final class SearchViewModelImp: SearchViewModel {
    var state: PassthroughSubject<StateController, Never>
    
    private let loadSearchUseCase: LoadSearchUseCase
    private var searchItems: [SearchItem] = []
    private var pagingInfo: Paging?
    private var currentQuery: String = ""
    private var isLoadingMore: Bool = false
    
    init(state: PassthroughSubject<StateController, Never>, loadSearchUseCase: LoadSearchUseCase) {
        self.loadSearchUseCase = loadSearchUseCase
        self.state = state
    }
    
    var searchItemList: [SearchItem] {
        return searchItems
    }
    
    func search(query: String) {
        state.send(.loading)
        currentQuery = query
        searchItems = []
        pagingInfo = nil
        fetchResults(query: query, offset: 0)
    }
    
    func loadMoreResults() {
        guard let paging = pagingInfo, !isLoadingMore else { return }
        if searchItems.count < paging.total {
            isLoadingMore = true
            fetchResults(query: currentQuery, offset: searchItems.count)
        }
    }
    
    private func fetchResults(query: String, offset: Int) {
        Task {
            do {
                let limit = AppConstants.itemsPerPage
                let (items, paging) = try await loadSearchUseCase.execute(query: query, offset: offset, limit: limit)
                searchItems.append(contentsOf: items)
                pagingInfo = paging
                isLoadingMore = false
                state.send(.success)
                Logger.log("Success loading search results", level: .info)
            } catch {
                isLoadingMore = false
                let errorMessage = "Error loading search results: \(error.localizedDescription)"
                state.send(.fail(error: errorMessage))
                Logger.log(errorMessage, level: .error)
            }
        }
    }
}
