//
//  HomeVCViewController.swift
//  PGDEV
//
//  Created by Family on 9/18/24.
//

import UIKit


class HomeVC: UIViewController {
    
    let urlStr = "https://codepen.io/Pr-Punk/full/LYXevaX"
    
    @IBAction func siteButton(_ sender: UIButton) {
        if let url = URL(string: self.urlStr) {
                UIApplication.shared.open(url, options: [:]) { success in
                    // Handle success or failure if needed
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
