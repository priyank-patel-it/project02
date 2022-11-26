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
        cell.contentView.backgroundColor = UIColor.systemMint
        content.text = "\(String(foreCastcell.code))          \(foreCastcell.day) "
       // content.text = foreCastcell.day
        content.secondaryText =  String(foreCastcell.title)
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

        // Do any additional setup after loading the view.
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






