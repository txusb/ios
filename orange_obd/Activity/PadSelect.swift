//
//  PadSelect.swift
//  txusb
//
//  Created by 王建智 on 2019/7/15.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit
class PadSelect: UIViewController {
    var act:ViewController?=nil
   static var Function=0
    static var Scanner_OR_Select=0
    @IBOutlet var veselection: UILabel!
    @IBOutlet var scan: UILabel!
    @IBOutlet var tit: UILabel!
    @IBOutlet var padimg: UIImageView!
    @IBOutlet var ProgramView: UIButton!
    @IBOutlet var copyview: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        if(act!.IsConnect){
            act!.padicon.isHidden=false
        }else{
             act!.padicon.isHidden=true
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateui(0)
    tit.text=SetLan.Setlan("Methods_of_vehicle_data_selection")
          act!.rightop.isHidden=true
          act!.ISRUN=true
        scan.text=SetLan.Setlan("Scan_Code")
        veselection.text=SetLan.Setlan("Vehicle_data_selection")
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(false)
        updateui(PadSelect.Function)
        let home=act?.Pagememory[0]
        act?.Pagememory.removeAll()
        act?.Pagememory.append(home!)
        act?.Pagememory.append(self)
    }
    @IBAction func mmy(_ sender: Any) {
//        let a=peacedefine().SelectMake
//        a.act=self.act
//        self.act?.changepage(to: a)
        PadSelect.Scanner_OR_Select=1
        if(!act!.haveble){
            act!.view.showToast(text: SetLan.Setlan("openble"))
            return
        }
        if(act!.IsConnect){
            DispatchQueue.global().async {
                let responds=self.act!.command.Command03()
                DispatchQueue.main.async {
                    if(responds){
                        let a=peacedefine().SelectMake
                        a.act=self.act
                        self.act?.changepage(to: a)
                    }else{
                        let a=peacedefine().BleScanner
                        a.act=self.act
                        self.act?.goscanner(to: a)
                        self.act!.centralManager.scanForPeripherals(withServices: nil, options: nil)
                    }
                }
            }
        }else{
            let a=peacedefine().BleScanner
            a.act=self.act
            self.act?.goscanner(to: a)
        }
    }
   
    @IBAction func Program(_ sender: Any) {
        PadSelect.Function=1
        updateui(1)
    }
    @IBAction func idcopy(_ sender: Any) {
        PadSelect.Function=0
        updateui(0)
    }
    func updateui(_ position:Int){
        copyview.setTitleColor(UIColor.init(named: "btncolor"), for: .normal)
        ProgramView.setTitleColor(UIColor.init(named: "btncolor"), for: .normal)
       copyview.borderColor=UIColor.init(named: "btncolor")
    ProgramView.borderColor=UIColor.init(named: "btncolor")
        copyview.borderWidth=1
        ProgramView.borderWidth=1
        copyview.backgroundColor=UIColor.init(named: "backcolor")
        ProgramView.backgroundColor=UIColor.init(named: "backcolor")
        switch position {
        case 0:
            act!.tit.text=SetLan.Setlan("ID_COPY")
copyview.setTitleColor(UIColor.white, for: .normal)
copyview.backgroundColor=UIColor.init(named: "btncolor")
padimg.image=UIImage.init(named: "img_ID copy")
            break
        default:
            ProgramView.setTitleColor(UIColor.white, for: .normal)
            ProgramView.backgroundColor=UIColor.init(named: "btncolor")
            act!.tit.text=SetLan.Setlan("Program")
            padimg.image=UIImage.init(named: "img_program")
            break
        }
    }
    func bytesToHex(_ bt:[UInt8])->String{
                var re=""
                for i in 0..<bt.count{
                      re=re.appending(String(format:"%02X",bt[i]))
                }
              return re
            }
    
    @IBAction func ToScanner(_ sender: Any) {
        PadSelect.Scanner_OR_Select=0
        if(!act!.haveble){
            act!.view.showToast(text: SetLan.Setlan("openble"))
            return
        }
        if(act!.IsConnect){
            DispatchQueue.global().async {
                let responds=self.act!.command.Command03()
                DispatchQueue.main.async {
                    if(responds){
                        let a=peacedefine().QrScanner
                        self.act?.changepage(to: a)
                    }else{
                        let a=peacedefine().BleScanner
                        a.act=self.act
                        self.act?.goscanner(to: a)
                    self.act!.centralManager.scanForPeripherals(withServices: nil, options: nil)
                    }
                }
            }
        }else{
            let a=peacedefine().BleScanner
            a.act=self.act
            self.act?.goscanner(to: a)
        }
       
    }
}
