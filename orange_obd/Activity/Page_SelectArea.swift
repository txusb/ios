//
//  Page_SelectArea.swift
//  txusb
//
//  Created by Jianzhi.wang on 2020/2/25.
//  Copyright © 2020 王建智. All rights reserved.
//

import UIKit
import JzIos_Framework
class Page_SelectArea: UIViewController {
    var page=0
    @IBOutlet var area: UILabel!
    let act = (UIApplication.shared.delegate as! AppDelegate).act!
    override func viewDidLoad() {
        super.viewDidLoad()
        area.text=SetLan.Setlan("to_give")
    }
    
    @IBAction func eu(_ sender: Any) {
        
          if(JzActivity.getControlInstance.getPro("Area", "US") != "EU"){JzActivity.getControlInstance.setPro("dataloading", "false")}
        JzActivity.getControlInstance.setPro("Area", "EU")
        let a=peacedefine().LanguageSetting
        if(page != 1){a.page=1}
        act.ChangePage(to: a)
    }
    
    @IBAction func us(_ sender: Any) {
        if(JzActivity.getControlInstance.getPro("Area", "US") != "US"){JzActivity.getControlInstance.setPro("dataloading", "false")}
         JzActivity.getControlInstance.setPro("Area", "US")
        let a=peacedefine().LanguageSetting
        if(page != 1){a.page=1}
        act.ChangePage(to: a)
    }
   
  
}
