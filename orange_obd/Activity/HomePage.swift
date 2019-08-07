//
//  HomePage.swift
//  orange_obd
//
//  Created by 王建智 on 2019/7/5.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class HomePage: UIViewController {
   let activity=(UIApplication.shared.delegate as! AppDelegate).act!
    @IBOutlet var t6: UILabel!
    @IBOutlet var t5: UILabel!
    @IBOutlet var t4: UILabel!
    @IBOutlet var t3: UILabel!
    @IBOutlet var t2: UILabel!
    @IBOutlet var t1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.rightop.isHidden=false
        activity.ISRUN=false
        t3.text=SetLan.Setlan("Cloud_information")
        t4.text=SetLan.Setlan("Online_shopping")
        t5.text=SetLan.Setlan("Users_manual")
        t6.text=SetLan.Setlan("Setting")
    }

    @IBAction func tomake(_ sender: Any) {
        PadSelect.Function=1
                    let a=peacedefine().PadSelect
                    a.act=activity
        activity.changepage(to: a)
//        let a=peacedefine().PadSelect
//        a.act=activity
//        activity?.changepage(to: a)

    }
    
    @IBAction func tocopy(_ sender: Any) {
        PadSelect.Function=0
        let a=peacedefine().PadSelect
        a.act=activity
        activity.changepage(to: a)
    }
    
 
    @IBAction func ToManual(_ sender: Any) {
        let a=peacedefine().Users_Manual
        activity.changepage(to: a)
    }
    override func viewWillAppear(_ animated: Bool) {
        activity.tit.text="Orange TPMS"
        
    }
    @IBAction func ToSetting(_ sender: Any) {
        let a=peacedefine().Setting
        activity.changepage(to: a)
    }
}
