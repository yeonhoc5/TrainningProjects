//
//  EmailViewController.swift
//  06.Login
//
//  Created by YHChoi on 2022/07/18.
//

import UIKit
import FirebaseAuth

class EmailViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var lblErrorMessage: UILabel!
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 20
        self.navigationItem.title = "이메일 / 비밀번호로 로그인"
        self.tfEmail.becomeFirstResponder()
        btnNext.isEnabled = false
        btnNext.titleLabel?.textColor = .black
        tfEmail.delegate = self
        tfPassword.delegate = self
        checkTfValidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func tabBtnNext(_ sender: UIButton) {
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007:
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.lblErrorMessage.text = error.localizedDescription
                }
            } else {
                self.showMainViewViewController()
            }
        }
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
             
            if let error = error {
                self.lblErrorMessage.text = error.localizedDescription
            } else {
                self.showMainViewViewController()
            }
            
        }
    }
    
    func showMainViewViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
//        viewController.modalPresentationStyle = .fullScreen
        navigationController?.show(viewController, sender: nil)
        
    }
    
    
    func checkTfValidate() {
        self.tfEmail.addTarget(self, action: #selector(validateBtnNext), for: .editingChanged)
        self.tfPassword.addTarget(self, action: #selector(validateBtnNext), for: .editingChanged)
    }
    
    @objc func validateBtnNext() {
//        if tfEmail.text != "" && tfPassword.text != "" {
//            btnNext.isEnabled = true
//        }
        let emailText = tfEmail.text == ""
        let passwordText = tfPassword.text  == ""
        btnNext.isEnabled = !emailText && !passwordText
    }
    
}

extension EmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
