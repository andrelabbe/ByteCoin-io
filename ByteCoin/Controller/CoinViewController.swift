//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController, UIPickerViewDataSource {
    

   
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var cryptoCurrencyPicker: UIPickerView!
    @IBOutlet weak var cryptoCurrencyImage: UIImageView!
    @IBOutlet weak var currencyImage: UIImageView!
    
    var coinManager = CoinManager()
    
    var currencyRowPicker: String = ""
    var cryptoCurrencyRowPicker: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        cryptoCurrencyPicker.dataSource = self
        cryptoCurrencyPicker.delegate = self
        currencyRowPicker = "AUD"
        cryptoCurrencyRowPicker = "BTC"
        coinManager.getCoinPrice(for: currencyRowPicker, for: cryptoCurrencyRowPicker)
    }

 
}
//MARK: - UIPickerViewDelegate
extension CoinViewController: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let picker = pickerView.tag      //pickerView.description
        switch (picker){
        case 0: // "Crypto Picker"
            return coinManager.cryptoCurrencyArray.count
        case 1: // "Currency Picker"
            return coinManager.currencyArray.count
        default:
            print("PickerView: numberOfRowsInComponent Error!")
            return 0
        }
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let picker = pickerView.tag
         switch (picker){
         case 0: // "Crypto Picker"
             return coinManager.cryptoCurrencyArray[row]
         case 1: // "Currency Picker"
             return coinManager.currencyArray[row]
         default:
             print("PickerView: titleForRow Error!")
             return ""
         }
     }

    func pickerView(_ pickerView:UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let picker = pickerView.tag
        var selectedCryptoCurrency: String? = nil
        var selectedCurrency: String? = nil
        
        switch (picker){
        case 0: // "Crypto Picker"
            selectedCryptoCurrency = coinManager.cryptoCurrencyArray[row]
        case 1: // "Currency Picker"
            selectedCurrency = coinManager.currencyArray[row]
        default:
            print("PickerView: didSelectRow Error!")
        }
        
        if selectedCryptoCurrency != nil {
            cryptoCurrencyRowPicker =  selectedCryptoCurrency!
        }
        if selectedCurrency != nil {
            currencyRowPicker =  selectedCurrency!
        }
        
        coinManager.getCoinPrice(for: currencyRowPicker, for: cryptoCurrencyRowPicker)
        
        let cryptoName: String = "\(String(describing: cryptoCurrencyRowPicker.lowercased())).pdf"
        let currencyName: String = "\(String(describing: currencyRowPicker.lowercased())).pdf"
        cryptoCurrencyImage.image = UIImage(named:cryptoName)
        currencyImage.image = UIImage(named:currencyName)
    }
}

//MARK: - CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate {
   
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String("1 = \(coin.currencyAmountString)")
        }
    }
    
    func didFailWithError(error: Error) {
     print("The error is: \(error)")
    }

}
