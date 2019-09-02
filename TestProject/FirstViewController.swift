//
//  ViewController.swift
//  testProjectForHH
//
//  Created by Рома Комаров on 26/08/2019.
//  Copyright © 2019 Рома Комаров. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {
    @IBOutlet weak var autorizationButton: UIButton!
    
    @IBAction func buttonAction(_ sender: Any) {
        
        guard let storyboard = storyboard else {
            return
        }
        
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "secondVC")
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autorizationButton.layer.cornerRadius = 28
        
    }
}

