//
//  Policy.swift
//  txusb
//
//  Created by 王建智 on 2019/8/6.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class Policy: UIViewController {
 let act=(UIApplication.shared.delegate as! AppDelegate).act!
    @IBOutlet var yes: UIButton!
    @IBOutlet var dis: UIButton!
    var position=0
    @IBOutlet var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
text.text=SetLan.Setlan("Welcome")
        yes.setTitle(SetLan.Setlan("Agree"), for: .normal)
         dis.setTitle(SetLan.Setlan("Disagree"), for: .normal)
      text.scrollsToTop=true
    }

    @IBAction func Disagree(_ sender: Any) {
           exit(0)
    }
    
    @IBAction func Agree(_ sender: Any) {
        if(position==0){
            act.GoBack(self)
        }else{
        let a=peacedefine().Sign_in
            act.changepage(to: a)
        }
    }
}
