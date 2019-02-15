//
//  cityViewController.swift
//  Clima
//
//  Created by Shashwat  on 14/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit

protocol cityViewControllerDelegate {
    func getCityWeather(_ city:String)
}

class cityViewController: UIViewController {
    
   
    var delegate:cityViewControllerDelegate?
    
    @IBOutlet weak var buttonGetWeather: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        let city = cityTextField.text
        if delegate != nil && city != nil {
            delegate!.getCityWeather(city!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buttonGetWeather.layer.cornerRadius = 20
        buttonGetWeather.clipsToBounds = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
