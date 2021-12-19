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
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [self]Result, error in
                  if (error == nil) {
                      print(Result?.user.email ?? "")
                      
                      let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginin") as! LogIn
                      loginVC.emailTF.text = emailTF.text!
                      loginVC.passwordTF.text = passwordTF.text!
                      self.present(loginVC, animated: true, completion: nil)
                  }else{
                      print(error?.localizedDescription as Any)
                  }
              }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
