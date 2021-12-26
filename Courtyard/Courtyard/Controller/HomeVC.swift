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
    
    
    

    var services : [String] = ["Courtyard", "Roof of House", "Stairs"]

    // TODO: adapt pull down Button and Pop Up Button
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
//        datePicker.date = Date.now
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // when user chois service and date move to add adderess then add order
        configDatePicker()
//        sendToDB()
        
    }
    
    func configDatePicker(){
        let action = UIAction{ _ in
            print(self.datePicker.date)
            
        }
        datePicker.addAction(action, for: .valueChanged)
    }
    func sendToDB(){
        
        
        let order1 = Order(userId: "aa", serviceId: "sss", date: Date(), total: 0.5)
        let order2 = Order(userId: "bb", serviceId: "xxx", date: Date(), total: 0.78)

        let testObj = CodeTest(name: "Boss", age: 23, orders: [order1, order2])

        let dbStore = Firestore.firestore()

        // Store to DB
        let x = try? dbStore.collection("test").addDocument(from: testObj)
        print(x as Any)

//        // Fetch from DB
//        dbStore.collection("test").addSnapshotListener { snapshot, error in
//
//            for doc in snapshot!.documents {
////                let testObj = try! doc.data(as: CodeTest.self)
//                print (testObj)
//            }
//        }
        
        
        
        
        
    }
        
//        salim.name = "Salim"
//        salim.mobile = 055555552
//        salim.addresses?.append(Address(street: "quba", buildingNo: 29, zip: 9999, additionalNo: 3333, district: "Rabwah"))
//        salim.services = Service(name: "cleaning Vila's Courtyard", price: 50)
//        salim.orders?.append(Order(userId: self, serviceId: self.services))
   // }
    @IBAction func onClickBook(_ sender: UIButton) {
        if txtBox.text != "" && datePicker.date != Date.now {
            
            performSegue(withIdentifier: "profileID", sender: self)
        }else{
            print("Select service and Date")
        }
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

