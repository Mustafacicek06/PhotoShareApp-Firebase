//
//  ViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Çiçek on 8.08.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error"  , alertButtonTitle: "OK")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        // Auth sınıfından auth instance'si oluşturmak gibi
        if  emailText.text != "" && passwordText.text != "" {
        
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", alertButtonTitle: "OK")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        }
        else{
          makeAlert(title: "Login Failed", message: "Username or passoword cannot be left blank.", alertButtonTitle: "OK")
        }
        
        
        }
    
   

}

extension UIViewController {
    
    func makeAlert(title : String, message : String , alertButtonTitle : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title: alertButtonTitle, style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}

