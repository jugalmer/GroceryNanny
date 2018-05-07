//
//  SuggestedPageTableViewController.swift
//  BigDataGroceryMonitoringApp

import UIKit

class SuggestedPageTableViewController: UITableViewController {

  var groceryVM = GroceryViewModel()
  var results: [RecommendationModel]? {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  var selectedItem: RecommendationModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.restoreTableView()
      self.loadData()
      let recommendationCellNib = UINib(nibName: "RecommendationsTableViewCell", bundle: nil)
      self.tableView.register(recommendationCellNib, forCellReuseIdentifier: "recommendationsCell")
      
    }
  
    @IBAction func pressCancelButton(_ sender: Any) {
      self.restoreTableView()
    }
  
    @IBAction func pressSelectionButton(_ sender: Any) {
      guard let title = self.navigationItem.rightBarButtonItem?.title else { return }
      if title == "select" {
          self.navigationItem.rightBarButtonItem?.title = "add"
          self.navigationItem.leftBarButtonItem?.title = "cancel"
          //self.tableView.allowsMultipleSelection = true
          self.tableView.allowsSelection = true
      } else if title == "add" {
        guard let item = selectedItem else { return }
          do {
            try self.groceryVM.addGrocery(pid: item.productId, pname: item.productName, pcost: item.price, pexp: item.expiry, withCompletion: { (result) in
              switch result {
              case let .success(res):

                let confirm = UIAlertController(title: "\(item.productName) is added to your list.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                confirm.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                  self.restoreTableView()
                }))
                self.present(confirm, animated: true, completion: nil)
              case let .failure(err):
                print("error**************")
              }
              
            })
          }
          catch let error {
            print(error)
          }
      }
  }
  
  private func restoreTableView() {
    if let selectedRows = self.tableView.indexPathsForSelectedRows {
      for indexPath in selectedRows {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
      }
    }
    self.navigationItem.leftBarButtonItem?.title = ""
    self.navigationItem.rightBarButtonItem?.title = "select"
    //self.tableView.allowsMultipleSelection = false
    self.tableView.allowsSelection = false
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
        // #warning Incomplete implementation, return the number of rows
        return results?.count ?? 0
    }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70.0
  }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "recommendationsCell", for: indexPath)
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
      if let customcell = cell as? RecommendationsTableViewCell {
        if let items = results, items.count > indexPath.row, let item = items[indexPath.row] as? RecommendationModel {
          customcell.selectedItem = item
          customcell.selectedItem?.expiry = item.date
          customcell.title?.text = item.productName
          let desc = String(format: "Great price %@$", String(describing: item.price))
          customcell.desc?.text = desc
          customcell.imageVW.image = UIImage(named: "\(item.productId)")
        }
      }
        cell.selectionStyle = .none
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) as? RecommendationsTableViewCell {
        selectedItem = cell.selectedItem
      }
      tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
  
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
  
  private func loadData() {
    
    do {
      try self.groceryVM.fetchRecommendation(withCompletion: { (result) in
        switch result {
        case let .success(res):
          self.results = res
        case let .failure(err):
          print("error**************")
        }

      })
    }
    catch let error {
      print(error)
    }
  }

}
