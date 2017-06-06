//
//  LoginViewController.swift
//  SampleFirebase
//
//  Created by takakura naohiro on 2017/05/18.
//  Copyright © 2017年 GeoMagnet. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート
//import FontAwesome_swift

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        let myColor : UIColor = UIColor.lightGray
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        
        emailTextField.layer.borderColor = myColor.cgColor
        passwordTextField.layer.borderColor = myColor.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //ログインボタン
    @IBAction func didRegisterUser() {
        login()
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //ログインのためのメソッド
    func login() {
            //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            //signInWithEmailでログイン
            //第一引数にEmail、第二引数にパスワードを取ります
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                //エラーがないことを確認
                if error == nil {
                    if let loginUser = user {
                        // バリデーションが完了しているか確認。完了ならそのままログイン
                        if self.checkUserValidate(user: loginUser) {
                            // 完了済みなら、ListViewControllerに遷移
                            print(Auth.auth().currentUser)
                            self.transitionToView()
                        }else {
                            // 完了していない場合は、アラートを表示
                            self.presentValidateAlert()
                        }
                    }
                }else {
                    print("error...\(error?.localizedDescription)")
                }
            })
    }
    // ログインした際に、バリデーションが完了しているか返す
    func checkUserValidate(user: User)  -> Bool {
        return user.isEmailVerified
    }
    // メールのバリデーションが完了していない場合のアラートを表示
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        self.performSegue(withIdentifier: "toVC", sender: self)
    }
}
