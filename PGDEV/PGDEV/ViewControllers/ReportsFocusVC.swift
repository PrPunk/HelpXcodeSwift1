//
//  ReportsFocusVC.swift
//  PGDEV
//
//  Created by Family on 9/22/24.
//

import UIKit


class ReportsFocusVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var reporters: [Reporter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reporters = repPlayers[repIndex].repts
        tableView.dataSource = self
        tableView.delegate = self
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

extension ReportsFocusVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reporters.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = reporters[indexPath.row].name
        cell.textLabel?.textColor = (reporters[indexPath.row].valid == false) ? .systemRed : .label
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            self.reporters.remove(at: indexPath.row)
            repPlayers[repIndex].repts = self.reporters
            repPlayers[repIndex].reps = reportersToCount(repts: repPlayers[repIndex].repts)
            repPlayers[repIndex].defState = defStatePicker(index: repIndex)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionImage = (reporters[indexPath.row].valid == false) ? "hand.thumbsup" : "hand.thumbsdown"
        
        let validAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            self.reporters[indexPath.row].valid.toggle()
            repPlayers[repIndex].repts = self.reporters
            repPlayers[repIndex].reps = reportersToCount(repts: repPlayers[repIndex].repts)
            repPlayers[repIndex].defState = defStatePicker(index: repIndex)
            tableView.reloadRows(at: [indexPath], with: .fade)
            completion(true)
        }
        validAction.image = UIImage(systemName: actionImage)
        validAction.backgroundColor = (reporters[indexPath.row].valid == false) ? .systemGreen : .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [validAction])
        return config
    }
    
}
