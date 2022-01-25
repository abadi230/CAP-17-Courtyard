//
//  ViewController.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 13/12/2021.
//

import UIKit
import Firebase

class LogIn: UIViewController {

    let db = Firestore.firestore()
    var user : User!
    var (email, password) = ("", "")
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logInBtn.layer.cornerRadius = 8
        logIn()
    }

    
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func OnLogInPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTF.text!,
                           password: passwordTF.text!) { (user, error) in
            if(error != nil){
                debugPrint(error ?? "Unable to Log in")
                self.showAlert(error?.localizedDescription ?? "")
            }else {
                if Auth.auth().currentUser?.email != "ambajaman@gmail.com"{
                    self.goToHomeVC()
                }else{
                    self.goToAdminHomeVC()
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
    
    func goToHomeVC(){
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "tabID") else { return  }
        // get current user email
        if Auth.auth().currentUser != nil {
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true, completion: nil)
        }
    }
    func goToAdminHomeVC(){
        let adminHomeVC = storyboard?.instantiateViewController(withIdentifier: "AdminHome") as! AdminHome
        adminHomeVC.modalPresentationStyle = .fullScreen
        present(adminHomeVC, animated: true, completion: nil)
    }
    func logIn(){
        if Auth.auth().currentUser != nil{
            
            if Auth.auth().currentUser?.email != "ambajaman@gmail.com"{
                
                self.goToHomeVC()
            }else{
                // VC for Admin
                self.goToAdminHomeVC()
            }
            
        }
    }
    
}

