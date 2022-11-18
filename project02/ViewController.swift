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

    @IBOutlet weak var mapView: MKMapView!
//    var latitude:Double? = nil
//    var longitude:Double? = nil
    var clTemperature:Float!
    var locationManager:CLLocationManager!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //loadWeather(search: "Ahmedabad")
        
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
        
        
       // addAnotation(location: <#T##CLLocation#>)
       
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
//                let location = CLLocation(latitude: latitude, longitude: longitude)
//                let annotation = MyAnnotation(coordinate: location.coordinate,title: String(weatherResponse.current.temp_c) ,subtitle: "SUBTITLE")
//                mapView.addAnnotation(annotation)
                
                DispatchQueue.main.async {
                    self.clTemperature = weatherResponse.current.temp_c
                    // currentTemp = weatherResponse.current.temp_c
                   
                    print(weatherResponse.current.condition.code)
                   // setImage(code: WeatherResponse.current.conditio)
                    
                    print("Condition:\(weatherResponse.current.condition.text)")
                    print("lat:\(weatherResponse.location.lat)")
                  
                    //
                    self.setupMap(latitude: weatherResponse.location.lat,longtitude: weatherResponse.location.lon,currentTemp: weatherResponse.current.temp_c)
                    
                    
//                    let location = CLLocation(latitude: CLLocationDegrees(weatherResponse.location.lat), longitude: CLLocationDegrees(weatherResponse.location.lon))
//                    let radiusInMeters:CLLocationDistance = 1000
//                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radiusInMeters, longitudinalMeters: radiusInMeters)
//                    self.mapView.setRegion(region, animated: true)
//
//                    //camera boundaries
//
//                    let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
//                    self.mapView.setCameraBoundary(cameraBoundary, animated: true)
//
//                    //control ZOOMING
//                    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
//                    self.mapView.setCameraZoomRange(zoomRange, animated: true)
//
//                    //adding annotation
//                    let annotation = MyAnnotation(coordinate: location.coordinate,title: String(weatherResponse.current.temp_c) ,subtitle: "SUBTITLE")
//                    self.mapView.addAnnotation(annotation)
//
                    
                    
                
                }
                
            }
            
      //      let weather = decoder.decode(WeatherResponse.self, from: data)
        }
        
        //step 4: Start the task
        dataTask.resume()
        
       
        ///
    }
    
    private func setupMap(latitude: Float? ,longtitude: Float? ,currentTemp: Float?){
        
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
        let annotation = MyAnnotation(coordinate: location.coordinate,title: String(currentTemp ?? 0) ,subtitle: "SUBTITLE", glyphText: "Q", currentTemp: currentTemp)
        self.mapView.addAnnotation(annotation)
        
    }
    
    
//    private func addAnotation(location:CLLocation){
//
//
//        let annotation = MyAnnotation(coordinate: location.coordinate)
//        mapView.addAnnotation(annotation)
//    }
    private func getURL(query: String) -> URL? {
        
        let baseURL = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "9ae6f9dfbee049448ac222827221311"
//      let query = "q=Toronto"
        guard let url = "\(baseURL)\(currentEndpoint)?key=\(apiKey)&q=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else{
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
}

struct WeatherCondition:Decodable{
    let text: String
    let code: Int
}

extension ViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "My identifier"
        var view: MKMarkerAnnotationView
        
        //check to see if we have a view we can reuse
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
           //get updated annotation
            dequeuedView.annotation = annotation
            
            //pass back out reusable view
            view = dequeuedView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            
            
            //set the position of callout
            view.calloutOffset = CGPoint(x: 10, y: 10)
             //add a button to right side of callout
            
            let button = UIButton(type: .detailDisclosure)
            button.tag = 007
            view.rightCalloutAccessoryView =  button
            
            let image = UIImage(systemName: "graduationcap.circle.fill")
            view.leftCalloutAccessoryView = UIImageView(image: image)
            
            //change the color of marker
            
            
            view.markerTintColor = UIColor.purple
            
            //change the color of accessories
            view.tintColor = UIColor.systemRed
            
            //add the title of annotation
            if let myAnnotation = annotation as? MyAnnotation{
                view.glyphText = myAnnotation.glyphText
                print("CURR TEMP:::\(myAnnotation.currentTemp ?? 0)")
                //Add condition for tintColor
                view.markerTintColor = UIColor.red
            }
            
        }
        
        
       
        
        
        
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Button clicked :\(control.tag)")
    }
    
    
}


class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var glyphText: String?
    var currentTemp: Float?
    
    
    
    init(coordinate:CLLocationCoordinate2D, title:String, subtitle:String, glyphText:String? = nil,currentTemp:Float?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.glyphText = glyphText
        self.currentTemp = currentTemp
        super.init()
    }
    
    
}

