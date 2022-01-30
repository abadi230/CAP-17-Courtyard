//
//  ChatVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 20/12/2021.
//

import UIKit
import Firebase
// TODO: make private chat wiht customer
class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCellID", for: indexPath) as! ChatCell
        
        return cell
    }
    
// MARK: PROPERTIES
    
    @IBOutlet weak var msgTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "chatCellID")
        getMsg()
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        
    }
    

    func getMsg(){
        
    }

}


class message {
    var sender = ""
    var msg = ""
}
