//
//  EDatesForYearListViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 5/21/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

struct DatesList: Decodable {
    let start_date: String?
}

class EDatesForYearListViewController: EBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewDatesList: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(EDatesForYearListViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        return refreshControl
    }()
    
    var dates : [DatesList] = []
    public var year: String? = nil
    let messagelabel = UILabel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "EDatesForYearListViewController")
        
        guard let year = year else { return }
        
        getDatesInYearListServiceCall(year: year)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.postNotification(notification: .popToHomeScreenNotification)
    }
    
    // MARK: Custom Methods
    
    func customiseUI() {
        self.tableViewDatesList.tableFooterView = UIView()
        self.tableViewDatesList.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //service call
        if let y = year {
           self.getDatesInYearListServiceCall(year: y)
        }
        
        refreshControl.endRefreshing()
    }
   
    //MARK: Service Calling
    func getDatesInYearListServiceCall(year: String){
        let param: Dictionary<String, Any> =
            [
                "action_for"         : ACTION_FOR_DATES_IN_YEAR  as Any,
                "year"               : year                      as Any
                
                ] as Dictionary<String, Any>
        
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Fetching info")
        let urL = MAIN_URL + POST_GET_DATA
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
            
            switch response.result {
            case .success:
                self.hideAnimatedProgressBar()
                
                if let json = response.result.value as? NSDictionary {
                    if let _ = json["messageResponse"] {
                        self.alertMessage(title: ALERT_TITLE, message: NO_DATES_FOR_YEAR_FOUND)
                        self.emptyMessageLabel(for: self.tableViewDatesList, label: self.messagelabel, hidden: false, text: NO_DATES_FOR_YEAR_FOUND + ". Please pull to refresh.")
                    }
                    return
                }
                
                guard let data = response.data else { return }
                
                do {
                    self.dates = try JSONDecoder().decode([DatesList].self, from: data)
                    if self.dates.count != 0 {
                        self.tableViewDatesList.reloadData()
                    }
                    self.messagelabel.isHidden = true
                }
                catch {
                    self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    self.emptyMessageLabel(for: self.tableViewDatesList, label: self.messagelabel, hidden: false, text: SOMETHING_WENT_WRONG_ERROR + ". Please pull to refresh.")
                    return
                }
                
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                 self.emptyMessageLabel(for: self.tableViewDatesList, label: self.messagelabel, hidden: false, text: SOMETHING_WENT_WRONG_ERROR + ". Please pull to refresh.")
            }
        }
    }
    
    //MARK: UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DATES_LIST_CUSTOM_CELL, for: indexPath as IndexPath) as! EDatesForYearListTableViewCell
        
        if dates.count != 0 {
            cell.labelDate.text = dates[indexPath.row].start_date
        }
        
        return cell
    }
    
    //MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //take him to home screen with passing data to that screen
        if dates.count != 0, let date = dates[indexPath.row].start_date {
            postNotification(notification: .saveDateNotification, date: date)
            self.navigationController?.backToViewController(vc: EHomeViewController.self)
        }
    }
    
    // MARK: Notifications
    func postNotification(notification: Notification.Name, date: String) {
        NotificationCenter.default.post(name: notification, object: self, userInfo: ["selected_date" : date])
    }
}
