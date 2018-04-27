//
//  EPasswordRecoveryStepTwoViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/11/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EPasswordRecoveryStepTwoViewController: EBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var viewDOB: ECustomView!
    @IBOutlet weak var textFieldDOB: ECustomTextField!
    
    var pickerView = UIPickerView()
    var yearArray = NSMutableArray()
    var index : Int = 0
    
    var dob: String!
    var getUserEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        addToolBar()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFirebaseAnalytics(title: "EPasswordRecoveryStepTwoViewController")
    }
    //MARK: Private Methods
    func getDOB() -> String {
        if let dob = self.textFieldDOB.text {
            return dob
        }
        else {
            return ""
        }
    }
    func isDOBMatched() -> Bool {
        if dob == getDOB() {
            return true
        }
        return false
    }
    func nextButtonAction() {
        
        if getDOB().count == 0 {
            alertMessage(title: ALERT_TITLE, message: EMPTY_DATE_OF_BIRTH_ERROR)
            return
        }

        if isDOBMatched() {
            self.performSegue(withIdentifier: PSWD_RECOVERY_DOB_TO_FINAL_SEGUE_VC, sender: nil)
        }
        else{
            alertMessage(title: ALERT_TITLE, message: DATE_OF_BIRTH_MISMATCH_ERROR)
        }
    }
    
    func resignResponsers() {
        self.textFieldDOB.resignFirstResponder()
    }
    
    func addToolBar() {
        let numberToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneToolBarButton))]
        numberToolbar.sizeToFit()
        self.textFieldDOB.inputAccessoryView = numberToolbar
    }
    
    //done tool bar button action
    @objc func doneToolBarButton() {
        resignResponsers()
        if yearArray.count != 0 {
            DispatchQueue.main.async {
                self.textFieldDOB.text = self.yearArray[self.index] as? String
            }
        }
        else {
            self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
        }
    }
    func setupPickerView() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.showsSelectionIndicator = true
        self.textFieldDOB.inputView = self.pickerView
        for index in 1970...2017 {
            yearArray.add(String(index))
        }
    }
    
    //MARK: UIButton Actions
    @IBAction func buttonNextPressed(_ sender: Any) {
        nextButtonAction()
    }
    
    //MARK: UIPickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard yearArray.count != 0  else { return 0 }
        return yearArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard yearArray.count != 0  else { return nil }
        return yearArray[row] as? String
    }
    //MARK: UIPickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
    }
    
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == PSWD_RECOVERY_DOB_TO_FINAL_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! EPasswordRecoveryStepThreeViewController
            secondVC.getUserEmail = getUserEmail
        }
    }
}
