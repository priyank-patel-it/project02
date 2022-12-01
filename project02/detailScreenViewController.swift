//
//  detailScreenViewController.swift
//  project02
//
//  Created by Priyank Patel on 2022-11-19.
//

import UIKit

class detailScreenViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreCastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath)
        let foreCastcell = foreCastList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        //content.image = UIImage(named: "osx_design_view_messages")
        cell.backgroundColor = UIColor.systemTeal
        
        let isoDate = foreCastcell.day

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:isoDate)!

                
        
//
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: foreCastcell.day)!
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate)
        
//        let weekDay = Calendar.current.component(.weekday, from: date)
//
        let weekday = ["Noday","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
       
        
        
        
        
        content.text = "  \(weekday[weekDay]) "
        content.secondaryText =  String(foreCastcell.title)
        
        
        
        switch foreCastcell.code{
            
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
        
        
        
        content.prefersSideBySideTextAndSecondaryText = true
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    var location: String?
    var currentTemp: Float?
    var condition: String?
    var highTemp: Float?
    var lowTemp: Float?
    var foreCastList: [forecastday] = []

    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location ?? "")
        
        tabelView.dataSource = self
        
        locationLabel.text = location
        currentTempLabel.text = "\(currentTemp ?? 0 )"
        conditionLabel.text = condition
        highTempLabel.text = "\(highTemp ?? 0)"
        lowTempLabel.text = "\(lowTemp ?? 0)"

    
    }
    



}






