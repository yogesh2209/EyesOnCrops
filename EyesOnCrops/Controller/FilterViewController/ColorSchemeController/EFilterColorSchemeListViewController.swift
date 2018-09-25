//
//  EFilterColorSchemeListViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/24/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import PopupDialog

class EFilterColorSchemeListViewController: EBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var barButtonApply: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var lastSelected : IndexPath? = nil
    
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
        setLastSelectedLevel()
        setupFirebaseAnalytics(title: "EFilterColorSchemeListViewController")
        reloadTableView()
    }
    
    //MARK: UIBarButton Action
    
    @IBAction func barButtonApplyPressed(_ sender: Any) {
        if lastSelected?.row == 1 {
            self.storeDataInDefaults(type: "DEFAULT", key: "COLOR_SCHEME")
        }
        else if lastSelected?.row == 3 {
            self.storeDataInDefaults(type: "CUSTOM-1", key: "COLOR_SCHEME")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Custom methods
    
    func customiseUI() {
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setLastSelectedLevel() {
        if let level = self.getStoredDataFromUserDefaults(for: "COLOR_SCHEME") {
            if level == "DEFAULT" {
                lastSelected = IndexPath(row: 1, section: 0)
            }
            else if level == "CUSTOM-1" {
                lastSelected = IndexPath(row: 3, section: 0)
            }
            else{
                lastSelected = IndexPath(row: 1, section: 0)
            }
        }
        else{
            lastSelected = IndexPath(row: 1, section: 0)
            self.storeDataInDefaults(type: "DEFAULT", key: "COLOR_SCHEME")
        }
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2*colorSchemeListArray.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //LEVEL LIST OPTIONS HERE
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_COLOR_SCHEME_OPTION_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterColorSchemeOptionTableViewCell
            
            cell.labelSchemeName.text = colorSchemeListArray[indexPath.row/2]
            cell.imageViewColorScheme.image = UIImage.init(named: "scheme-1")

            if let ls = lastSelected, ls == indexPath {
                DispatchQueue.main.async {
                    cell.imageViewCheckmark.isHidden = false
                    cell.imageViewCheckmark.image = UIImage.init(named: "tick.png")
                }
            }
            else{
                DispatchQueue.main.async {
                    cell.imageViewCheckmark.isHidden = true
                }
            }
            
            return cell
        }
            //SPACING CELL HERE
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_COLOR_PLAIN_SPACE_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterColorSchemePlainSpaceTableViewCell
            cell.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            return cell
        }
    }
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 != 0 {
            if let lastSelected = lastSelected {
                let cell = self.tableView.cellForRow(at: lastSelected) as! EFilterColorSchemeOptionTableViewCell
                DispatchQueue.main.async {
                    cell.imageViewCheckmark.isHidden = true
                }
                let cell1 = self.tableView.cellForRow(at: indexPath) as! EFilterColorSchemeOptionTableViewCell
                DispatchQueue.main.async {
                    cell1.imageViewCheckmark.isHidden = false
                    cell1.imageViewCheckmark.image = UIImage.init(named: "tick.png")
                }
            }
            else{
                let cell = self.tableView.cellForRow(at: indexPath) as! EFilterColorSchemeOptionTableViewCell
                DispatchQueue.main.async {
                    cell.imageViewCheckmark.isHidden = false
                    cell.imageViewCheckmark.image = UIImage.init(named: "tick.png")
                }
            }
            
            lastSelected = indexPath
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 != 0 {
            return 142.0
        }
        else {
            return 12.0
        }
    }
}
