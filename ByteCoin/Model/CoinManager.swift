//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
    
}

struct CoinManager {

    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "B8E64CE9-xxxx-4D2D-998D-A7FE3A6C6868"
    
    let currencyArray =
        ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY",
         "MXN", "NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    let cryptoCurrencyArray =
    ["BTC", "ETH", "LTC","XRP","ADA", "Nano", "XMR"]
   
    
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String, for cryptoCurrency: String) {
        
        let urlString = ("\(baseURL)/\(cryptoCurrency)/\(currency)?apikey=\(apiKey)")
        performRequest(with:urlString)
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            self.delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }

    func performRequest(with urlString: String){

        if let url = URL(string: urlString) {
            //print ("Get Json: \(url)")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {                    
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }

            task.resume()
        }
 
    }
    
    func parseJSON (_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let id_Base  = decodedData.asset_id_base
            let id_Quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            let coin = CoinModel(currencyAmount: rate, idQuote: id_Quote, idBase: id_Base)
            
            return coin
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

