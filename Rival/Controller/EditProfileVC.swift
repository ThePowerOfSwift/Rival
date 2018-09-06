//
//  EditProfileVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-03-07.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import IHKeyboardAvoiding

class EditProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var lowerSV: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardAvoiding.avoidingView = self.lowerSV
        emailTxtField.text = Auth.auth().currentUser?.email
        DataService.instance.getUserImage(uid: (Auth.auth().currentUser?.uid)!) { (returnedUrl) in
            if returnedUrl == "none" {
                let image = UIImage(named: "defaultProfilePic")
                self.profileImage.image = image
            } else {
                let imageUrl = URL(string: returnedUrl)
                self.profileImage.kf.setImage(with: imageUrl)
            }
        }
    }
    
    @IBAction func changeProfilePhotoPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        //let credential = EmailAuthProvider.credential(withEmail: <#T##String#>, password: <#T##String#>)
        
        if selectedImage == nil && emailTxtField.text != Auth.auth().currentUser?.email! {
            Auth.auth().currentUser?.updateEmail(to: emailTxtField.text!, completion: { (error) in
                if let error = error {
                    self.errorLabel.text = String(describing: error.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else if selectedImage != nil && emailTxtField.text == Auth.auth().currentUser?.email! {
            if let profileImg = selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                StorageService.instance.uploadProfileImage(uid: (Auth.auth().currentUser?.uid)!, data: imageData)
                dismiss(animated: true, completion: nil)
            }
        } else {
            if let profileImg = selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                StorageService.instance.uploadProfileImage(uid: (Auth.auth().currentUser?.uid)!, data: imageData)
            }
            Auth.auth().currentUser?.updateEmail(to: emailTxtField.text!, completion: { (error) in
                if let error = error {
                    print(String(describing: error.localizedDescription))
                    self.errorLabel.text = String(describing: error.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
