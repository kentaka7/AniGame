//
//  ProfileViewController.swift
//  SampleFirebase
//
//  Created by takakura naohiro on 2017/05/18.
//  Copyright © 2017年 GeoMagnet. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import SVProgressHUD

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    var storageRef:AnyObject?
    var uploadImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference(forURL: self.getBucket())
        
        // Do any additional setup after loading the view.
        self.updateProfileImageView()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("再表示")
        self.read()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageWithLibrary(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(controller, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage = image
            profileImageView.image = uploadImage
            self.create(uploadImage: self.resize(image: uploadImage,scale: 0.1))
            picker.dismiss(animated: true, completion: nil)
        } else{
            print("Something went wrong")
        }
    }
    
    func resize(image: UIImage, scale:CGFloat) -> UIImage {
        let imageRef: CGImage = image.cgImage!
        let sourceWidth:CGFloat = CGFloat(imageRef.width)
        let sourceHeight: CGFloat = CGFloat(imageRef.height)
        let width:Int  = Int(sourceWidth * scale)
        let height:Int = Int(sourceHeight * scale)
        
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }

    func countPhoto() -> String {
        let ud = UserDefaults.standard
        let count = ud.object(forKey: "count") as! Int
        ud.set(count + 1, forKey: "count")
        return String(count) + ".jpg"
    }

    
    @IBAction func didSelectLogout() {
        self.logout()
    }
    
    func presentActionSheet() {
        let alert = UIAlertController(title: "写真を選択", message: "どちらから選択しますか?", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "ライブラリ", style: .default) { (action) in
            self.presentPhotoLibrary()
        }
        
        let camera = UIAlertAction(title: "カメラ", style: .default) { (action) in
            self.presentCamera()
        }
        
        alert.addAction(library)
        alert.addAction(camera)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func create(uploadImage image: UIImage) {
        if let uploadImage = UIImagePNGRepresentation(image) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef?.child("images/\((Auth.auth().currentUser?.uid)!)/test03.jpg").putData(uploadImage, metadata: metadata) { (data, error) in
                if error != nil {
                    print("アップロードエラー")
                    print("\(String(describing: error?.localizedDescription))")
                }else {
                    
                }
            }
        }
    }
    
    func read() {
        let gsReference = Storage.storage().reference(forURL: self.getBucket())
        gsReference.child("images/\((Auth.auth().currentUser?.uid)!)/test03.jpg").getData(maxSize: 1 * 1028 * 1028) { (data, error) in
            if error != nil {
                print("ダウンロードエラー！")
                print("\(error?.localizedDescription)")
            }else {
                self.uploadImage = UIImage(data: data!)
                self.profileImageView.image = self.uploadImage
            }
        }
    }
    
    func changeEmail() {
        
    }
    
    func changePassword() {
        
    }
    
    func exitFromService() {
        
    }
    
    func logout() {
        do {
            //do-try-catchの中で、FIRAuth.auth()?.signOut()を呼ぶだけで、ログアウトが完了
            try Auth.auth().signOut()
            
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav")
            self.present(storyboard, animated: true, completion: nil)
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    
    func getBucket() -> String{
        let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        let url:String = "gs://\(dictionary?.object(forKey: "STORAGE_BUCKET") as! String)/"
        return url;
    }
    
    func updateProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width/2
        profileImageView.layer.masksToBounds = true
    }
}


