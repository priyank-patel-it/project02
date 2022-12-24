//
//  errorScreenViewController.swift
//  project02
//
//  Created by Priyank Patel on 2022-12-16.
//

import UIKit

class errorScreenViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var errorCode: UILabel!
    @IBOutlet weak var alertImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemGray])
        alertImage.preferredSymbolConfiguration = config
        alertImage.image = UIImage(systemName: "xmark.octagon")
        if errorCode.text == "2006" || errorCode.text == "2006"{
            doneButton.setTitle("Change Api", for: .normal)
            
        }else{
            doneButton.setTitle("Done", for: .normal)
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneTapped(_ sender: UIButton) {
        
        if errorCode.text == "2006" || errorCode.text == "2006"{
            
            let alert = UIAlertController(title: "New Api Key", message: "Please enter new API key", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default){
                _ in print("Ok pressed")
                self.dismiss(animated: true)
                
            }

            let cancelButton = UIAlertAction(title: "Cancel", style: .default){
                _ in print("Calcel Pressed")
            }
        
            alert.addTextField()
            
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.show(alert, sender: nil)
            
        }else{
            dismiss(animated: true)
        }
        
        
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
