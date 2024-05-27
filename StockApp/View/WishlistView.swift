//
//  WishlistView.swift
//  StockApp
//
//  Created by Ruchira  on 27/05/24.
//

import SwiftUI

struct WishlistView: View {
    @ObservedObject var viewModel : StockListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.wishlist) { stock in
                HStack {
                    VStack(alignment:.leading) {
                        Text(stock.id).font(.headline)
                        Text(String(format: "%.2f", stock.price)).font(.subheadline).foregroundColor(stock.priceChangeColor)
                    }
                    
                    Spacer()
                    Image(systemName: stock.priceChangeIcon).foregroundColor(stock.priceChangeColor)
                }
            }
        }.navigationTitle("Wishlist")
    }
}
