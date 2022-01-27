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
    var lang = "en"
    var services : [String] = ["Courtyard", "Roof of House", "Stairs"]
    var service: Service?
    var price: String = "0"
    
    var tuggleBtn = false
    
    // TODO: adapt pull down Button and Pop Up Button
    @IBOutlet weak var welcomLbl : UILabel!
    @IBOutlet weak var txtBox: UITextField!
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

    @IBAction func onClickLanguageBtn(_ sender: UIBarButtonItem) {
        
        tuggleBtn = !tuggleBtn
        sender.title = tuggleBtn ? "en" : "ar"
        lang = !tuggleBtn ? "en" : "ar"
    }
    
    func fetchData(){
        //from DB
        user.getDataClosure(completion: { user  in
            let welcome = NSLocalizedString("Welcome", comment: "")
            self.welcomLbl.text = "\(welcome) \(user.name!)"
        })
    }

    
    func configDatePicker(){
        let action = UIAction{ [self] _ in
            print(self.datePicker.date)
            if self.txtBox.text != nil{
                
                service = user.setService(name: txtBox.text!, date: datePicker.date)
                let currency = "SAR".LocalizableLanguage(name: lang)
                price = "\(currency) \(service!.price)"
                priceLbl.text = price
            }
        }
        datePicker.addAction(action, for: .valueChanged)
    }
        
   
    @IBAction func onClickBook(_ sender: UIButton) {
        if txtBox.text != "" && datePicker.date > Date.now {
            
            performSegue(withIdentifier: "profileID", sender: self)
        }else{
            
            showAlert("Please select Service and Date".LocalizableLanguage(name: lang))
        }
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickLogOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        let vc = storyboard?.instantiateViewController(withIdentifier: "logInId") as! LogIn
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
//    synchronizeTitleAndSelectedItem()
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK".LocalizableLanguage(name: lang), style: .default)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
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
// MARK: Picker
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

        return services[row].LocalizableLanguage(name: lang)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtBox.text = services[row].LocalizableLanguage(name: lang)
        self.txtBox.resignFirstResponder()


    }
}

