//
//  ViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import TransitionButton
import SimpleAnimation
import Motion
import RAMAnimatedTabBarController

class LoginVC: UIViewController, UITextFieldDelegate, GroupsVCDelegate {
    
    @IBOutlet weak var emailaddressTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: TransitionButton!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var lockIcon: UIImageView!
    
    private var groupsVCTabBarController: RAMAnimatedTabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailaddressTxtField.delegate = self
        passwordTxtField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func loginTransitionBtnPressed(_ sender: Any) {
        if let email = emailaddressTxtField.text, let password = passwordTxtField.text {
            loginBtn.startAnimation()
            AuthService.instance.loginUser(withEmail: email, andPassword: password, loginComplete: { (success, loginError) in
                if success {
                    self.loginBtn.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                        if let groupsVCTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? RAMAnimatedTabBarController {
                            self.groupsVCTabBarController = groupsVCTabBarController
                            groupsVCTabBarController.modalTransitionStyle = .crossDissolve
                            if let groupsVC = groupsVCTabBarController.viewControllers?.first as? GroupsVC {
                                groupsVC.delegate = self
                            }
                            self.present(groupsVCTabBarController, animated: true, completion: nil)
                        }
                    })
                } else {
                    print(String(describing: loginError?.localizedDescription))
                    self.loginBtn.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 0.75, completion: nil)
                }
            })
        }
        
        
    }
    
    @IBAction func noAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp1", sender: self)
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
    }
    
    //User and Lock image animations in textfield
    @IBAction func emailaddressTxtFieldTapped(_ sender: Any) {
        userIcon.hop()
    }
    @IBAction func passwordTxtFieldTapped(_ sender: Any) {
        lockIcon.hop()
    }
    
    func onLogoutPressed() {
        emailaddressTxtField.text = nil
        passwordTxtField.text = nil
        groupsVCTabBarController?.dismiss(animated: false, completion: nil)
    }

}

