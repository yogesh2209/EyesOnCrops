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
    var dates : [DatesList] = []
    
    public var year: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func customiseUI() {
        self.tableViewDatesList.tableFooterView = UIView()
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
                        self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    }
                    return
                }
                
                guard let data = response.data else { return }
                
                do {
                    self.dates = try JSONDecoder().decode([DatesList].self, from: data)
                    if self.dates.count != 0 {
                        self.tableViewDatesList.reloadData()
                    }
                }
                catch {
                    self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    return
                }
                
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
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
 
    }
}
