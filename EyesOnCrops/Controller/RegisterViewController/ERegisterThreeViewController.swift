//
//  ERegisterThreeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class ERegisterThreeViewController: EBaseViewController {

    @IBOutlet weak var buttonPickupCurrentLocation: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var textViewLocation: UITextView!
    
    //Get all the parameters from the previous screen
    var getFirstName: String!
    var getMiddleName: String!
    var getLastName: String!
    var getDOB: String!
    var getEmail: String!
    var getPhone: String!
    
    var isLocationPicked = Bool()
    
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
        setupFirebaseAnalytics(title: "ERegisterThreeViewController")
    }
    //MARK: Private Methods
    func customiseUI() {
        textViewLocation.placeholder = "Enter your location here"
    }
    func nextButtonAction() {
        if isLocationPicked == true || textViewLocation.text.count != 0 {
            if getFirstName.count != 0 && getLastName.count != 0 && getDOB.count != 0 && getEmail.count != 0 && getPhone.count != 0 {
                
            }
        }
        //Error
        else{
             self.alertMessage(title: "ALERT", message: "Either pick current location or enter location manually!")
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonPickupCurrentLocationPressed(_ sender: UIButton) {
    }
    @IBAction func buttonNextPressed(_ sender: UIButton) {
        nextButtonAction()
    }
}
// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
}
