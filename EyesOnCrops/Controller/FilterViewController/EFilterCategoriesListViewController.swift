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
    
    //MARK: UIButton Actions
    @IBAction func barButtonResetPressed(_ sender: Any) {
    }
    @IBAction func barButtonApplyPressed(_ sender: Any) {
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(FilterCategoryArray.count)
        return 2*FilterCategoryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CATEGORY_LIST_OPTION_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterCategoryListOptionTableViewCell
           cell.labelOption.text = FilterCategoryArray[indexPath.row/2]
           
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CATEGORY_LIST_SPACING_CUSTOM_CELL, for: indexPath as IndexPath) as! EFilterCategoryListPlainSpaceTableViewCell
           
            return cell
        }
    }
    //UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 != 0 {
            return 65.0
        }
        else {
            return 12.0
        }
    }
}
