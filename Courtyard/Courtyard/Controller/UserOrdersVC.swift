//
//  UserOrdersVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 28/01/2022.
//

import UIKit

class UserOrdersVC: UIViewController {

    
    @IBOutlet weak var userOrdersTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension UserOrdersVC: UITableViewDelegate{
    
}
extension UserOrdersVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userOrdersTV.dequeueReusableCell(withIdentifier: "UserOrdersCell", for: indexPath) as! UserOrdersCell
        
        return cell
    }
    
    
}
