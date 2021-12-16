//
//  HomeVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 15/12/2021.
//

import UIKit

class HomeVC: UIViewController {
    
    var services : [String] = ["Courtyard", "Roof of House", "Stairs"]

    // TODO: adapt pull down Button and Pop Up Button
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickPersonsService(_ sender: UIButton) {
        print(sender.menu ?? "unable to print menu")
    }
    
//    synchronizeTitleAndSelectedItem()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
