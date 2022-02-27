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
//import SwiftUI

class HomeVC: UIViewController {

    let db = Firestore.firestore()
    var user = User()
    var lang = "en"
    var services : [String] = ["Courtyard Cleaning", "Roof of House Cleaning", "Stairs Cleaning"]
    var service: Service?
    var price: String = "0"
    var time = "8:00"

    var servicesDate = [Timestamp]()
    var dateSelected = Date()
    
    @IBOutlet weak var welcomLbl : UILabel!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dropDown = UIPickerView()
    @IBOutlet weak var seqmentOutlet: UISegmentedControl!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        getServicesDate()
        checkDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getServicesDate()
        priceLbl.text = price
        fetchData()
//        configDatePicker()
        dropDown.delegate = self
        dropDown.dataSource = self
        txtBox.inputView = dropDown
        
    }

    @IBAction func timeSegment(_ sender: UISegmentedControl) {
        let seq = sender.selectedSegmentIndex

        switch seq{
        case 0:
            time = "8:00"
        case 1:
            time = "11:30"
        case 2:
            time = "15:00"
        case 3:
            time = "18:30"
        default:
            time = "8:00"
        }
//        getSelectedDate(date: datePicker.date, time: time)
    }
   
    @IBAction func onClickBook(_ sender: UIButton) {
        getSelectedDate(date: datePicker.date, time: time)
        if seqmentOutlet.selectedSegmentIndex < 0{
            showAlert("Sorry this time is unavailable. please select another time")
            return
        }
        if txtBox.text != "" && datePicker.date > Date.now {
            print("onClickBook", dateSelected)
            service = user.setService(name: txtBox.text!, date: dateSelected)
            
            performSegue(withIdentifier: "profileID", sender: self)
        }else{
            
            showAlert(NSLocalizedString("Please select Service and Date", comment: ""))
        }
        
        
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
        for i in 0...3{
            seqmentOutlet.setEnabled(true, forSegmentAt: i)
        }
        
        getSelectedDate(date: sender.date, time: time)
        
        
//        getSelectedDate(date: sender.date, time: time)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickLogOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        let vc = storyboard?.instantiateViewController(withIdentifier: "logInId") as! LogIn
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func fetchData(){
        //from DB
        user.getDataClosure(completion: { user  in
            let welcome = NSLocalizedString("Welcome", comment: "")
            self.welcomLbl.text = "\(welcome) \(user.name!)"
        })
    }

    func getServicesDate(){
        db.collection("Service").getDocuments { [self] snapshot, err in
            guard let docs = snapshot?.documents else {return}
            servicesDate = docs.map{$0["date"] as! Timestamp}
            
        }
    }
    func getSelectedDate(date: Date, time: String){
        
        // convert string to date
        let dateFormatter = DateFormatter()
        let dateStr = date.formatted(date: .abbreviated, time: .omitted)
        let dateAndTimeStr = "\(dateStr), \(time)"
        dateFormatter.dateFormat = "MMM dd, yyy, HH:mm"
       
        if let d = dateFormatter.date(from: dateAndTimeStr){
            dateSelected = d
            checkDate()
        }
        
    }
    func checkDate(){
        // check availabelaty
        for d in servicesDate{
            // convert Timestamp to Date then to string
            let dateFormatted = d.dateValue().formatted(date: .abbreviated, time: .shortened)
            
            // convert Timestamp to Date without Time
            let date = d.dateValue().formatted(date: .abbreviated, time: .omitted)
            let datePickerStr = datePicker.date.formatted(date: .abbreviated, time: .omitted)
            // check date without time
            if date == datePickerStr{
                
                if dateFormatted.contains("8:00 AM"){
                    seqmentOutlet.setEnabled(false, forSegmentAt: 0)
                }
                if dateFormatted.contains("11:30 AM"){
                    seqmentOutlet.setEnabled(false, forSegmentAt: 1)
                }
                if dateFormatted.contains("3:00 PM"){
                    seqmentOutlet.setEnabled(false, forSegmentAt: 2)
                }
                if dateFormatted.contains("6:30 PM"){
                    seqmentOutlet.setEnabled(false, forSegmentAt: 3)
                }
            }
            
        }
        
        if seqmentOutlet.isEnabledForSegment(at: 0) == false &&
            seqmentOutlet.isEnabledForSegment(at: 1) == false &&
            seqmentOutlet.isEnabledForSegment(at: 2) == false &&
            seqmentOutlet.isEnabledForSegment(at: 3) == false{
            showAlert("Sorry this Date is unavailable. please select another Date")
        }
    }
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "profileID" {
            let profileVC = segue.destination as! ProfileVC
            //MARK: trying to display tabBar without navigationController
            self.definesPresentationContext = true
            profileVC.modalPresentationStyle = .overCurrentContext
            profileVC.service = service
            
        }
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

        return  NSLocalizedString(services[row], comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtBox.text =  NSLocalizedString(services[row], comment: "")
        self.txtBox.resignFirstResponder()
//
//        let date = getDate(date: datePicker.date, time: time)
//
//        service = user.setService(name: txtBox.text!, date: date)
        let servicePrice = user.getServicePrice(serviceTitle: txtBox.text!)
        let currency = NSLocalizedString("SAR", comment: "")
        price = "\(currency) \(servicePrice)"
        priceLbl.text = price


    }
}

