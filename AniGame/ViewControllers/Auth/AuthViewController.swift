//
//  AuthViewController.swift
//  AniGame
//
//  Created by takakura naohiro on 2018/10/19.
//  Copyright © 2018年 GeoMagnet. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート

class AuthViewController: UIViewController {
    
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapOtherLogin(_ sender: Any) {
        print("----------------------")
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        //let storyboard: UIStoryboard = self.storyboard!
        let viewController  = storyboard.instantiateViewController(withIdentifier: "SignUpView") as? SignupViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

}
