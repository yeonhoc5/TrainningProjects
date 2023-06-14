//
//  ViewController.swift
//  06.Login
//
//  Created by YHChoi on 2022/07/18.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet var btnEmailPassword: UIButton!
    @IBOutlet var btnGoogle: GIDSignInButton!
    @IBOutlet var btnApple: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func btnConfigure() {
        btnEmailPassword.layer.borderColor = CGColor(gray: 1, alpha: 1)
        btnEmailPassword.layer.borderWidth = 1
        btnEmailPassword.layer.cornerRadius = btnEmailPassword.frame.height / 2
        btnGoogle.layer.borderColor = CGColor(gray: 1, alpha: 1)
        btnGoogle.layer.borderWidth = 1
        btnGoogle.layer.cornerRadius = btnGoogle.frame.height / 2
        btnApple.layer.borderColor = CGColor(gray: 1, alpha: 1)
        btnApple.layer.borderWidth = 1
        btnApple.layer.cornerRadius = btnApple.frame.height / 2
    }
    
    @IBAction func tabBtnGoogleLogin(_ sender: UIButton) {
        configureLogIn()
    }
    
    func configureLogIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign in error: \(error)")
                    return
                } else {
                    print("User is signed with Firebase & Google")
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let welcomViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
                    self.navigationController?.pushViewController(welcomViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func tabBtnAppleLogin(_ sender: UIButton) {
    }
    
}

