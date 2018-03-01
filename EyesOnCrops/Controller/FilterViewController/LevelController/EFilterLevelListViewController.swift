//
//  EFilterLevelListViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 2/7/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterLevelListViewController: EBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        setupFirebaseAnalytics(title: "EFilterLevelListViewController")
        reloadTableView()
    }
    //MARK: Private Methods
    func customiseUI() {
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK: UIButton Actions
    @IBAction func barButtonApplyPressed(_ sender: Any) {
    }
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2*LevelListArray.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //LEVEL LIST OPTIONS HERE
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_LEVEL_LIST_OPTION_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterLevelListOptionTableViewCell
            cell.labelOption.text = LevelListArray[indexPath.row/2]
            return cell
        }
        //SPACING CELL HERE
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_LEVEL_LIST_PLAIN_SPACE_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterLevelListPlainSpaceTableViewCell
            cell.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            return cell
        }
    }
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 != 0 {
            if let lastSelected = lastSelected {
                print(lastSelected)
                let cell = self.tableView.cellForRow(at: lastSelected) as! EFilterLevelListOptionTableViewCell
                DispatchQueue.main.async {
                    cell.imageViewCheckMark.isHidden = true
                }
                let cell1 = self.tableView.cellForRow(at: indexPath) as! EFilterLevelListOptionTableViewCell
                DispatchQueue.main.async {
                    cell1.imageViewCheckMark.isHidden = false
                    cell1.imageViewCheckMark.image = UIImage.init(named: "tick.png")
                }
            }
            else{
                let cell = self.tableView.cellForRow(at: indexPath) as! EFilterLevelListOptionTableViewCell
                DispatchQueue.main.async {
                    cell.imageViewCheckMark.isHidden = false
                    cell.imageViewCheckMark.image = UIImage.init(named: "tick.png")
                }
            }
             lastSelected = indexPath
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 != 0 {
            return 44.0
        }
        else {
            return 12.0
        }
    }
}
