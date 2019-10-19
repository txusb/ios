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
class ViewController: BleActivity{
    @IBOutlet var rightop: UIButton!
    @IBOutlet var padicon: UIImageView!
    @IBOutlet var tlkingBt: UIButton!
    let deledate = UIApplication.shared.delegate as! AppDelegate
    var timer: Timer?
    var etalk=E_Command()
    @IBOutlet var tit: UILabel!
    @IBOutlet var LoadingView: UIView!
    @IBOutlet var Connectlabel: UILabel!
    let animationView = AnimationView(name: "simple-loader2")
    var command=Command()
    @IBOutlet var back: UIButton!
    @IBOutlet var Container: UIView!
        var Selectmake=""
        var Selectmodel=""
        var Selectyear=""
        var directfit=""
    override func Disconnect() {
        let a=peacedefine().HomePage
        ChangePage(to: a)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView=Container
        command.act=self
        print(ViewController.getShare("lan"))
        delgate.act=self
        let queue = DispatchQueue.main
        centralManager = CBCentralManager(delegate: self, queue: queue)
       dowload_mmy()
    if(ViewController.getShare("admin")=="nodata"){
            let a=peacedefine().LanguageSetting
            a.page=1
            ChangePage(to:a)
        }else{
            let a=peacedefine().HomePage
            ChangePage(to:a)
        }
       
        animationView.center = self.view.center
        animationView.frame = CGRect(x: animationView.frame.minX, y: animationView.frame.minY+20, width: 200, height: 200)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode=LottieLoopMode.loop
        view.addSubview(animationView)
    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(CheckPlace), userInfo: nil, repeats: true)
        Function.GetVersion()
    }
    func dowload_mmy(){
        self.DataLoading()
        DispatchQueue.global().async {
            let res=FtpManage().DowloadMmy(self.deledate)
            DispatchQueue.main.async {
                if(res){
                    self.LoadingSuccess()
                }else{self.dowload_mmy()}
            }
        }
    }
    var isloading=false
    override func LoadIng(_ a:String) {
        Connectlabel.text=a
        animationView.center = self.view.center
        animationView.frame = CGRect(x: animationView.frame.minX, y: animationView.frame.minY+20, width: 200, height: 200)
        LoadingView.center = self.view.center
        isloading=true
        LoadingView.isHidden=false
        animationView.isHidden=false
        animationView.play()
    }
    override func LoadingSuccess() {
         isloading=false
        animationView.pause()
        LoadingView.isHidden=true
        animationView.isHidden=true
    }

    @IBAction func GoBack(_ sender: Any) {
        if(isloading){return}
        GoBack()
    }
    
    @IBAction func Signout(_ sender: Any) {
        let a=peacedefine().Signout
        a.act=self
        SwipePage(to: a)
    }
    func DataLoading(){
       Connectlabel.text=SetLan.Setlan("Data_Loading")
        LoadingSuccess()
    }
    @ objc func CheckPlace(){
        if(IsConnect&&ISRUN){padicon.isHidden=false}else{
            padicon.isHidden=true
        }
    }
   
    static func getShare(_ name:String)->String{
        let preferences = UserDefaults.standard
        let currentLevelKey = name
        if preferences.object(forKey: currentLevelKey) == nil {
            return "nodata"
        } else {
            let currentLevel = preferences.string(forKey: currentLevelKey)!
            return currentLevel
        }
    }
  
    static func writeshare(_ name:String,_ key:String){
        let preferences = UserDefaults.standard
        preferences.set(name,forKey: key)
        let didSave = preferences.synchronize()
        if !didSave {
            print("saverror")
        }
}
    @IBAction func ToTalking(_ sender: Any) {
        let a=peacedefine().TalkingActivity
        ChangePage(to: a)
    }
    override func PageChangeLinster(){
        back.setImage(UIImage.init(named: "btn_back_normal"), for: .normal)
                 tlkingBt.isHidden=true
          if(Pagememory.count>=2){
                        self.back.isHidden=false
          }else{   self.back.isHidden=true
                           self.rightop.isHidden=false
                           self.ISRUN=false
                           self.padicon.isHidden=true}
        if(back.image(for: .normal)==UIImage.init(named: "btn_Menu")){
                      back.setImage(UIImage.init(named: "btn_back_normal"), for: .normal)
                      let a=peacedefine().HomePage
                      ChangePage(to: a)
                      return
                  }
      }
}
