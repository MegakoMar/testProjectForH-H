//
//  secondViewController.swift
//  testProjectForHH
//
//  Created by Рома Комаров on 26/08/2019.
//  Copyright © 2019 Рома Комаров. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var forgotOfPassword: UIButton!
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        if email.isValidEmail() && password.isValidPassword() {
            errorLabel.text = ""
            
            AF.request("http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=ec2f966be112bd5e75ae23878e7457da").responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Ошибка при запросе данных\(String(describing: response.result.error))")
                    return
                }
                
                guard let data = response.data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(CurrentWeather.self, from: data)
                    self.temp = Int(weatherResponse.main.temp - 273)
                    self.city = weatherResponse.name
                    self.date = Date(timeIntervalSince1970: TimeInterval(weatherResponse.dt))
                    print("self.temp \(self.temp)")
                    print("self.city \(self.city)")
                    print("self.date \(self.date)")
                    
                    let alertController = UIAlertController(title: "Погода", message: "На \(self.date) в городе \(self.city) температура \(self.temp) C", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    self.present(alertController, animated: true)
                    
                }
                catch let error {
                    print("error\(error)")
                }
            }
        } else {
            errorLabel.text = "Введен неверный Email или Пароль"
        }
    }
    
    private var temp = Int()
    private var city = String()
    private var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Авторизация"
        errorLabel.text = ""
        emailTextField.text = "aaa@rt"
        passwordTextField.text = "aaa23BD3"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        loginButton.layer.cornerRadius = 28
        emailTextField.borderStyle = .none
        emailTextField.underlined()
        passwordTextField.borderStyle = .none
        passwordTextField.underlined()
//        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        forgotOfPassword.layer.borderWidth = 1
        forgotOfPassword.layer.borderColor = (UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)).cgColor
        forgotOfPassword.layer.cornerRadius = 4
        
        self.hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2.4
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func weatherParsing() {
        
    }
}

//MARK: - extension UITextField

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        let borderColor: UIColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

//MARK: - extension UIViewController

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//MARK: - extension String

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    func isValidPassword() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension SecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
