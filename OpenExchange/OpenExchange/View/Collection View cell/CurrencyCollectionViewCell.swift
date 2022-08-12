//
//  CurrencyCollectionViewCell.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 09/08/22.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
  
  //MARK:- IBOutlets
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  

  override func awakeFromNib() {
    super.awakeFromNib()
    setUI()
  }
  
  private func setUI(){
    self.addBorder(with: 1, borderColor: .lightGray, cornerRadius: 10)
  }
  
  func setCurrencyCollectionView(with amount:Double, currency:String){
    self.amountLabel.text = amount.description
    self.currencyLabel.text = currency
  }

}
