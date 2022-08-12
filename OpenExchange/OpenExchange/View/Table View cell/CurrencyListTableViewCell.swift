//
//  CurrencyListTableViewCell.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 09/08/22.
//

import UIKit

class CurrencyListTableViewCell: UITableViewCell {
  
  //MARK: - IBOutlets
  @IBOutlet weak var currencyLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func setCurrency(with title:String){
    currencyLabel.text = title
  }
    
}
