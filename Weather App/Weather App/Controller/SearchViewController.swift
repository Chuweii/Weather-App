//
//  SearchViewController.swift
//  Weather App
//
//  Created by Wei Chu on 2022/9/17.
//

import UIKit

protocol PassCitySearch{
    func recive(cityData:String)
}

class SearchViewController: UIViewController {
    
    //MARK: variable
    var delegate:PassCitySearch?
    //
    
    //MARK: iboutlet
    @IBOutlet weak var searchTextField:UITextField!
    //

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: ibaction
    @IBAction func showWeather(_sender:UIButton){
        if searchTextField.text?.trimmingCharacters(in: .whitespaces) != ""{
            dismiss(animated: true)
            delegate?.recive(cityData: searchTextField.text!)
        }else{
            let alert = UIAlertController(title: "Please enter cityname", message: .none, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
        
    }
    //

}
