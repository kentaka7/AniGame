//
//  HomeViewController.swift
//  AniGame
//
//  Created by takakura naohiro on 2018/10/19.
//  Copyright © 2018年 GeoMagnet. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auth check
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let storyboard: UIStoryboard = self.storyboard!
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let second = storyboard.instantiateViewController(withIdentifier: "AuthView")
        self.present(second, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
