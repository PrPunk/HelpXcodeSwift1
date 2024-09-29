//
//  SettingsVC.swift
//  PGDEV
//
//  Created by Family on 9/21/24.
//

import UIKit


class SettingsVC: UIViewController {

    var saved = false
    
    
    
    @IBAction func repsBanCallback(_ sender: UITextField) {
        autoRepPause = Int(repsBan.text ?? "0") ?? 0
        if autoRepPause == 0 {
            repsBan.text = "0"
        }
    }
    @IBOutlet weak var repsBan: UITextField!
    
    
    
    @IBAction func repsFlagCallback(_ sender: UITextField) {
        autoRepFlag = Int(repsFlag.text ?? "0") ?? 0
        if autoRepFlag == 0 {
            repsFlag.text = "0"
        }
    }
    @IBOutlet weak var repsFlag: UITextField!
    
    
    
    @IBAction func autoBanSwitchCallback(_ sender: UISwitch) {
        autoReport = autoBanSwitch.isOn
    }
    @IBOutlet weak var autoBanSwitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoBanSwitch.isOn = autoReport
        repsFlag.text = String(autoRepFlag)
        repsBan.text = String(autoRepPause)
        repsFlag.delegate = self
        repsBan.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saved = false
        autoBanSwitch.isOn = autoReport
        repsFlag.text = String(autoRepFlag)
        repsBan.text = String(autoRepPause)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        saved = true
        saveButtonData.isEnabled = false
        checkRepAPIGroup.enter()
        putRepAPIGroup.enter()
        Task {
            await checkRepAPIData()
        }
        checkRepAPIGroup.notify(queue: .main) {
            Task {
                try await putRepAPIData(with: "https://api.jsonbin.io/v3/b/65c02b82dc74654018a05265", headers: ["X-Master-Key": "$2a$10$smQs8yKXKzsJrIcbs0VMt.QMqlC8l8/bReh.rqYxHmiKdrVZJ/6.."])
            }
        }
        putRepAPIGroup.notify(queue: .main) {
            self.saveButtonData.isEnabled = true
        }
    }
    
    @IBOutlet weak var saveButtonData: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension SettingsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        repsFlag.resignFirstResponder()
        repsBan.resignFirstResponder()
        return true
    }
}
