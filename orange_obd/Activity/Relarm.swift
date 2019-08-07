//
//  Relarm.swift
//  txusb
//
//  Created by 王建智 on 2019/8/7.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class Relarm: UIViewController {
var tit=""
    
    @IBOutlet var toper: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
toper.text=tit
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
