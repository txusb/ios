//
//  Signout.swift
//  txusb
//
//  Created by 王建智 on 2019/7/18.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class Signout: UIViewController {
    var act:ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancel(_ sender: Any) {
        self.willMove(toParent: nil)
        view.removeFromSuperview()
        self.removeFromParent()
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func yes(_ sender: Any) {
       exit(0)
    }
}
