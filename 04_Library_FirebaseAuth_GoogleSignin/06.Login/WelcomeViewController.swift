//  WelcomeViewController.swift
//  06.Login
//
//  Created by YHChoi on 2022/07/18.
//


import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet var lblWelcome: UILabel!
    @IBOutlet var btnChangePassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let email = Auth.auth().currentUser?.email ?? "고객"
        lblWelcome.text = """
        환영합니다.
        \(email)님
        """
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        btnChangePassword.isHidden = !isEmailSignIn
    }
    
    @IBAction func tabBtnChangePassword(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
    @IBAction func tabBtnLogout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error: singout \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func tabBtnDeleteUser(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "탈퇴", message: "탈퇴를 할 경우, 모든 데이터가 소멸됩니다.", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            Auth.auth().currentUser?.delete()
            self.deleteUserDone()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(deleteAlert, animated: true)
    }
    
    private func deleteUserDone() {
        let deleteDoneAlert = UIAlertController(title: "탈퇴가 완료되었습니다.", message: nil, preferredStyle: .alert)
        deleteDoneAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(deleteDoneAlert, animated: true)
        
    }
}
