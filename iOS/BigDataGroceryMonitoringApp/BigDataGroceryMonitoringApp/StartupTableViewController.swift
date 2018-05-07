//
//  StartupTableViewController.swift
//  BigDataGroceryMonitoringApp

import UIKit

class StartupTableViewController: UITableViewController {

  var groceryVM = GroceryViewModel()
  var results: [RecommendationModel]? {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup search bar
      setupSearchBar()
      let recommendationCellNib = UINib(nibName: "RecommendationsTableViewCell", bundle: nil)
      self.tableView.register(recommendationCellNib, forCellReuseIdentifier: "recommendationsCell")
      DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
        self.generateAlert()
      })
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //call webservice, observe a value and then add
    self.loadData()
  }
  
    private func setupSearchBar() 
    {
      let percentWidth: CGFloat = 0.62
      let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * percentWidth, height: 32))
      customView.backgroundColor = UIColor(white: 0.92, alpha: 1)
      customView.layer.cornerRadius = 5.0
  
      let searchBar = UILabel(frame: CGRect(x: 8, y: 11, width: customView.frame.width, height: 14))
      searchBar.text = "search"
      searchBar.font = UIFont(name:"ATTSans-Regular",size:14)
      searchBar.textColor = UIColor(white: 0.50, alpha: 1)
      searchBar.textAlignment = .left
      customView.addSubview(searchBar)
      self.navigationItem.titleView = customView
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnSearch))
      searchBar.isUserInteractionEnabled = true
      searchBar.addGestureRecognizer(tap)
    }
  
  @objc func handleTapOnSearch(sender: UITapGestureRecognizer) {
    let searchVC = UIStoryboard(name: "CommonScreens", bundle: nil).instantiateViewController(withIdentifier: "SearchNavigationVC")
    self.present(searchVC, animated: true, completion: nil)
  }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80.0
  }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendationsCell", for: indexPath)
        cell.selectionStyle = .none
      if let customcell = cell as? RecommendationsTableViewCell {
        if let items = results, items.count > indexPath.row, let item = items[indexPath.row] as? RecommendationModel {
          customcell.title?.text = item.productName
          let exp = item.expiry
          var expSub = exp
          if exp.count > 10 {
            expSub = String(exp[..<exp.index(exp.startIndex, offsetBy: 10)])
          }
          
          let desc = String(format: "price %@$          exp %@", String(describing: item.cost), expSub)
          customcell.desc?.text = desc
          customcell.imageVW.image = UIImage(named: "\(item.productId)")
        }
      }
        return cell
    }
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          if let res = results, res.count > indexPath.row {
            results?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
          }
        } else if editingStyle == .insert {
          
        }    
    }
  
  
  private func loadData() {
    
    do {
      try self.groceryVM.fetchHome(withCompletion: { (result) in
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
  
  private func generateAlert() {
    let confirm = UIAlertController(title: "Pancake Mix is about to expire tomorrow", message: "", preferredStyle: UIAlertControllerStyle.alert)
    confirm.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default))
    self.present(confirm, animated: true, completion: nil)
  }
  
  @IBAction func tapLogout(_ sender: Any) {
    let startupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigationVC")
    self.present(startupVC, animated: true, completion: nil)
    
  }
  
}
