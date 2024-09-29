//
//  LoadingScreenVC.swift
//  PGDEV
//
//  Created by Family on 9/23/24.
//

import UIKit


class LoadingScreenVC: UIViewController {

    @IBOutlet weak var loadingGIF: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingGif = UIImage.gifImageWithName("loading")
        loadingGIF.image = loadingGif
        Task { // Use a Task to run the async operation
                await getAPIs() // Call your async function with 'await'
        }
        // Do any additional setup after loading the view.
    }
    
    private func transit() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "tabBarCont") as! UITabBarController
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func getAPIs() async {
        loadingGroup.enter()
        do {
            try await fetchRepAPIData(with: "https://api.jsonbin.io/v3/b/65c02b82dc74654018a05265", headers: ["X-Master-Key": "$2a$10$smQs8yKXKzsJrIcbs0VMt.QMqlC8l8/bReh.rqYxHmiKdrVZJ/6.."])
            // Process the received data
        } catch {
            print("Error fetching data: \(error)")
        }
        loadingGroup.notify(queue: .main) {
            self.transit()
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
