//
//  detailScreenViewController.swift
//  project02
//
//  Created by Priyank Patel on 2022-11-19.
//

import UIKit

class detailScreenViewController: UIViewController {
    
    var location: String?
    var currentTemp: Float?
    var condition: String?
    var highTemp: Float?
    var lowTemp: Float?

    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location ?? "")
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
