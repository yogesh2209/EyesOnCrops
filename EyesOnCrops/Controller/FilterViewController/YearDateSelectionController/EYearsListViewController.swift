//
//  EYearsListViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 5/21/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

struct YearList: Decodable {
    let year: String?
}

class EYearsListViewController: EBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var getIndicator: Int!
    var years : [YearList] = []
    
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
        setupFirebaseAnalytics(title: "EYearsListViewController")
        getYearsListServiceCall()
    }
    
    func customiseUI() {
        self.tableView.tableFooterView = UIView()
        title = "Years"
    }
    
    //MARK: Service Calling
    func getYearsListServiceCall(){
        let param: Dictionary<String, Any> =
            [
                "action_for"         : ACTION_FOR_YEARS_LIST     as Any
                
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
                    self.years = try JSONDecoder().decode([YearList].self, from: data)
                    if self.years.count != 0 {
                        self.tableView.reloadData()
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
        return self.years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: YEAR_LIST_CUSTOM_CELL, for: indexPath as IndexPath) as! EYearListTableViewCell
        
        if years.count != 0 {
            cell.labelYear.text = years[indexPath.row].year
        }
        
        return cell
    }
    
    //MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: YEAR_LIST_TO_DATES_SEGUE_VC, sender: indexPath.row)
    }
    
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == YEAR_LIST_TO_DATES_SEGUE_VC) {
            
            guard let row = sender as? Int else { return }
            
            if let year = years[row].year {
                // pass data to next view
                let secondVC = segue.destination as! EDatesForYearListViewController
                secondVC.year = year
            }
        }
    }
}
