//
//  EFilterCategoriesListViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 2/5/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterCategoriesListViewController: EBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var barButtonApply: UIBarButtonItem!
    @IBOutlet weak var barButtonReset: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
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
        super.viewWillAppear(true)
        setupFirebaseAnalytics(title: "EFilterCategoriesListViewController")
        self.tableView.reloadData()
    }
    //MARK: Private Methods
    func  customiseUI() {
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    //Switch Actions
    @objc func switchAquaChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        //If switch aqua is on, need to switch off the terra and vice versa
        if sender.isOn == true {
            let indexPath = IndexPath(row: 3, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! EFilterCategorySatelliteTypeTableViewCell
            cell.switchAqua.setOn(true, animated: true)
            cell.switchTerra.setOn(false, animated: true)
        }
        else{
            let indexPath = IndexPath(row: 3, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! EFilterCategorySatelliteTypeTableViewCell
            cell.switchAqua.setOn(false, animated: true)
            cell.switchTerra.setOn(true, animated: true)
        }
    }
    @objc func switchTerraChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        //If switch aqua is on, need to switch off the terra and vice versa
        if sender.isOn == true {
            let indexPath = IndexPath(row: 3, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! EFilterCategorySatelliteTypeTableViewCell
            cell.switchAqua.setOn(false, animated: true)
            cell.switchTerra.setOn(true, animated: true)
        }
        else{
            let indexPath = IndexPath(row: 3, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! EFilterCategorySatelliteTypeTableViewCell
            cell.switchAqua.setOn(true, animated: true)
            cell.switchTerra.setOn(false, animated: true)
        }
    }
    
    @objc func switchMapTypeChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
       
        //Globe selected
        if sender.isOn == true {
            let indexPath =  IndexPath(row: 1, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! EFilterCategoryMapTypeOptionTableViewCell
            cell.switchMapType.setOn(true, animated: true)
            cell.labelMapDetail.text = "Globe selected"
            self.storeMapTypeInDefaults(type: "GLOBE")
        }
            //map selected
        else{
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! EFilterCategoryMapTypeOptionTableViewCell
            cell.switchMapType.setOn(false, animated: true)
            cell.labelMapDetail.text = "Map selected"
            self.storeMapTypeInDefaults(type: "MAP")
        }
        self.storeLevelInUserDefaults(level: "LEVEL-0")
    }
    
    //MARK: UIButton Actions
    @IBAction func barButtonResetPressed(_ sender: Any) {
    }
    @IBAction func barButtonApplyPressed(_ sender: Any) {
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2*FilterCategoryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            
            //MAP TYPE CELL HERE
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CATEGORY_MAP_TYPE_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterCategoryMapTypeOptionTableViewCell
                cell.switchMapType.addTarget(self, action: #selector(self.switchMapTypeChanged(_:)), for: .valueChanged)
                
                if let storedMapType = self.getStoredMapTypeFromUserDefaults() {
                    if storedMapType == "GLOBE" {
                        cell.switchMapType.setOn(true, animated: false)
                        cell.labelMapDetail.text = "Globe selected"
                    }
                    else{
                        cell.switchMapType.setOn(false, animated: false)
                        cell.labelMapDetail.text = "Map selected"
                    }
                }
                else{
                    cell.switchMapType.setOn(true, animated: false)
                    self.storeMapTypeInDefaults(type: "GLOBE")
                    cell.labelMapDetail.text = "Globe selected"
                }
                
                cell.labelMapHeading.text = "Globe / Map"
                
                
                return cell
            }
            
            //SATELLITE TYPE CELL HERE
           else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CATEGORY_SATELLITE_TYPE_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterCategorySatelliteTypeTableViewCell
                cell.switchAqua.addTarget(self, action: #selector(self.switchAquaChanged(_:)), for: .valueChanged)
                cell.switchTerra.addTarget(self, action: #selector(self.switchTerraChanged(_:)), for: .valueChanged)
                return cell
            }
                //REST OPTIONS HERE
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CATEGORY_LIST_OPTION_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterCategoryListOptionTableViewCell
                cell.labelOption.text = FilterCategoryArray[indexPath.row/2]
                cell.labelSelectedOption.text = categoryDetailsArray[indexPath.row/2]
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CATEGORY_LIST_SPACING_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterCategoryListPlainSpaceTableViewCell
            return cell
        }
    }
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        //year list screen
        case 5:
            self.performSegue(withIdentifier: FILTER_TO_YEAR_LIST_SEGUE_VC, sender: nil)
            
        //level list screen
        case 7:
            self.performSegue(withIdentifier: CATEGORY_LIST_TO_LEVEL_LIST_SEGUE_VC, sender: nil)
            
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 != 0 {
            if indexPath.row == 1 {
                return 65.0
            }
            else if indexPath.row == 3 {
                return 110.0
            }
            else{
                return 65.0
            }
        }
        else {
            return 12.0
        }
    }
    
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == FILTER_TO_YEAR_LIST_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! EYearsListViewController
            secondVC.getIndicator = 1 //indicates that year list is being appeared from this screen
        }
    }
}
