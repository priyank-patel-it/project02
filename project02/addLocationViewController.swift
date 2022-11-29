//
//  addLocationViewController.swift
//  project02
//
//  Created by Priyank Patel on 2022-11-19.
//

import UIKit

class addLocationViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var weahterConditionLabel: UILabel!
    @IBOutlet weak var searchButtonTapped: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var locationName1: String?
    var currentTemp1: Float?
    var highTemp1: Float?
    var lowTemp1: Float?
    
    private let goToMainViewController = "goToMainViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.loadWeather(search: textField.text)
        return true
        
    }
    
    
    @IBAction func onSearchTapped(_ sender: UIButton) {
        loadWeather(search: searchTextField.text)
    }
    
    
    
    @IBAction func onCalcelTapped(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    @IBAction func onSaveTapped(_ sender: UIButton) {
        
        
       
        
       // dismiss(animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        locationName1 = searchTextField.text

    }
    
    
    
    
    private func loadWeather(search:String?){
        guard let search = search else{
            return
        }
        
        //Step 1 : Getting URL
        guard let url = getURL(query: search) else{
            print("Could not get url")
            return
        }
        
        //Step 2: Create URLSession
        let session = URLSession.shared
        
        //step 3: Create a task for the session
        let dataTask = session.dataTask(with: url) { [self] data, response , error in
            //network call finished
            print("Network call complete")
            
            guard error == nil else{
                print("Received error")
                return
            }
            
            guard let data = data else{
                print("No data found")
                return
            }
            
            if let weatherResponse = self.parseJson(data: data){
                print(weatherResponse.location.name)
                print(weatherResponse.current.temp_c)
                DispatchQueue.main.async {
                    
                    
                    print(weatherResponse.current.condition.code)
                   // setImage(code: WeatherResponse.current.conditio)
                   
                    print("Condition:\(weatherResponse.current.condition.text)")
                    
                    self.weahterConditionLabel.text = weatherResponse.current.condition.text
                    self.currentTemp1 = weatherResponse.forecast.forecastday[0].day.avgtemp_c
                    self.highTemp1 = weatherResponse.forecast.forecastday[0].day.maxtemp_c
                    self.lowTemp1 = weatherResponse.forecast.forecastday[0].day.mintemp_c
                    
                    
                    
                    
                }
                
            }
            
      //   let weather = decoder.decode(WeatherResponse.self, from: data)
        }
        
        //step 4: Start the task
        dataTask.resume()
        
    }
    private func getURL(query: String) -> URL? {
        
        let baseURL = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "forecast.json"
        let apiKey = "6cd0a76519b345399c7130516222911"
//      let query = "q=Toronto"
        guard let url = "\(baseURL)\(currentEndpoint)?key=\(apiKey)&q=\(query)&days=8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else{
            return nil
        }
        return URL(string: url)
    }
    
    private func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        do{
            weather = try decoder.decode(WeatherResponse.self, from: data)
        }catch{
            print("Error decoding")
        }
        return weather
        
    }

    struct WeatherResponse:Decodable {
        
        let location : Location
        let current : Weather
        let forecast: Forecast
    }
    
    struct Forecast: Decodable{
        let forecastday: [ForecastDay]
    }
    struct ForecastDay: Decodable{
         let date: String
        let day: Day
    }

    struct Day: Decodable{
        let maxtemp_c: Float
        let mintemp_c: Float
        let avgtemp_c: Float
        let condition: Condition
        
    }

    struct Condition: Decodable{
        let code: Int
    }
    
    struct Location:Decodable{
        let name: String
        
    }
    struct Weather:Decodable{
        let temp_c: Float
        let temp_f:Float
        let condition: WeatherCondition
    }

    struct WeatherCondition:Decodable{
        let text: String
        let code: Int
    }

}





