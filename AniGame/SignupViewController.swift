//
//  SignupViewController.swift
//  SampleFirebase
//
//  Created by takakura naohiro on 2017/05/18.
//  Copyright © 2017年 GeoMagnet. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import TwitterKit
import SVProgressHUD


class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkUserVerify() == true {
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
    
    //twitterでログイン
    @IBAction func loginTwitter(_ sender: Any) {
/*
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
*/
/*
        if let _ = Auth.auth().currentUser { //Twitter以外でログインされている可能性大
            self.OkAlert(_tile: "Link Twitter", _message: "現在ログインしているユーザに対し、Twitterでもログイン可能にしますか？", _target: self, OKCallBack: {
                Twitter.sharedInstance().logIn(completion: { (session:TWTRSession?, error:Error?) in
                    if(!(error != nil)){
                        let credential = TwitterAuthProvider.credential(withToken: session!.authToken, secret: session!.authTokenSecret)
                        self.linkToCurrentUser(credential: credential)
                    }
                })
            })
        }else{
            Twitter.sharedInstance().logIn(completion: { (session:TWTRSession?, error:Error?) in
                if (!(error != nil)){
                    let credential = TwitterAuthProvider.credential(withToken: session!.authToken, secret: session!.authTokenSecret)
                    self.signIn(credential: credential)
                }
            })
        }
*/
    }

    //FaceBookでログイン
    @IBAction func loginByFacebookID(sender: AnyObject) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        //そのまま認証
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: { (result:FBSDKLoginManagerLoginResult?, error:Error?) in
            if (!(result?.isCancelled)!){
                let credential = FacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                SVProgressHUD.show(withStatus: "認証中")
                self.signIn(credential: credential)
                
            }
        })

        
/*
        if let currentUser = Auth.auth().currentUser { //Facebook以外でログインされている可能性大
            print("currentUser:\(currentUser)")
            self.OkAlert(_tile: "Link Facebook", _message: "現在ログインしているユーザに対し、Facebookでもログイン可能にしますか？", _target: self, OKCallBack: {
                fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: { (result:FBSDKLoginManagerLoginResult?, error:Error?) in
                    let credential:AuthCredential = FacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                    self.linkToCurrentUser(credential: credential)
                })
            })
        }else{
            //そのまま認証
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: { (result:FBSDKLoginManagerLoginResult?, error:Error?) in
                if (!(result?.isCancelled)!){
                    let credential = FacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                    self.signIn(credential: credential)
                }
            })
        }
*/
/*
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if (error != nil) {
                // エラーが発生した場合
                print("Process error")
            } else if (result?.isCancelled)! {
                // ログインをキャンセルした場合
                print("Cancelled")
            } else {
                // その他
                let credial: AuthCredential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print(FBSDKAccessToken.current().tokenString)
                print("credial...\(credial)")
                self.firebaseLoginWithCredial(credial: credial)
            }
        }
 */
    }
    // MARK: - Link/signIn
    func linkToCurrentUser(credential:AuthCredential){
        Auth.auth().currentUser?.link(with: credential, completion: { (user:User?, error:Error?) in
            print("linkToCurrentUser displayName: \(user)")
        })
    }
    
    func signIn(credential:AuthCredential){
        Auth.auth().signIn(with: credential, completion: { (user:User?, error:Error?) in
            print("FaceBookでサインイン displayName: %@ email:%@",user?.displayName,user?.email)
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "toView", sender: self)
        })
    }
    
    // alert
    private func OkAlert(_tile:String, _message:String, _target:UIViewController, OKCallBack:@escaping () -> Void) -> Void{
        let alertController = UIAlertController(
            title: _tile,
            message: _message,
            preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) {
            action in
            // ok code
            OKCallBack()
        }
        let actionCancel = UIAlertAction(title: "CANCEL", style: .cancel) {
            action in
            // cancel code
        }
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        
        _target.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //Signupのためのメソッド
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email    = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        
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
    
    
/*
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
*/
    
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
        return user.isEmailVerified
    }
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
