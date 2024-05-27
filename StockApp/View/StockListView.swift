//
//  StockListView.swift
//  StockApp
//
//  Created by Ruchira  on 27/05/24.
//

import SwiftUI

struct StockListView: View {
  @StateObject var viewModel = StockListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.stocks) { stock in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stock.id).font(.headline)
                            Text(String(format: "%.2f", stock.price)).font(.subheadline).foregroundColor(stock.priceChangeColor)
                        }
                        Spacer()
                        Image(systemName: stock.priceChangeIcon).foregroundColor(stock.priceChangeColor)
                        Button(action : {
                            if viewModel.wishlist.contains(where: { $0.id == stock.id}) {
                                viewModel.removeFromWishlist(stock: stock)
                            }else {
                                viewModel.addToWishlist(stock: stock)
                            }
                        }) {
                            Image(systemName: viewModel.wishlist.contains(where: { $0.id == stock.id }) ? "start.fill" : "start").foregroundColor(.yellow)
                        }
                    }
                }
            }.navigationTitle("Stocks")
                .toolbar {
                    NavigationLink(destination: WishlistView(viewModel: viewModel)) {
                        Text("Wishlist")
                    }
                }
        }
    }
}

extension Stock {
    var priceChangeColor : Color {
        if let previousPrice = previousPrice {
            return price > previousPrice ?.green : .red
        }
        return .black
    }
    
    var priceChangeIcon : String {
        if let previousPrice = previousPrice {
            return price > previousPrice ? "arrow.up" : "arrow.down"
        }
        return "minus"
    }
}

