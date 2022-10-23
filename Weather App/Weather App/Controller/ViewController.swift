//
//  ViewController.swift
//  Weather App
//
//  Created by Wei Chu on 2022/9/11.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class ViewController: UIViewController {
    
    //MARK: variable
    let openWeatherMapLinage = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "b2522a53e26b277a478e1149d2c30080"
    //
    
    //MARK: model實體(存放api data)
    let weatherDataModel = WeatherData()
    //
    
    //MARK: iboutlet
    @IBOutlet weak var weatherTempLbl: UILabel!
    @IBOutlet weak var weatherIcon:UIImageView!
    @IBOutlet weak var cityLbl:UILabel!
    @IBOutlet weak var gotoSearchBtn:UIButton!
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //101座標 - 25.034250274225496, 121.5639981090887
        let latitude = String(25.034250274225496)
        let longitude = String(121.5639981090887)
        let inputs : [String : String] = ["lat": latitude, "lon": longitude, "appid":apiKey]
        
        ProgressHUD.show()
        downloadData(url: openWeatherMapLinage, keys: inputs)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gotoSearchBtn.layer.cornerRadius = 10
        gotoSearchBtn.layer.borderWidth = 3
        gotoSearchBtn.layer.borderColor = CGColor(gray: 1, alpha: 1)
    }
}


extension ViewController:PassCitySearch{
    
    //MARK: fetch weatherdata
    func downloadData(url:String, keys:[String:String]){
 
        AF.request(url, method: HTTPMethod.get, parameters: keys, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).response { response in
            switch response.result {
            case .success(let data):
//                print("got it")
                
                DispatchQueue.main.async {
                    let weatherJSONData = JSON(response.value)
                    self.updateWeatherData(json: weatherJSONData)
                    
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        
        
    }
    
    //analyze json with alamofire and swiftyJSON
    func updateWeatherData(json:JSON){
        guard let temperature = json["main"]["temp"].double else{
            return cityLbl.text = "Can't find this place"
        }
        
        weatherDataModel.temperature = Int(temperature - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(conditionId: weatherDataModel.condition ?? 0)
        
        renderUI()
    }
    
    //renderUI to view with loaded data
    func renderUI(){
        
        weatherTempLbl.text = String("\(weatherDataModel.temperature ?? 0)°")
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName ?? "")
        cityLbl.text = String(weatherDataModel.city ?? "")
        
        ProgressHUD.dismiss()
    }
    
    //protocol to pass searchVC's data
    func recive(cityData: String) {
        
        let key : [String:String] = ["q":cityData, "appid":apiKey]
        downloadData(url: openWeatherMapLinage, keys: key)
        cityLbl.text = cityData
        
        ProgressHUD.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoSearchView"{
            guard let searchVC = segue.destination as? SearchViewController else{return}
            
            searchVC.delegate = self
            
            
        }
    }
    
}
