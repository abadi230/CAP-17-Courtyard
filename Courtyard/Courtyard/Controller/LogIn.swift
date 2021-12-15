//
//  ViewController.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 13/12/2021.
//

import UIKit
import Firebase

class LogIn: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func onClickSignUp(_ sender: UIButton) {
    }
    @IBAction func OnLogInPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
            if(error == nil){
                debugPrint(error ?? "Unable to Log in")
                self.showAlert(error?.localizedDescription ?? "")
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeID") as! HomeVC
                self.navigationController?.show(vc, sender: self)
            }
        }
    }
    @IBAction func onClickForgotPass(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { error in
            if(error == nil){
                debugPrint(error ?? "Unable to Log in")
                self.showAlert(error?.localizedDescription ?? "")
            }else{
                self.showAlert("Reset your Passwrd form your Email")
            }
        }
    }
    
}

