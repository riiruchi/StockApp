//
//  StockListViewModel.swift
//  StockApp
//
//  Created by Ruchira  on 27/05/24.
//

import Combine
import Foundation

class StockListViewModel : ObservableObject {
    @Published var stocks : [Stock] = []
    @Published var wishlist : [Stock] = []
    private var stockService = StockService()
    private var cancellables = Set<AnyCancellable>()
    private let pollingInterval : TimeInterval = 5
    
    init() {
        loadCachedStocks()
        loadCachedWishlist()
        fetchStocks()
        startPolling()
    }
    
    private func loadCachedStocks() {
        if let data = UserDefaults.standard.data(forKey: "stocks"),
           let cachedStocks = try? JSONDecoder().decode([Stock].self, from: data) {
            self.stocks = cachedStocks
        }
    }
    
    private func loadCachedWishlist() {
        if let data = UserDefaults.standard.data(forKey: "wishlist"),
            let cachedWishlist = try? JSONDecoder().decode([Stock].self, from: data) {
            self.wishlist = cachedWishlist
        }
    }
    
    private func saveCachedStocks() {
        if let data = try? JSONEncoder().encode(stocks) {
            UserDefaults.standard.set(data, forKey: "stocks")
        }
    }
    
    private func saveCachedWishlist() {
        if let data = try? JSONEncoder().encode(stocks) {
            UserDefaults.standard.set(data, forKey: "wishlist")
        }
    }
    
    func fetchStocks(){
        stockService.fetchStock { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let stocks) :
                    DispatchQueue.main.async {
                    self.updateStocks(with: stocks)
                    self.saveCachedStocks()
                }
                
            case .failure(let error) :
                print("Failed to fetch stocks \(error)")
            }
        }
    }
    
    private func updateStocks(with newStocks : [Stock]) {
        for newStock in newStocks {
            if let index = stocks.firstIndex(where: { $0.id == newStock.id}) {
                stocks[index].previousPrice = stocks[index].price
                stocks[index].price = newStock.price
            }else {
                stocks.append(newStock)
            }
        }
    }
    
    func startPolling(){
        Timer.publish(every: pollingInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchStocks()
            }.store(in: &cancellables)
    }
    
    func addToWishlist(stock : Stock) {
        if !wishlist.contains(where: { $0.id == stock.id}) {
            wishlist.append(stock)
            self.saveCachedWishlist()
        }
    }
    
    func removeFromWishlist(stock: Stock) {
        wishlist.removeAll { $0.id == stock.id }
        self.saveCachedWishlist()
    }
}
