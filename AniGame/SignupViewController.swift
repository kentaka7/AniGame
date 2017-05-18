//
//  SignupViewController.swift
//  SampleFirebase
//
//  Created by takakura naohiro on 2017/05/18.
//  Copyright © 2017年 GeoMagnet. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート
import FBSDKLoginKit
import TwitterKit
//import FontAwesome_swift

class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField
    @IBOutlet var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("まいにち１時間はプログラミングをする")
        
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
        
        //debug
        facebookButton.setTitle("ログイン", for: .normal)

        //self.layoutFacebookButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //ログインしていれば、遷移
        //FIRAuthがユーザー認証のためのフレーム
        //checkUserVerifyでチェックして、ログイン済みなら画面遷移
        if self.checkUserVerify() {
            self.performSegue(withIdentifier: "toView", sender: self)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //サインアップボタン
    @IBAction func willSignup() {
        //サインアップのための関数
        signup()
    }
    //ログイン画面への遷移ボタン
    @IBAction func willTransitionToLogin() {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @IBAction func willLoginWithFacebook() {
        self.loginWithFacebook()
    }
    
    
    //Signupのためのメソッド
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email    = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        //第一引数にEmail、第二引数にパスワード
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            //エラーなしなら、認証完了
            if error == nil{
                // メールのバリデーションを行う
                user?.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                        self.willTransitionToLogin()
                    }else {
                        print("\(error?.localizedDescription)")
                    }
                })
            }else {
                
                print("\(error?.localizedDescription)")
            }
        })
    }
    
    
    // Facebookでユーザー認証するためのメソッド
    func loginWithFacebook() {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (facebookResult, facebookError) in
            if facebookError != nil {
                print(facebookError?.localizedDescription)
            }else if (facebookResult?.isCancelled)! {
                print("facebook login was cancelled")
            }else {
                print("else is processed")
                let credial: AuthCredential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print(FBSDKAccessToken.current().tokenString)
                print("credial...\(credial)")
                self.firebaseLoginWithCredial(credial: credial)
            }
        }
    }
    
    //twitterでログイン
    @IBAction func loginWithTwitter(sender: TWTRLogInButton) {
        sender.logInCompletion = { (session: TWTRSession?, err: NSError?) in
            if let session = session {
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let err = error {
                        print(err)
                        return
                    }
                })
            }
        } as! TWTRLogInCompletion
    }
    
    func firebaseLoginWithCredial(credial: AuthCredential) {
        if Auth.auth().currentUser != nil {
            print("current user is not nil")
            Auth.auth().currentUser?.link(with: credial, completion: { (user, error) in
                if error != nil {
                    debugPrint("error happens")
                    debugPrint("error reason...\(error)")
                }else {
                    debugPrint("sign in with credential")
                    Auth.auth().signIn(with: credial, completion: { (user, error) in
                        if error != nil {
                            debugPrint(error?.localizedDescription)
                        }else {
                            debugPrint("Logged in")
                        }
                    })
                }
            })
        }else {
            debugPrint("current user is nil")
            Auth.auth().signIn(with: credial, completion: { (user, error) in
                if error != nil {
                    debugPrint(error)
                }else {
                    debugPrint("Logged in")
                }
            })
        }
    }
    
    // ログイン済みかどうかと、メールのバリデーションが完了しているか確認
    func checkUserVerify()  -> Bool {
        
        guard let user = Auth.auth().currentUser else { return false }
        debugPrint("user:\(user.displayName) \(user.email)")
        
        return user.isEmailVerified
    }
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
