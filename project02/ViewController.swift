//
//  ViewController.swift
//  project02
//
//  Created by Priyank Patel on 2022-11-15.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    var clTemperature:Float!
    var location: String!
    var currentTemp: Float!
    var condition: String!
    var maxTemp: Float!
    var minTemp: Float!
    var avgTemp: Float!
    var forecastCode: Int!
    var currentCode: Int!

    var locationManager:CLLocationManager!
    var foreCast:[forecastday] = []
    
    //creating an array to store location names
    var locations:[addedLocation] = []
    
    
    var getData: String?
    
    private let goToDetailScreen = "goToDetailScreen"
    private let goToAddLocationScreen = "goToAddLocationScreen"
    
    
    
    override func viewDidLoad() {
        print("LOC ARR:\(locations)")
        super.viewDidLoad()
        print("Got data")
        print(" Got data: \(getData ?? "")")
       
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
       
        tableView.dataSource = self
        tableView.delegate = self
        
        //check if gps in on
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                
               
                print("Location is anable")
                self.locationManager.startUpdatingLocation()
            
               
                
            }
            else{
                print("Location is not anabled..!")
            }
        }
        
       
    }
    

    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        print("Add tapped")
        performSegue(withIdentifier: goToAddLocationScreen, sender: self)
    }
    
    
    //getting data back from addLocation view controller
    
    @IBAction func unwindFromLocationScreen(segue: UIStoryboardSegue){
        //let source = segue.source as! goToAddLocationScreen
        print("in unwind")
       
        
            let source = segue.source as! addLocationViewController
   
              getData = source.locationName1
        // setting annotation when user save the location on list
        locations.append(addedLocation(title: source.locationName1 ?? "", description: "\(source.currentTemp1 ?? 0)C  H:\(source.highTemp1 ?? 0)   L:\(source.lowTemp1 ?? 0)" ))
        loadWeather(search: source.locationName1)
        
            //print("GOT DATA FROM ADD LOCATION :\(source.locationName1 ??  "")")
    
              print("LOCATIONS:\(locations)")
        
        //setting the annotation on map on tapped list Item
        
        
        
        //tell tableview to reload the data..!
        self.tableView.reloadData()
//
          //  viewController.location =
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //setting delegate
       // mapView.delegate = self
        
        //getting current location
        let currentLocation = locations[0] as CLLocation
        print("Hello")
        print("\(currentLocation.coordinate.latitude)")
       //getting latitude and longitude
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        
        print("Latutude of cl:\(latitude)")
        print("Longitude: of cl\(longitude)")
        
        
      //  self.loadWeather(search: location )
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation){(placemarks,error) in
            if (error != nil){
                print("ERROR")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0 {
                let placemark = placemarks![0]
                let location = placemark.locality
                print("CLOCATION :\(location ?? "l")")

                
               self.loadWeather(search: location )
                
                


            }
        }
//
        
        
    }
    
    private func loadWeather(search:String?){
//        mapView.delegate = self
        guard let search = search else{
            return
        }
        //Step 1 : Getting URL
        guard let url = self.getURL(query: search) else{
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
                print("ForecastDay :\(weatherResponse.forecast.forecastday[0].date)")
                
                DispatchQueue.main.async {
                    self.clTemperature = weatherResponse.current.temp_c
                    self.location = weatherResponse.location.name
                    self.currentTemp = weatherResponse.current.temp_c
                    self.condition = weatherResponse.current.condition.text
                    self.maxTemp = weatherResponse.forecast.forecastday[0].day.maxtemp_c
                    self.minTemp = weatherResponse.forecast.forecastday[0].day.mintemp_c
                    self.currentCode = weatherResponse.current.condition.code
                   
                    for i in 1...7{
                        self.foreCast.append(forecastday(code:weatherResponse.forecast.forecastday[i].day.condition.code, day: weatherResponse.forecast.forecastday[i].date,title: weatherResponse.forecast.forecastday[i].day.avgtemp_c))
                    }
                    print("FORECAST OF 7 DAYS:\(self.foreCast)")
                    
                    
                    
                    
                    // currentTemp = weatherResponse.current.temp_c
                   
                    print(weatherResponse.current.condition.code)
                   // setImage(code: WeatherResponse.current.conditio)
                    
                    print("Condition:\(weatherResponse.current.condition.text)")
                    print("lat:\(weatherResponse.location.lat)")
                  
                    //
                    self.setupMap(latitude: weatherResponse.location.lat,longtitude: weatherResponse.location.lon,currentTemp: weatherResponse.current.temp_c,weatherCondition: weatherResponse.current.condition.text,code: weatherResponse.current.condition.code,feelsLikeTemp: weatherResponse.current.feelslike_c)
                    
                    
                }
            }
        }
   
        //step 4: Start the task
        dataTask.resume()
    }
    
    private func setupMap(latitude: Float? ,longtitude: Float? ,currentTemp: Float?,weatherCondition: String?,code: Int?,feelsLikeTemp:Float?){
        
        //set delegate
        
        mapView.delegate = self
        
        let location = CLLocation(latitude: CLLocationDegrees(latitude ?? 0), longitude: CLLocationDegrees(longtitude ?? 0))
        let radiusInMeters:CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radiusInMeters, longitudinalMeters: radiusInMeters)
        self.mapView.setRegion(region, animated: true)
        
        //camera boundaries
        
        let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        self.mapView.setCameraBoundary(cameraBoundary, animated: true)
        
        //control ZOOMING
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
        self.mapView.setCameraZoomRange(zoomRange, animated: true)
        
        //adding annotation
        let annotation = MyAnnotation(coordinate: location.coordinate,title: String(weatherCondition ?? "") ,subtitle: "\(currentTemp ?? 0) \(feelsLikeTemp ?? 0)", glyphText: String(currentTemp ?? 0), currentTemp: currentTemp, code: String(code ?? 0))
    
        self.mapView.addAnnotation(annotation)
        
    }
    

    private func getURL(query: String) -> URL? {
        
        let baseURL = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "forecast.json"
        let apiKey = "6cd0a76519b345399c7130516222911"

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
    let lat: Float
    let lon: Float
    
}
struct Weather:Decodable{
    let temp_c: Float
    let temp_f:Float
    let condition: WeatherCondition
    let feelslike_c:Float
}

struct WeatherCondition:Decodable{
    let text: String
    let code: Int
}

extension ViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "My identifier"
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        
        
                 //set the position of callout
                view.calloutOffset = CGPoint(x: 10, y: 10)
                //add a button to right side of callout
        
                 let button = UIButton(type: .detailDisclosure)
                 button.tag = 007
                 view.rightCalloutAccessoryView =  button
        
        
                    //add the title of annotation
                    if let myAnnotation = annotation as? MyAnnotation{
                        view.glyphText = myAnnotation.glyphText
                        print("CURR TEMP:::\(myAnnotation.currentTemp ?? 0)")
                        print("CODE:\(myAnnotation.code ?? "")")
                        
                        switch Int(myAnnotation.code ?? ""){
                            
                        case 1000:
                        
                            let image = UIImage(systemName: "sun.max")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            
                            break
                        
                        case 1003:
                        
                            let image = UIImage(systemName: "cloud.sun")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                        
                            break
                        case 1006:
                        
                            let image = UIImage(systemName: "cloud")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1009:
                        
                            let image = UIImage(systemName: "cloud.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1030:
                        
                            let image = UIImage(systemName: "cloud.fog.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1063:
                        
                            let image = UIImage(systemName: "cloud.drizzle")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1066:
                        
                            let image = UIImage(systemName: "cloud.snow")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1069:
                        
                            let image = UIImage(systemName: "cloud.sleet")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1072:
                        
                            let image = UIImage(systemName: "cloud.hail")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1135:
                        
                            let image = UIImage(systemName: "cloud.fog.circle")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1147:
                        
                            let image = UIImage(systemName: "cloud.fog.circle.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1150:
                        
                            let image = UIImage(systemName: "cloud.sun.rain")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1153:
                        
                            let image = UIImage(systemName: "cloud.drizzle")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1183:
                        
                            let image = UIImage(systemName: "sun.max.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1186:
                        
                            let image = UIImage(systemName: "cloud.drizzle.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1189:
                        
                            let image = UIImage(systemName: "cloud.rain.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1192:
                        
                            let image = UIImage(systemName: "cloud.heavyrain")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1198:
                        
                            let image = UIImage(systemName: "cloud.hail.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1201:
                        
                            let image = UIImage(systemName: "cloud.hail.circle.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1204:
                        
                            let image = UIImage(systemName: "cloud.sleet")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1207:
                        
                            let image = UIImage(systemName: "cloud.sleet.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1210:
                        
                            let image = UIImage(systemName: "snowflake")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1213:
                        
                            let image = UIImage(systemName: "cloud.snow")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1219:
                        
                            let image = UIImage(systemName: "cloud.snow.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1225:
                        
                            let image = UIImage(systemName: "cloud.snow.circle")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1240:
                        
                            let image = UIImage(systemName: "cloud.drizzle")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        case 1243:
                        
                            let image = UIImage(systemName: "cloud.heavyrain.fill")
                            view.leftCalloutAccessoryView = UIImageView(image: image)
                            break
                        default:
                            print("Nothig")
                        
                        }
                        
                        switch myAnnotation.currentTemp!{
                        case -100.0...0.0 :
                            view.markerTintColor = UIColor.purple
                            break
                        case 0.0...11.0:
                            view.markerTintColor = UIColor.systemBlue
                            break
                        case 12.0...16.0 :
                            view.markerTintColor = UIColor.systemTeal
                            break
                        case 17.0...24.0 :
                            view.markerTintColor = UIColor.systemOrange
                            break
                        case 25.0...30.0 :
                            view.markerTintColor = UIColor.red
                            break
                        case 35.0...100.0 :
                            view.markerTintColor = UIColor.systemRed
                            break
                        
                        default:
                            view.markerTintColor = UIColor.blue
                        }

                                    //change the color of accessories
                                    view.tintColor = UIColor.systemRed
                        
                        
        
        }
  
        return view
    }
    
   
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Button clicked :\(control.tag)")
        performSegue(withIdentifier: goToDetailScreen, sender: self)
        
        
       
        //to access data
        // view.annotation.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDetailScreen{
            let viewController = segue.destination as! detailScreenViewController
    //        viewController.location = String(clTemperature)
            viewController.location = location
            viewController.currentTemp = currentTemp
            viewController.highTemp = maxTemp
            viewController.lowTemp = minTemp
            viewController.condition = condition
            viewController.foreCastList = foreCast
            foreCast=[]
            

          //  viewController.location =
        }
        foreCast=[]
        
    }
   

    
}



class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var glyphText: String?
    var currentTemp: Float?
    var code: String?
    
    
    
    init(coordinate:CLLocationCoordinate2D, title:String, subtitle:String, glyphText:String? = nil,currentTemp:Float?,code:String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.glyphText = glyphText
        self.currentTemp = currentTemp
        self.code = code
        super.init()
    }
    
    
}

//extentio for table view delegate
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Location tapped ")
        let selectedLocation = locations[indexPath.row]
        print("SELCTED LOCATION:\(selectedLocation.title)")
        
        
        loadWeather(search: selectedLocation.title)
        
        foreCast=[]
 

    }
  
}

//extention for table View

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViweCell", for: indexPath)
        cell.backgroundColor = UIColor.systemTeal
        let location = locations[indexPath.row]
        
        
        var content = cell.defaultContentConfiguration()
        
        
        
        content.text = location.title
        content.secondaryText = location.description
        
      //  content.image = UIImage(systemName: "cloud")
        
        
        switch self.currentCode{
            
        case 1000:
        
            content.image = UIImage(systemName: "sun.max")
            
            
            break
        
        case 1003:
            
        
            content.image = UIImage(systemName: "cloud.sun")
            
        
            break
        case 1006:
            content.image = UIImage(systemName: "cloud")
         
            break
        case 1009:
        
            content.image = UIImage(systemName: "cloud.fill")
            
            break
        case 1030:
        
            content.image = UIImage(systemName: "cloud.fog.fill")
           
            break
        case 1063:
        
            content.image = UIImage(systemName: "cloud.drizzle")
            
            break
        case 1066:
        
            content.image = UIImage(systemName: "cloud.snow")
            
            break
        case 1069:
        
            content.image = UIImage(systemName: "cloud.sleet")
          
            break
        case 1072:
        
            content.image = UIImage(systemName: "cloud.hail")
            
            break
        case 1135:
        
            content.image = UIImage(systemName: "cloud.fog.circle")
        
            break
        case 1147:
        
            content.image = UIImage(systemName: "cloud.fog.circle.fill")
            
            break
        case 1150:
        
            content.image = UIImage(systemName: "cloud.sun.rain")
           
            break
        case 1153:
        
            content.image = UIImage(systemName: "cloud.drizzle")
        
            break
        case 1183:
        
            content.image = UIImage(systemName: "sun.max.fill")
            break
        case 1186:
        
            content.image = UIImage(systemName: "cloud.drizzle.fill")
            break
        case 1189:
        
            content.image = UIImage(systemName: "cloud.rain.fill")
            break
        case 1192:
        
            content.image = UIImage(systemName: "cloud.heavyrain")
            break
        case 1198:
        
            content.image = UIImage(systemName: "cloud.hail.fill")
            break
        case 1201:
        
            content.image = UIImage(systemName: "cloud.hail.circle.fill")
            break
        case 1204:
        
            content.image = UIImage(systemName: "cloud.sleet")
            break
        case 1207:
        
            content.image = UIImage(systemName: "cloud.sleet.fill")
            break
        case 1210:
        
            content.image = UIImage(systemName: "snowflake")
            break
        case 1213:
        
            content.image = UIImage(systemName: "cloud.snow")
            break
        case 1219:
        
            content.image = UIImage(systemName: "cloud.snow.fill")
            break
        case 1225:
        
            content.image = UIImage(systemName: "cloud.snow.circle")
            break
        case 1240:
        
            content.image = UIImage(systemName: "cloud.drizzle")
            break
        case 1243:
        
            content.image = UIImage(systemName: "cloud.heavyrain.fill")
            break
        default:
            content.image = UIImage(systemName: "cloud.heavyrain.fill")
             break
        }
        

        
        
        //content.prefersSideBySideTextAndSecondaryText = true
        cell.contentConfiguration = content
//        let image : UIImage = UIImage(named: "osx_design_view_messages") ?? UIImage()
//               print("The loaded image: \(image)")
//        content.image = image
       
        return cell
        
    }

    
}

struct addedLocation{
    let title: String
    let description: String
    
}

struct forecastday{
    let code: Int
    let day: String
    let title: Float
   
}


































