//
//  RegisterVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 15/12/2021.
//

import UIKit
import FirebaseAuth
import Firebase


class RegisterVC: UIViewController {
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { [self]Result, error in
                  if (error == nil) {
                      print(Result?.user.email ?? "")
                      let user = User()
                      user.storeUserDataInDB(name: name.text!, mobile: mobile.text)

                      guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "tabID") else { return  }
                      // get current user email
                      if Auth.auth().currentUser != nil {
                          homeVC.modalPresentationStyle = .fullScreen
                          present(homeVC, animated: true, completion: nil)
                      }
                  }else{
                      showAlert(error!.localizedDescription)
                  }
              }
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
