//
//  ViewController.swift
//  orange_obd
//
//  Created by 王建智 on 2019/7/4.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit
import Lottie
import CoreBluetooth
import JzBleHelper_os
import JzIos_Framework
import Firebase
class ViewController: JzActivity,BleCallBack{
    @IBOutlet var rightop: UIButton!
    @IBOutlet var padicon: UIImageView!
    @IBOutlet var tlkingBt: UIButton!
    lazy var helper=BleHelper(self)
    @IBOutlet var areaimage: UIButton!
    @IBOutlet var tit: UILabel!
    @IBOutlet var LoadingView: UIView!
    @IBOutlet var Connectlabel: UILabel!
    @IBOutlet var back: UIButton!
    @IBOutlet var Container: UIView!
    let animationView = AnimationView(name: "simple-loader2")
    var command=Command()
    let delgate = UIApplication.shared.delegate as! AppDelegate
    var timer: Timer?
    var etalk=E_Command()
    var serialnum="99"
    var scanback:(()->Void?)? = nil
    var connectBack:(()->Void?)? = nil
     override func viewInit()  {
        Messaging.messaging().subscribe(toTopic: "txusbupdate") { error in
                print("Subscribed to txusbupdate topic")
              }
        print("id:\(Bundle.main.bundleIdentifier!)")
         PublicBeans.OBD資料庫.autoCreat()
        rootView=Container
        command.act=self
        delgate.act=self
        if(JzActivity.getControlInstance.getPro("admin","nodata")=="nodata"){
              JzActivity.getControlInstance.setHome(Page_SelectArea(), "area")
        }else{
              JzActivity.getControlInstance.setHome(peacedefine().HomePage, "Page_SelectArea")
        }
       
        Function.GetVersion()
    }
    func dowload_mmy(){
        DonloadFile.dataloading()
    }
    var isloading=false
    
    func ChangePage(to:UIViewController){
        JzActivity.getControlInstance.changePage(to,  String(describing: type(of: to)), true)
    }
    
    @IBAction func GoBack(_ sender: Any) {
        if(isloading){return}
        if(back.image(for: .normal)==UIImage.init(named: "btn_Menu")){
            back.setImage(UIImage.init(named: "btn_back_normal"), for: .normal)
            JzActivity.getControlInstance.goMenu()
            return
        }else{
            JzActivity.getControlInstance.goBack()
        }
    }
    
    @IBAction func Signout(_ sender: Any) {
        let a=peacedefine().Signout
        a.act=self
        JzActivity.getControlInstance.openDiaLog(a, false, "Signout")
    }
    func DataLoading(){
        let a=Progress()
        a.label=SetLan.Setlan("Data_Loading")
        JzActivity.getControlInstance.openDiaLog(a,true,"Progress")
    }
    
    func LoadingSuccess(){
        JzActivity.getControlInstance.closeDialLog()
    }
    override func changePageListener(_ controler: pagemenory) {
           if(Pagememory.count<2){
               back.isHidden=true
           }else{
               back.isHidden=false
           }
           PublicBeans.refrsh()
           print("Switch\(controler.tag)")
        if(controler.page is Page_SelectArea){
                    areaimage.isHidden=true
                }else{
                if(JzActivity.getControlInstance.getPro("Area", "EU")=="EU"){
                        areaimage.setImage(UIImage(named: "icon_EU"), for: .normal)
                    }else{
                        areaimage.setImage(UIImage(named: "icon_NA"), for: .normal)
                    }
                    areaimage.isHidden=false
                }
                if(Pagememory.count>=2){
                    self.back.isHidden=false
                }else{   self.back.isHidden=true
                    self.rightop.isHidden=false
                    self.padicon.isHidden=true}
       }
    @IBAction func ToTalking(_ sender: Any) {
    
    }
 
    var bles:[CBPeripheral]=[CBPeripheral]()
     
     //連線中的回調
     func onConnecting() {
         print("onConnecting")
     }
     //連線失敗時回調
     func onConnectFalse() {
         print("onConnectFalse")
         JzActivity.getControlInstance.closeDialLog()
         helper.startScan()
        self.padicon.isHidden=true
     }
     //連線成功時回調
     func onConnectSuccess() {
         print("onConnectSuccess")
         JzActivity.getControlInstance.closeDialLog()
         DispatchQueue.global().async {
                    sleep(3)
                    self.command.Setserial()
        Function.AddIfNotValid(self.serialnum,JzActivity.getControlInstance.getPro("admin", "nodata"),JzActivity.getControlInstance.getPro("password", "nodata"))
                }
        self.padicon.isHidden=false
        if(connectBack != nil){
            connectBack!()
        }
     }
     
     //三種方式返回接收到的藍芽訊息
     func rx(_ a: BleBinary) {
         Command.rx=Command.rx+a.readHEX()
         print("rx:\(a.readHEX())")
     }
     
     //三種方式返回傳送的藍芽訊息
     func tx(_ b: BleBinary) {
         print("tx:\(b.readHEX())")
     }
     
     //返回搜尋到的藍芽,可將搜尋到的藍芽儲存於陣列中，可用於之後的連線
     func scanBack(_ device: CBPeripheral) {
         if(!bles.contains(device)){
             bles.append(device)
         }
         print(device.name)
         if(scanback != nil){scanback!()}
         
     }
     
     //藍芽未打開，經聽到此function可提醒使用者打開藍芽
     func needOpen() {
         print("noble")
     }
}
