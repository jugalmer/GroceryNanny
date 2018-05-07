//
//  SearchTableViewController.swift
//  BigDataGroceryMonitoringApp

import UIKit

class SearchTableViewController: UITableViewController {
  
   var searchBar: UISearchBar!
   var groceryVM = GroceryViewModel()

  var searchResults: [SearchInternalModel]? {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  
  //Create a serial search operation queue. This will ensure that we only have one search operation at a time.
  lazy var searchOperationQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Search Queue"
    queue.maxConcurrentOperationCount = 1
    queue.qualityOfService = .userInitiated
    return queue
  }()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      //self.tableView.allowsMultipleSelection = true
      self.setupSearchBar()
    }
  
  private func setupSearchBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(searchBarCancelButtonClicked))
    navigationItem.rightBarButtonItem?.tintColor = UIColor.gray
    searchBar = UISearchBar()
    searchBar.placeholder = "search"
    searchBar.searchBarStyle = .minimal
    searchBar.isTranslucent = false
    searchBar.delegate = self
    searchBar.tintColor = UIColor.gray
    navigationItem.titleView = searchBar
    searchBar.becomeFirstResponder()
    searchBar.enablesReturnKeyAutomatically = true
    self.navigationController?.navigationBar.isTranslucent = false
    self.searchBar.isTranslucent = false
  }

  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
      cell.selectionStyle = .none
      
      if let result = searchResults{
        let item = result[indexPath.row]
        cell.textLabel?.text = item.productName
        cell.detailTextLabel?.text = "cost"
      }
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
  
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }

}

extension SearchTableViewController: UISearchBarDelegate {
 
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    self.searchBar.resignFirstResponder()
    self.dismiss(animated: true) {}
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchOperationQueue.cancelAllOperations() // cancel any operation performed
    self.searchOperationQueue.addOperation {
      do {
        try self.groceryVM.fetchSearchResults(forValue: searchText) { (result) in
          switch result {
          case let .success(res):
            self.searchResults = res
            print("**************")
          case let .failure(err):
            print("eror**************")
          }
        }
      }
      catch let error {
        print(error)
      }
    }
  }
}
