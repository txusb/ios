//
//  Policy.swift
//  txusb
//
//  Created by 王建智 on 2019/8/6.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class Policy: UIViewController {

    @IBOutlet var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
text.text=SetLan.Setlan("Welcome")
      text.scrollsToTop=true
    }

}
