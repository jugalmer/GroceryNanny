//
//  ViewController.swift
//  BigDataGroceryMonitoringApp


import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var pass: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    loginButton.layer.cornerRadius = 20
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func didPressSignInButton(_ sender: Any) {
    ///Redirect it to startup page
    guard let un = Bundle.main.object(forInfoDictionaryKey: "userName") as? String, let pwd = Bundle.main.object(forInfoDictionaryKey: "pwd") as? String,
      let user = email.text, let p = pass.text else { return }
    if un.caseInsensitiveCompare(user) ==  ComparisonResult.orderedSame && pwd == p  {
      let startupVC = UIStoryboard(name: "CommonScreens", bundle: nil).instantiateViewController(withIdentifier: "StartupNavigationVC")
      self.present(startupVC, animated: true, completion: nil)
    }
  }
  
}
