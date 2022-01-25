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
    var service: Service?
    var price: String = "0"
    // TODO: adapt pull down Button and Pop Up Button
    @IBOutlet weak var welcomLbl : UILabel!
    @IBOutlet weak var txtBox: UITextField!
//    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dropDown = UIPickerView()
    @IBOutlet weak var priceLbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
//        datePicker.date = Date.now

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        priceLbl.text = price
        fetchData()
        configDatePicker()
        dropDown.delegate = self
        dropDown.dataSource = self
        txtBox.inputView = dropDown
        
    }
    func fetchData(){
        //from DB
        user.getDataClosure(completion: { user  in
            
            self.welcomLbl.text = "Welcome \(user.name!)"
        })
    }

    
    func configDatePicker(){
        let action = UIAction{ [self] _ in
            print(self.datePicker.date)
            if self.txtBox.text != nil{
                
                service = user.setService(name: txtBox.text!, date: datePicker.date)
                price = "SAR \(service!.price)"
                priceLbl.text = price
            }else{
                print("Select Service Please")
            }
        }
        datePicker.addAction(action, for: .valueChanged)
    }
        
   
    @IBAction func onClickBook(_ sender: UIButton) {
        if txtBox.text != "" && datePicker.date != Date.now {
            
//            guard let proVC = self.tabBarController?.viewControllers?[2] else { return  }
//            let tab = storyboard?.instantiateViewController(withIdentifier: "tabID")
//            let vc = tab?.tabBarController?.viewControllers![2] as! ProfileVC
//            vc.service = service
//            present(vc, animated: true, completion: nil)

             
            performSegue(withIdentifier: "profileID", sender: self)
            /* send data to tab bar then send it again to VC */
            
            
        }else{
            print("Select service and Date")
        }
    }
    
    
    @IBAction func onClickLogOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
//    synchronizeTitleAndSelectedItem()
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "profileID" {
            let profileVC = segue.destination as! ProfileVC
            //MARK: trying to display tabBar 
            self.definesPresentationContext = true
            profileVC.modalPresentationStyle = .overCurrentContext
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
//        self.txtBox.endEditing(true)
//        txtBox.text = ""
        return services[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtBox.text = services[row]
        self.txtBox.resignFirstResponder()

//        self.dropDown.isHidden = true
    }
}
//extension HomeVC: UITextFieldDelegate{
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.txtBox {
//            self.dropDown.isHidden = false
//            textField.endEditing(true)
//
//        }
//    }
//}
