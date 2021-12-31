//
//  ViewController.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 13/12/2021.
//

import UIKit
import Firebase

class LogIn: UIViewController {

    var user : User!
    var (email, password) = ("", "")
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logInBtn.layer.cornerRadius = 8
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "tabID") else { return  }
        // get current user email
        if Auth.auth().currentUser != nil {
            self.navigationController?.show(homeVC, sender: nil)
        }
    }

    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: delete this function
    @IBAction func onClickSignUp(_ sender: UIButton) {
    }
    
    @IBAction func OnLogInPressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
            if(error != nil){
                debugPrint(error ?? "Unable to Log in")
                self.showAlert(error?.localizedDescription ?? "")
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeID") as! HomeVC
                if Auth.auth().currentUser?.email != "ambajaman@gmail.com"{
                    
                    self.navigationController?.show(vc, sender: self)
                }else{
                    // VC for Admin
                }
                
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

