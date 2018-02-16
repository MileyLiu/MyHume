//
//  SigninViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
class SigninViewController: UIViewController ,UITextFieldDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate{
    
    
    @IBOutlet weak var buttonsView: UIView!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    
    var handle :AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goButton.layer.cornerRadius = 20
        self.goButton.layer.masksToBounds = true
        
        self.facebookButton.layer.cornerRadius = 20
        self.twitterButton.layer.cornerRadius = 20
        self.googleButton.layer.cornerRadius = 20
        self.phoneButton.layer.cornerRadius = 20
        
        self.facebookButton.layer.masksToBounds = true
        self.twitterButton.layer.masksToBounds = true
        self.googleButton.layer.masksToBounds = true
        self.phoneButton.layer.masksToBounds = true
        
        self.emailTextfield.layer.cornerRadius = 20
        self.emailTextfield.layer.masksToBounds = true
        self.passwordTextField.layer.cornerRadius = 20
        self.passwordTextField.layer.masksToBounds = true
        
        self.emailTextfield.configKeyboard()
        self.passwordTextField.configKeyboard()
        
        //google
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //facebook
        var fbloginButton = FBSDKLoginButton()
        fbloginButton.delegate  = self
        
        fbloginButton.frame = self.facebookButton.frame
        fbloginButton.alpha = 0.05
        fbloginButton.loginBehavior = .browser
        
        fbloginButton.readPermissions = ["public_profile","email"]
        
        self.facebookButton.addSubview(fbloginButton)
        
        //twiter
        
        let twlogInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                let creidential = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                
                
                Auth.auth().signIn(with: creidential, completion: { (user, error) in
                    if let error = error{
                        print("twitter signin error\(error)")
                        return
                    }
                    print("session?.authToken:\(session?.authToken),user?.refreshToken:\(user?.refreshToken)")
                    self.defaults.set(user?.refreshToken, forKey: "token")
                    self.defaults.set(user?.displayName, forKey: "displayName")
                    
                    print("User is sign in")
                    
                    let sucessAlert = getSimpleAlert(titleString:LanguageHelper.getString(key: "LOGIN_T"), messgaeLocizeString: LanguageHelper.getString(key: "LOGIN_MSG"))
                    
                    
                    self.present(sucessAlert, animated: true, completion: {
                        //                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    
                })
                
                
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        twlogInButton.alpha = 0.05
        
        self.twitterButton.addSubview(twlogInButton)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil {
                print("existing user")
                
            }else {
                print("not signin")

            }
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if (error) != nil{
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                return
            }
            
            self.defaults.set(result.token, forKey: "token")
            self.defaults.set(user?.displayName, forKey: "displayName")
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func googleSignin(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        
        let sucessAlert = getSimpleAlert(titleString:LanguageHelper.getString(key: "LOGIN_T"), messgaeLocizeString: LanguageHelper.getString(key: "LOGIN_MSG"))
        
        
        self.present(sucessAlert, animated: true, completion: {
            //                        self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        
        if (self.emailTextfield.text?.isEmpty)! {
            let alert  = getSimpleAlert(titleString: fillErrorString, messgaeLocizeString: fillErrorString)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if (self.emailTextfield.text?.isEmpty)! {
            let alert  = getSimpleAlert(titleString: "ERROR", messgaeLocizeString: fillErrorString)
            self.present(alert, animated: true, completion: nil)
            print("fill password")
        }
        else{
            Auth.auth().signIn(withEmail:self.emailTextfield.text!, password: self.passwordTextField.text!) { (user, error) in
                if let error = error{
                    print("emailauth error\(error.localizedDescription)")
                    
                    let alert  = getSimpleAlert(titleString: "ERROR", messgaeLocizeString:error.localizedDescription )
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                        
                        if let error = error{
                            
                            print("emailauth error2\(error.localizedDescription)")
                            
                            let alert  = getSimpleAlert(titleString: "ERROR", messgaeLocizeString:error.localizedDescription )
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else{
                            self.defaults.set(user?.refreshToken, forKey: "token")
                            self.defaults.set(user?.displayName, forKey: "displayName")
                            print("\(user?.displayName),\(user?.refreshToken)")
                            
                            self.loginSucess()
                        }
                        
                    })
                    
                    return
                }
                    
                else{
                    
                    
                    self.defaults.set(user?.refreshToken, forKey: "token")
                    self.defaults.set(user?.displayName, forKey: "displayName")
                    print("\(user?.displayName),\(user?.refreshToken)")
                    self.loginSucess()
                }
            }
        }
        
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
    }
    
    @IBAction func twitterLogin(_ sender: Any) {
    }
    @IBAction func phoneLogin(_ sender: Any) {
        
    }
    
    
    func loginSucess(){
        
        let sucessAlert = getSimpleAlert(titleString:LanguageHelper.getString(key: "LOGIN_T"), messgaeLocizeString: LanguageHelper.getString(key: "LOGIN_MSG"))
        self.present(sucessAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //delegates
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
