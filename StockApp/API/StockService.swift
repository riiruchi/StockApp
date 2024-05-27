//
//  StockService.swift
//  StockApp
//
//  Created by Ruchira  on 27/05/24.
//

import Foundation

class StockService {
    private let baseURL = "https://api.tickertape.in/stocks/quotes?sids=RELI,TCS,ITC,HDBK,INFY"
    
    func fetchStock(completion: @escaping (Result<[Stock],Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let stockResponse = try decoder.decode(StockResponse.self, from: data)
                if stockResponse.success {
                    completion(.success(stockResponse.data))
                }else {
                    completion(.failure(NSError(domain: "API Error", code: -1, userInfo: nil)))
                }
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
