//
//  EAboutUsViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/20/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit


class EAboutUsViewController: UIViewController {

    @IBOutlet weak var textViewAboutUs: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: PrivateMethods
    func setTextView() {
        self.textViewAboutUs.text = "This application is a smartphone app for visualization and analysis of the crop yield data (VACYD)"
    }

}
