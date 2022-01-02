//
//  HomeVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 15/12/2021.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class HomeVC: UIViewController {

    let db = Firestore.firestore()
    var user = User()
    var services : [String] = ["Courtyard", "Roof of House", "Stairs"]

    // TODO: adapt pull down Button and Pop Up Button
    @IBOutlet weak var welcomLbl : UILabel!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
//        datePicker.date = Date.now
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        configDatePicker()
//        sendToDB()
        
    }
    func fetchData(){
        //from DB
        user.getDataClosure(completion: { user  in
            print ("Closure Done")
            print (user.name)
            self.welcomLbl.text = "Welcome \(user.name!)"
        })
    }

    
    func configDatePicker(){
        let action = UIAction{ _ in
            print(self.datePicker.date)
            
        }
        datePicker.addAction(action, for: .valueChanged)
    }
        
   
    @IBAction func onClickBook(_ sender: UIButton) {
        if txtBox.text != "" && datePicker.date != Date.now {
            
            performSegue(withIdentifier: "profileID", sender: self)
//            guard let proVC = self.tabBarController?.viewControllers?[2] else { return  }
//            let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileId") as! ProfileVC
//
//            self.navigationController?.show(proVC, sender: nil)
        }else{
            print("Select service and Date")
        }
    }
    
    
    @IBAction func onClickLogOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.navigationController?.popViewController(animated: true)
    }
//    synchronizeTitleAndSelectedItem()
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "profileID" {
            let profileVC = segue.destination as! ProfileVC
            let service = Service(name: txtBox.text!, date: datePicker.date, price: 100)
            profileVC.service = service
            
        }
        // Pass the selected object to the new view controller.
    }
    

}
extension HomeVC : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        services.count
    }
    
    
}
extension HomeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return services[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtBox.text = services[row]
        self.dropDown.isHidden = true
    }
}
extension HomeVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
            
        }
    }
}

