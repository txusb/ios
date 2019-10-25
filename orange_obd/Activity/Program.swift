//
//  Program.swift
//  txusb
//
//  Created by 王建智 on 2019/7/16.
//  Copyright © 2019 王建智. All rights reserved.
//
import SQLite3
import UIKit
import Lottie
class Program: UIViewController {
    let act=(UIApplication.shared.delegate as! AppDelegate).act!
    let PROGRAM_SUCCESS=0
    let PROGRAM_WAIT=1
    let UN_LINK=4
    @IBOutlet var success: UILabel!
    let PROGRAM_FAULSE=2
    let PROGRAMMING=3
    let LF=5
    let RF=6
    let LR=7
    var ISPROGRAMMING=false
    @IBOutlet var ProgramView: UIButton!
    @IBOutlet var copyview: UIButton!
    let RR=8
    var Lfid="ABCDEF"
    var Rfid="ABCDEF"
    var Lrid="ABCDEF"
    var Rrid="ABCDEF"
    var WriteLf=""
    var WriteLr=""
    var WriteRR=""
    var WriteRf=""
    var Lf="0"
    var idcount=8
    @IBOutlet var Lfi: UIImageView!
    @IBOutlet var Rfi: UIImageView!
    @IBOutlet var Rri: UIImageView!
    @IBOutlet var Lri: UIImageView!
    @IBOutlet var RFtire: UIButton!
    @IBOutlet var LRtire: UIButton!
    @IBOutlet var RRtire: UIButton!
    @IBOutlet var LFtire: UIButton!
    @IBOutlet var RRl: UIButton!
    @IBOutlet var LRl: UIButton!
    @IBOutlet var RFl: UIButton!
    @IBOutlet var LFl: UIButton!
    @IBOutlet var CopyText: UIButton!
    
    @IBOutlet var condition: UILabel!
    let animationView = AnimationView(name: "simple-loader2")
    @IBOutlet var loader: UIView!
    @IBOutlet var program: UIButton!
    @IBOutlet var relearn: UIButton!
    let deledate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var nnyname: UILabel!
    var mmynum:String!=nil
    var titmmy=""
    override func viewDidLoad() {
        super.viewDidLoad()
        if(mmynum==nil){ query()
nnyname.text="\(act.Selectmake)/\(act.Selectmodel)/\(act.Selectyear)"
        }else{
         nnyname.text=titmmy
        }
        queryid()
        queryLf()
        CopyText.setTitle("ID COPY", for: .normal)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode=LottieLoopMode.loop
        view.addSubview(animationView)
        if(WriteLf.count != 8){dowloadmmy()}
        success.text=SetLan.Setlan("Please_remove_the_sensor")
        relearn.setTitle(SetLan.Setlan("Relearn_Procedure"), for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        updateui(PadSelect.Function)
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
            copyview.setTitleColor(UIColor.white, for: .normal)
            copyview.backgroundColor=UIColor.init(named: "btncolor")
            break
        default:
            ProgramView.setTitleColor(UIColor.white, for: .normal)
            ProgramView.backgroundColor=UIColor.init(named: "btncolor")
            break
        }
    }
    func dowloadmmy(){
        act.DataLoading()
        ISPROGRAMMING=true
        DispatchQueue.global().async {
            let a=FtpManage().DowloadS19(self.mmynum!)
            DispatchQueue.main.async {
                if(a=="false"){
                    self.dowloadmmy()
                }else{
                  self.act.LoadingSuccess()
                  self.act.command.mmydata=a
                  self.ISPROGRAMMING=false
                }
            }
           
        }
    }
    func play() {
        animationView.center = self.view.center
        animationView.frame = CGRect(x: animationView.frame.minX, y: animationView.frame.minY, width: 200, height: 200)
        loader.center = self.view.center
        loader.isHidden=false
        animationView.isHidden=false
        animationView.play()
    }
    func LoadingSuccess() {
        animationView.pause()
        loader.isHidden=true
        animationView.isHidden=true
    }
    var first=true
    func UdCondition(){
        DispatchQueue.global().async {
            for i in 0...1{
                let CH1=self.act.command.Command11(i, 1)
                var Id1=self.act.command.ID
                let CH2=self.act.command.Command11(i, 2)
                var Id2=self.act.command.ID
                DispatchQueue.main.async {
                    if(CH1){
    if(self.mmynum=="RN1628"||self.mmynum=="SI2048"){
        let Writetmp=Id1.sub(0..<2)+"XX"+Id1.sub(4..<6)+"YY"
        Id1=Writetmp.replace("XX", Id1.sub(6..<8)).replace("YY", Id1.sub(2..<4))
                        }
                        Id1=String(Id1.suffix(self.idcount))
                        if(i==0){
                            self.Lfid=Id1
                            if(self.first){self.UpdateUI(self.LF, self.PROGRAM_WAIT)}
                            self.LFl.setTitle(self.Lfid, for: .normal)
                        }else{
                            self.Rfid=Id1
                            if(self.first){self.UpdateUI(self.RF, self.PROGRAM_WAIT)}
                            self.RFl.setTitle(self.Rfid, for: .normal)
                        }
                    }else{
                        if(i==0){
                            self.Lfid=SetLan.Setlan("Unlinked")
                            if(self.first){self.UpdateUI(self.LF, self.UN_LINK)}
                            self.LFl.setTitle(self.Lfid, for: .normal)
                        }else{
                            self.Rfid=SetLan.Setlan("Unlinked")
                            if(self.first){self.UpdateUI(self.RF, self.UN_LINK)}
                            self.RFl.setTitle(self.Rfid, for: .normal)
                        }
                    }
                    if(CH2){
                if(self.mmynum=="RN1628"||self.mmynum=="SI2048"){
                let Writetmp=Id2.sub(0..<2)+"XX"+Id2.sub(4..<6)+"YY"
                            Id2=Writetmp.replace("XX", Id2.sub(6..<8)).replace("YY", Id2.sub(2..<4))
                        }
                        Id2=String(Id2.suffix(self.idcount))
                        if(i==0){
                            self.Lrid=Id2
                            if(self.first){self.UpdateUI(self.LR, self.PROGRAM_WAIT)}
                            self.LRl.setTitle(self.Lrid, for: .normal)
                        }else{
                            self.Rrid=Id2
                            if(self.first){self.UpdateUI(self.RR, self.PROGRAM_WAIT)}
                            self.RRl.setTitle(self.Rrid, for: .normal)
                        }
                    }else{
                        if(i==0){
                            self.Lrid=SetLan.Setlan("Unlinked")
                            if(self.first){self.UpdateUI(self.LR, self.UN_LINK)}
                            self.LRl.setTitle(self.Lrid, for: .normal)
                        }else{
                            self.Rrid=SetLan.Setlan("Unlinked")
                            if(self.first){self.UpdateUI(self.RR, self.UN_LINK)}
                            self.RRl.setTitle(self.Rrid, for: .normal)
                        }
                    }
                }
            }
           sleep(4)
                                if(self.first){
                                    self.UdCondition()}
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.first=true
        UpdateUiCondition(PROGRAM_WAIT)
        UpdateUI(LF,UN_LINK)
        UpdateUI(RF,UN_LINK)
        UpdateUI(LR,UN_LINK)
        UpdateUI(RR,UN_LINK)
        UdCondition()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.first=false
    }
    func UpdateUiCondition(_ position:Int){
        relearn.isHidden=true
        program.isHidden=true
        LoadingSuccess()
        loader.isHidden=true
        success.isHidden=true
        switch position {
        case PROGRAM_SUCCESS:
            success.isHidden=false
            condition.text=SetLan.Setlan("Programming_completed")
    condition.textColor=UIColor.init(named:"btncolor")
            program.setTitle(SetLan.Setlan("RE_PROGRAM"), for: .normal)
            relearn.isHidden=false
            program.isHidden=false
            break
        case PROGRAM_WAIT:
             program.isHidden=false
             program.setTitle(SetLan.Setlan("Program_sensor"), for: .normal)
             condition.text=SetLan.Setlan("Please_insert_the_sensor_into_the_USB_PAD")
    condition.textColor=UIColor.init(named:"btncolor")
            break
        case PROGRAM_FAULSE:
            program.isHidden=false
            program.setTitle(SetLan.Setlan("RE_PROGRAM")
, for: .normal)
            condition.textColor=UIColor.init(named: "orange")
            condition.text=SetLan.Setlan("Programming_failed_where")
            break
        case PROGRAMMING:
            loader.isHidden=false
            play()
            program.isHidden=false
            program.setTitle(SetLan.Setlan("Program_sensor"), for: .normal)
            condition.text=SetLan.Setlan("Programming_do_not_move_sensors")
            condition.textColor=UIColor.init(named: "btncolor")
            break
        default:
            break
        }
    }
    func query(){
        if deledate.db != nil {
            let sql="select `Direct Fit` from `Summary table` where Make='\(act.Selectmake)' and Model='\(act.Selectmodel)' and year='\(act.Selectyear)' and `Direct Fit` not in('NA') limit 0,1"
            var statement:OpaquePointer? = nil
            if sqlite3_prepare(deledate.db,sql,-1,&statement,nil) != SQLITE_OK{
                let errmsg=String(cString:sqlite3_errmsg(deledate.db))
                print(errmsg)
            }
            while sqlite3_step(statement)==SQLITE_ROW{
                let iid = sqlite3_column_text(statement,0)
                if iid != nil{
                    let iids = String(cString: iid!)
                    mmynum=iids
                    print("s19:\(iids)")
                } }  } }
    func queryLf(){
        if deledate.db != nil {
            let sql="select `Lf` from `Summary table` where `Direct Fit`='\(mmynum!)' limit 0,1"
            var statement:OpaquePointer? = nil
            if sqlite3_prepare(deledate.db,sql,-1,&statement,nil) != SQLITE_OK{
                let errmsg=String(cString:sqlite3_errmsg(deledate.db))
                print(errmsg)
            }
            while sqlite3_step(statement)==SQLITE_ROW{
                let iid = sqlite3_column_text(statement,0)
                if iid != nil{
                    let iids = String(cString: iid!)
                    Lf=iids
                    print("Lf:\(iids)")
                } }  } }
    func queryid(){
        if deledate.db != nil {
            let sql="select `ID_Count` from `Summary table` where `Direct Fit`='\(mmynum!)' and `make` not in('NA') limit 0,1"
            var statement:OpaquePointer? = nil
            if sqlite3_prepare(deledate.db,sql,-1,&statement,nil) != SQLITE_OK{
                let errmsg=String(cString:sqlite3_errmsg(deledate.db))
                print(errmsg)
            }
            while sqlite3_step(statement)==SQLITE_ROW{
                let iid = sqlite3_column_text(statement,0)
                if iid != nil{
                    let iids = String(cString: iid!)
                    idcount=Int(iids)!
                    print("Id:\(iids)")
                } }  } }
    func UpdateUI(_ position:Int,_ situation:Int){
        switch position {
        case LF:
            switch(situation){
            case UN_LINK:
                LFl.setTitle(SetLan.Setlan("Unlinked"), for: .normal)
                LFl.setBackgroundImage(UIImage.init(named: "icon_input_box_locked"), for: .normal)
                Lfi.isHidden=true
                LFtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            case PROGRAM_SUCCESS:
                LFl.setTitle(Lfid, for: .normal)
                LFl.setBackgroundImage(UIImage.init(named: "icon_input_box_ok"), for: .normal)
                Lfi.isHidden=false
                Lfi.image=UIImage.init(named: "correct")
                LFtire.setBackgroundImage(UIImage.init(named: "icon_tire_ok"), for: .normal)
                break
            case PROGRAM_FAULSE:
                LFl.setTitle(Lfid, for: .normal)
                LFl.setBackgroundImage(UIImage.init(named: "icon_input_box_fail"), for: .normal)
                Lfi.isHidden=false
                Lfi.image=UIImage.init(named: "error")
                LFtire.setBackgroundImage(UIImage.init(named: "icon_tire_fail"), for: .normal)
                break
            case PROGRAM_WAIT:
                LFl.setTitle(Lfid, for: .normal)
                LFl.setBackgroundImage(UIImage.init(named: "icon_input_box_write"), for: .normal)
                Lfi.isHidden=true
                LFtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            default:
                break
            }
            break
        case RF:
            switch(situation){
            case UN_LINK:
                RFl.setTitle(SetLan.Setlan("Unlinked"), for: .normal)
                RFl.setBackgroundImage(UIImage.init(named: "icon_input_box_locked"), for: .normal)
                Rfi.isHidden=true
                RFtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            case PROGRAM_SUCCESS:
                RFl.setTitle(Rfid, for: .normal)
                RFl.setBackgroundImage(UIImage.init(named: "icon_input_box_ok"), for: .normal)
                Rfi.isHidden=false
                Rfi.image=UIImage.init(named: "correct")
                RFtire.setBackgroundImage(UIImage.init(named: "icon_tire_ok"), for: .normal)
                break
            case PROGRAM_FAULSE:
                RFl.setTitle(Rfid, for: .normal)
                RFl.setBackgroundImage(UIImage.init(named: "icon_input_box_fail"), for: .normal)
                Rfi.isHidden=false
                Rfi.image=UIImage.init(named: "error")
                RFtire.setBackgroundImage(UIImage.init(named: "icon_tire_fail"), for: .normal)
                break
            case PROGRAM_WAIT:
                RFl.setTitle(Rfid, for: .normal)
                RFl.setBackgroundImage(UIImage.init(named: "icon_input_box_write"), for: .normal)
                Rfi.isHidden=true
                RFtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            default:
                break
            }
            break
        case LR:
            switch(situation){
            case UN_LINK:
                LRl.setTitle(SetLan.Setlan("Unlinked"), for: .normal)
                LRl.setBackgroundImage(UIImage.init(named: "icon_input_box_locked"), for: .normal)
                Lri.isHidden=true
                LRtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            case PROGRAM_SUCCESS:
                LRl.setTitle(Lrid, for: .normal)
                LRl.setBackgroundImage(UIImage.init(named: "icon_input_box_ok"), for: .normal)
                Lri.isHidden=false
                Lri.image=UIImage.init(named: "correct")
                LRtire.setBackgroundImage(UIImage.init(named: "icon_tire_ok"), for: .normal)
                break
            case PROGRAM_FAULSE:
                LRl.setTitle(Lrid, for: .normal)
                LRl.setBackgroundImage(UIImage.init(named: "icon_input_box_fail"), for: .normal)
                Lri.isHidden=false
                Lri.image=UIImage.init(named: "error")
                LRtire.setBackgroundImage(UIImage.init(named: "icon_tire_fail"), for: .normal)
                break
            case PROGRAM_WAIT:
                LRl.setTitle(Lrid, for: .normal)
                LRl.setBackgroundImage(UIImage.init(named: "icon_input_box_write"), for: .normal)
                Lri.isHidden=true
                LRtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            default:
                break
            }
            break
        case RR:
            switch(situation){
            case UN_LINK:
                RRl.setTitle(SetLan.Setlan("Unlinked"), for: .normal)
                RRl.setBackgroundImage(UIImage.init(named: "icon_input_box_locked"), for: .normal)
                Rri.isHidden=true
                RRtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            case PROGRAM_SUCCESS:
                RRl.setTitle(Rrid, for: .normal)
                RRl.setBackgroundImage(UIImage.init(named: "icon_input_box_ok"), for: .normal)
                Rri.isHidden=false
                Rri.image=UIImage.init(named: "correct")
                RRtire.setBackgroundImage(UIImage.init(named: "icon_tire_ok"), for: .normal)
                break
            case PROGRAM_FAULSE:
                RRl.setTitle(Rrid, for: .normal)
                RRl.setBackgroundImage(UIImage.init(named: "icon_input_box_fail"), for: .normal)
                Rri.isHidden=false
                Rri.image=UIImage.init(named: "error")
                RRtire.setBackgroundImage(UIImage.init(named: "icon_tire_fail"), for: .normal)
                break
            case PROGRAM_WAIT:
                RRl.setTitle(Rrid, for: .normal)
                RRl.setBackgroundImage(UIImage.init(named: "icon_input_box_write"), for: .normal)
                Rri.isHidden=true
                RRtire.setBackgroundImage(UIImage.init(named: "icon_tire_normal"), for: .normal)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    @IBAction func StartProgram(_ sender: Any) {
       
        if(program.titleLabel!.text=="RE-PROGRAM"&&self.WriteLf.count==8){
            act.GoBack(self)
        }else{Program()}
        
    }
    func Program(){
        if(!ISPROGRAMMING){
            act.back.isEnabled=false
            first=false
            ISPROGRAMMING=true
            UpdateUiCondition(PROGRAMMING)
            DispatchQueue.global().async {
            var condition=false
if(self.WriteLf.count==8&&self.WriteLr.count==8&&self.WriteRR.count==8&&self.WriteRf.count==8){
    let dateFormat:DateFormatter = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let starttime:String = dateFormat.string(from: Date())
condition=self.act.command.ProgramAll(self.mmynum!,self.WriteLf,self.WriteLr,self.WriteRf,self.WriteRR,self.Lf)
      let endtime:String = dateFormat.string(from: Date())
}else{
    condition=self.act.command.ProgramAll(self.mmynum!, self.Lf)
                }
                DispatchQueue.main.async {
                    self.ISPROGRAMMING=false
                    self.act.back.setImage(UIImage.init(named: "btn_Menu"), for: .normal)
                    for i in 0..<self.act.command.CHANNEL_BLE.count{
                        let a=self.act.command.CHANNEL_BLE[i]
                        if(a.sub(0..<2)=="04"){
                            self.Rrid=a.sub(3..<a.count)
                            if(self.mmynum=="RN1628"||self.mmynum=="SI2048"){
                            let WriteTmp=self.Rrid.sub(0..<2)+"XX"+self.Rrid.sub(4..<6)+"YY"
                            self.Rrid=WriteTmp.replace("XX", self.Rrid.sub(6..<8)).replace("YY", self.Rrid.sub(2..<4))
                            }
                            self.Rrid=String(self.Rrid.suffix(self.idcount))
                            self.UpdateUI(self.RR, self.PROGRAM_SUCCESS)
                        }
                        if(a.sub(0..<2)=="03"){
                            self.Rfid=a.sub(3..<a.count)
                            if(self.mmynum=="RN1628"||self.mmynum=="SI2048"){
                                let WriteTmp=self.Rfid.sub(0..<2)+"XX"+self.Rfid.sub(4..<6)+"YY"
                                self.Rfid=WriteTmp.replace("XX", self.Rfid.sub(6..<8)).replace("YY", self.Rfid.sub(2..<4))
                            }
                            self.Rfid=String(self.Rfid.suffix(self.idcount))
                            self.UpdateUI(self.RF, self.PROGRAM_SUCCESS)
                        }
                        if(a.sub(0..<2)=="02"){
                            self.Lrid=a.sub(3..<a.count)
                            if(self.mmynum=="RN1628"||self.mmynum=="SI2048"){
                                let WriteTmp=self.Lrid.sub(0..<2)+"XX"+self.Lrid.sub(4..<6)+"YY"
                                self.Lrid=WriteTmp.replace("XX", self.Lrid.sub(6..<8)).replace("YY", self.Lrid.sub(2..<4))
                            }
                            self.Lrid=String(self.Lrid.suffix(self.idcount))
                            self.UpdateUI(self.LR, self.PROGRAM_SUCCESS)
                        }
                        if(a.sub(0..<2)=="01"){
                            self.Lfid=a.sub(3..<a.count)
                            if(self.mmynum=="RN1628"||self.mmynum=="SI2048"){
                                let WriteTmp=self.Lfid.sub(0..<2)+"XX"+self.Lfid.sub(4..<6)+"YY"
                                self.Lfid=WriteTmp.replace("XX", self.Lfid.sub(6..<8)).replace("YY", self.Lfid.sub(2..<4))
                            }
                            self.Lfid=String(self.Lfid.suffix(self.idcount))
                            self.UpdateUI(self.LF, self.PROGRAM_SUCCESS)}}
                    self.UpdateUiCondition(self.PROGRAM_SUCCESS)
                    if(!condition){
                        for i in self.act.command.FALSE_CHANNEL{
                            self.UpdateUiCondition(self.PROGRAM_FAULSE)
                            switch(i){
                            case "04":
                                self.Rrid=SetLan.Setlan("error")
                                 self.UpdateUI(self.RR, self.PROGRAM_FAULSE)
                                break
                            case "03":
                                self.Rfid=SetLan.Setlan("error")
                                self.UpdateUI(self.RF, self.PROGRAM_FAULSE)
                                break
                            case "02":
                                self.Lrid=SetLan.Setlan("error")
                                self.UpdateUI(self.LR, self.PROGRAM_FAULSE)
                                break
                            case "01":
                                self.Lfid=SetLan.Setlan("error")
                                self.UpdateUI(self.LF, self.PROGRAM_FAULSE)
                                break
                            default:
                                break
                            } }
                        if(self.act.command.FALSE_CHANNEL.count==0&&self.act.command.BLANK_CHANNEL.count==0){
                            self.UpdateUiCondition(self.PROGRAM_FAULSE)
                            self.UpdateUI(self.LF, self.PROGRAM_FAULSE)
                            self.UpdateUI(self.LR, self.PROGRAM_FAULSE)
                            self.UpdateUI(self.RF, self.PROGRAM_FAULSE)
                            self.UpdateUI(self.RR, self.PROGRAM_FAULSE)
                        }
                    }
                    for a in self.act.command.BLANK_CHANNEL{
                        switch(a){
                        case "04":
                            self.UpdateUI(self.RR, self.UN_LINK)
                            break
                        case "03":
                            self.UpdateUI(self.RF, self.UN_LINK)
                            break
                        case "02":
                             self.UpdateUI(self.LR, self.UN_LINK)
                            break
                        case "01":
                            self.UpdateUI(self.LF, self.UN_LINK)
                            break
                        default:
                            break
                        }  }
                    self.act.back.isEnabled=true
                }
            }
        }
    }
    
    @IBAction func Toidcopy(_ sender: Any) {
        if(WriteRf.count<8){
            PadSelect.Function=0
            let a=peacedefine().PadSelect
            a.act=self.act
            self.act.ChangePage(to: a)
        }
    }
    @IBAction func ToProgram(_ sender: Any) {
        if(WriteRf.count==8){
            PadSelect.Function=1
            let a=peacedefine().PadSelect
            a.act=self.act
            self.act.ChangePage(to: a)
        }
    }
    
    @IBAction func Gorelarm(_ sender: Any) {
        let a=peacedefine().Relarm
        act.ChangePage(to: a)
    }
}
