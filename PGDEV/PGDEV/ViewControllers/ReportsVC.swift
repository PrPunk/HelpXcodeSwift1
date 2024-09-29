//
//  ReportsVC.swift
//  PGDEV
//
//  Created by Family on 9/18/24.
//

import UIKit


class ReportsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(handleTimerExecution), userInfo: nil, repeats: true)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for (index, player) in repPlayers.enumerated() {
            if player.repts.count <= 0 {
                repPlayers.remove(at: index)
            }
        }
        repsDefState()
        tableView.reloadData() // Reload data when view appears again
    }
    
    @objc private func handleTimerExecution() {
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
            self.tableView.reloadData()
        }
//        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
//            self.tableView.reloadData()
//        })
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

extension ReportsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repPlayers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsTableViewCell") as! ReportsTableViewCell
        cell.reportsCellTitle.text = repPlayers[indexPath.row].pName
        if repPlayers[indexPath.row].state == "" {
            cell.reportsCellSubtitle.text = "\(repPlayers[indexPath.row].reps) - \(repPlayers[indexPath.row].defState)"
            cell.reportsCellIcon.image = UIImage(named: repPlayers[indexPath.row].defState)
        } else {
            cell.reportsCellSubtitle.text = "\(repPlayers[indexPath.row].reps) - \(repPlayers[indexPath.row].state)"
            cell.reportsCellIcon.image = UIImage(named: repPlayers[indexPath.row].state)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionImage = (repPlayers[indexPath.row].state == "Exempt") ? "hand.thumbsdown" : "hand.thumbsup"
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            if repPlayers[indexPath.row].state == "Exempt" {
                repPlayers[indexPath.row].state = ""
            } else {
                repPlayers[indexPath.row].state = "Exempt"
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: actionImage)
        deleteAction.backgroundColor = (repPlayers[indexPath.row].state == "Exempt") ? .systemRed : .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionImage = (repPlayers[indexPath.row].state == "Banned") ? "wifi" : "wifi.slash"
        
        let banAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            if repPlayers[indexPath.row].state == "Banned" {
                repPlayers[indexPath.row].state = ""
            } else {
                repPlayers[indexPath.row].state = "Banned"
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
            completion(true)
        }
        banAction.image = UIImage(systemName: actionImage)
        banAction.backgroundColor = (repPlayers[indexPath.row].state == "Banned") ? .systemGreen : .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [banAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = Storyboard.instantiateViewController(withIdentifier: "ReportsFocusVC") as! ReportsFocusVC
        
        repIndex = indexPath.row
        
        self.navigationController?.pushViewController(destVC, animated: true)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

class ReportsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reportsCellTitle: UILabel!
    @IBOutlet weak var reportsCellSubtitle: UILabel!
    @IBOutlet weak var reportsCellIcon: UIImageView!
}
