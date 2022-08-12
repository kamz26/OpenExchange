//
//  CurrencyViewController.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 09/08/22.
//

import UIKit

class CurrencyViewController: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var amountTextfield: UITextField!
  @IBOutlet weak var selectedCurrencyLabel: UILabel!
  @IBOutlet weak var currencySelectionView: UIView!
  @IBOutlet weak var currenciesCollectionView: UICollectionView!
  @IBOutlet weak var currenciesListTableView: UITableView!
  @IBOutlet weak var currenciesListTableViewHeightConstraint: NSLayoutConstraint!
  
  private var isShowingCurrencyListTableView:Bool = false{
    didSet{
      if (isShowingCurrencyListTableView){
        showTableView()
      }else{
        hideTableView()
      }
    }
  }
  
  var currencyViewModel:CurrencyListViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewSetup()
    viewModelSetup()
  }
  @IBAction func textDidChange(_ sender: UITextField) {
    currencyViewModel.currentEnteredAmount = Double(sender.text ?? "") ?? 0.0
  }
  
  //MARK: - View Setup
  private func viewSetup(){
    currencySelectinViewSetup()
    currencyCollectionViewSetup()
    currenciesTableViewSetup()
  }
  
  private func currencySelectinViewSetup(){
    currencySelectionView.addTapGestureRecognizer {[weak self] in
      guard let safeSelf = self else {return}
      safeSelf.isShowingCurrencyListTableView = !(safeSelf.isShowingCurrencyListTableView)
      
    }
    currencySelectionView.addBorder(with: 1, borderColor: .gray, cornerRadius: 4)
  }
  
  private func currencyCollectionViewSetup(){
    currenciesCollectionView.register(cellType: CurrencyCollectionViewCell.self)
    
    currenciesCollectionView.delegate = self
    currenciesCollectionView.dataSource = self
  }
  
  private func currenciesTableViewSetup(){
    currenciesListTableView.addBorder(with: 1, borderColor: .gray, cornerRadius: 4)
    currenciesListTableView.register(cellType: CurrencyListTableViewCell.self)
    
    currenciesListTableView.delegate = self
    currenciesListTableView.dataSource = self
  }
  
  private func showTableView(){
    UIView.transition(with: currenciesListTableView,
                      duration: 0.33,
                      options: [.curveEaseOut],
                      animations: {
      self.currenciesListTableView.isHidden = false
      self.currenciesListTableViewHeightConstraint.constant = 120
      self.currenciesListTableView.reloadAsync()
    })
  }
  
  private func hideTableView(){
    currenciesListTableView.isHidden = true
    currenciesListTableViewHeightConstraint.constant = 0
    currenciesListTableView.reloadAsync()
  }
  //MARK: - View Model Setup
  private func viewModelSetup(){
    self.currencyViewModel = CurrencyListViewModel(updateDelegate: self, convertUpdateDelegate: self)
    self.currencyViewModel.getCurrenciesData()
  }
  
}

//MARK: - CollectionView Delegate & DataSource
extension CurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currencyViewModel.currentEnteredAmount != nil ? currencyViewModel.currenciesCount : 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(with: CurrencyCollectionViewCell.self, for: indexPath)
    let currency = currencyViewModel.getCurrenciesList[indexPath.row]
    let amount = currencyViewModel.getAmountForCurrency(curreny: currency)
    cell.setCurrencyCollectionView(with: amount, currency: currency)
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
      let numberOfCells:CGFloat = 3
      let collectionViewWidth  = collectionView.bounds.width
      let flowLayout = collectionViewLayout   as! UICollectionViewFlowLayout
      let interinsicSize = (flowLayout.minimumInteritemSpacing) * (numberOfCells - 1)
      let width = (collectionViewWidth ) / numberOfCells
      return CGSize.init(width: width - interinsicSize , height: width - interinsicSize)
      
  }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencyViewModel.currenciesCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: CurrencyListTableViewCell.self, for: indexPath)
    cell.setCurrency(with: currencyViewModel.getCurrenciesList[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.currencyViewModel.currentCurrecySelected = currencyViewModel.getCurrenciesList[indexPath.row]
    self.selectedCurrencyLabel.text = currencyViewModel.getCurrenciesList[indexPath.row]
    self.isShowingCurrencyListTableView = false
  }
}



//MARK: - CurrencyListUpdateProtocol
extension CurrencyViewController: CurrencyListUpdateProtocol{
  func didUpdateCurrencyList() {
    self.currenciesListTableView.reloadAsync()
  }
}

//MARK: - CurrencyconversionUpdateProtocol
extension CurrencyViewController: CurrencyconversionUpdateProtocol{
  func updateConversionList(){
    self.currenciesCollectionView.reloadAsync()
  }
}
