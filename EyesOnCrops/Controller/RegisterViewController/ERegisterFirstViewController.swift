//
//  ERegisterFirstViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class ERegisterFirstViewController: EBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewFirstName: ECustomView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewMiddleName: ECustomView!
    @IBOutlet weak var viewLastName: ECustomView!
    @IBOutlet weak var textFieldDOB: ECustomTextField!
    @IBOutlet weak var textFieldMiddleName: ECustomTextField!
    @IBOutlet weak var viewDOB: ECustomView!
    @IBOutlet weak var textFieldLastName: ECustomTextField!
    @IBOutlet weak var textFieldFirstName: ECustomTextField!
    
    var pickerView = UIPickerView()
    var yearArray = NSMutableArray()
    var index : Int = 0
    
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
        super.viewWillAppear(animated)
        customiseUI()
        setupFirebaseAnalytics(title: "ERegisterFirstViewController")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextfield Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textFieldFirstName {
          textFieldMiddleName.becomeFirstResponder()
        }
        else if textField == self.textFieldMiddleName {
           textFieldLastName.becomeFirstResponder()
        }
        else if textField == self.textFieldLastName {
            textFieldDOB.becomeFirstResponder()
        }
        else {
          textField.resignFirstResponder()
        }
    }
    //MARK: Private Methods
    func customiseUI() {
         self.pickerView.reloadAllComponents()
        self.navigationController?.isNavigationBarHidden = false
    }
    func getFirstName() -> String {
        if let tempFirstName = self.textFieldFirstName.text {
            return tempFirstName
        }
        else {
            return ""
        }
    }
    func getMiddleName() -> String {
        if let tempMiddleName = self.textFieldMiddleName.text {
            return tempMiddleName
        }
        else {
            return ""
        }
    }
    func getLastName() -> String {
        if let tempLasttName = self.textFieldLastName.text {
            return tempLasttName
        }
        else {
            return ""
        }
    }
    func getDOB() -> String {
        if let tempDOB = self.textFieldDOB.text {
            return tempDOB
        }
        else {
            return ""
        }
    }
    func resignResponsers() {
        self.textFieldFirstName.resignFirstResponder()
        self.textFieldMiddleName.resignFirstResponder()
        self.textFieldLastName.resignFirstResponder()
        self.textFieldDOB.resignFirstResponder()
    }
    func nextButtonAction() {
        if getFirstName().count != 0 && getLastName().count != 0 && getDOB().count != 0 {
            //Take him to next screen and pass data to next screen
            self.performSegue(withIdentifier: REGISTER_1_TO_2_SEGUE_VC, sender: nil)
        }
        else{
            self.alertMessage(title: "ALERT", message: "Required fields cannot be empty!")
        }
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
            self.alertMessage(title: "ALERT", message: "Something went wrong, please try again later")
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
    @IBAction func buttonNextPressed(_ sender: UIButton) {
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
        if (segue.identifier == REGISTER_1_TO_2_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! ERegisterSecondViewController
            secondVC.getFirstName = getFirstName()
            secondVC.getLastName = getLastName()
            secondVC.getDOB = getDOB()
            if getMiddleName().count == 0 {
                secondVC.getMiddleName = ""
            }
            else{
                secondVC.getMiddleName = getMiddleName()
            }
        }
    }
}
