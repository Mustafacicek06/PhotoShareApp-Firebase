//
//  SettingsViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Çiçek on 9.08.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
          try  Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
            print("Sign out Succesful.")
        }
        catch{
            print("Sign out error.")
        }
       
     
    }
    
  

}
