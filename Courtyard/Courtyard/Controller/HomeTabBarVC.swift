//
//  HomeTabBarVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 30/12/2021.
//

import UIKit

class HomeTabBarVC: UITabBarController {
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(user.name)
        let profileVC = viewControllers?[2] as! ProfileVC
        profileVC.user = user
        print("User is: \(user.name)")
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
