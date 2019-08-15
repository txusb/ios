//
//  VersionUpdate.swift
//  txusb
//
//  Created by 王建智 on 2019/8/9.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class VersionUpdate: UIViewController {

    @IBOutlet var versionupdate: UIButton!
    @IBOutlet var willauto: UILabel!
    @IBOutlet var autoupdate: UILabel!
    @IBOutlet var chechupdate: UILabel!
    @IBOutlet var fordeveloper: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
versionupdate.setTitle(SetLan.Setlan("Version_update"), for: .normal)
willauto.text=SetLan.Setlan("USB TPMS APP will automatically install updates.")
autoupdate.text=SetLan.Setlan("Automatic update")
    chechupdate.text=SetLan.Setlan("Check for updates")
    fordeveloper.text=SetLan.Setlan("For developer")
    }
}
