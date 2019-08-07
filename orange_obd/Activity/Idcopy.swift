//
//  Idcopy.swift
//  orange_obd
//
//  Created by 王建智 on 2019/7/5.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit
import SQLite3
class Idcopy: UIViewController,UITextFieldDelegate {
let act=(UIApplication.shared.delegate as! AppDelegate).act!
    @IBOutlet var lft: UITextField!
    @IBOutlet var Rft: UITextField!
let deledate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var Rrt: UITextField!
    @IBOutlet var Lrt: UITextField!
    var mmynum:String!=nil
     let placeholserAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
    @IBOutlet var Next: UIButton!
    @IBOutlet var tit: UILabel!
    @IBOutlet var toptitle: UILabel!
    var first=true
    var idcount=8
    override func viewDidDisappear(_ animated: Bool) {
        first=false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        first=true
        query()
toptitle.text="\(act.Selectmake)/\(act.Selectmodel)/\(act.Selectyear)"
        tit.text=SetLan.Setlan("Key_in_the_original_sensor_ID_number")
         lft.attributedPlaceholder = NSAttributedString(string: "LF ID Number",attributes: placeholserAttributes)
         Rft.attributedPlaceholder = NSAttributedString(string: "RF ID Number",attributes: placeholserAttributes)
         Lrt.attributedPlaceholder = NSAttributedString(string: "LR ID Number",attributes: placeholserAttributes)
         Rrt.attributedPlaceholder = NSAttributedString(string: "RR ID Number",attributes: placeholserAttributes)
         lft.delegate = self
         Rft.delegate = self
         Lrt.delegate = self
         Rrt.delegate = self
        dowloadmmy()
        Next.setTitle(SetLan.Setlan("Next"), for: .normal)
        DispatchQueue.global().async {
            self.UdCondition()
        }
    }
    func dowloadmmy(){
        act.DataLoading()
        DispatchQueue.global().async {
            let a=FtpManage().DowloadS19(self.mmynum!)
            DispatchQueue.main.async {
                if(a=="false"){
                    self.dowloadmmy()
                }else{
                    self.act.pause()
                    self.act.command.mmydata=a
                }
            }
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string.count)
        let aSet = NSCharacterSet(charactersIn:"0123456789abcdef").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if(string == numberFiltered&&(textField.text!+string).count<=idcount){
             return true
        }else{
            return false
        }
    }
    
    @IBAction func next(_ sender: Any) {
         var lf=lft.text!
         var Rf=Rft.text!
         var Rr=Rrt.text!
         var lr=Lrt.text!
        if(!lft.isEnabled){lf="00000000"}
        if(!Rft.isEnabled){Rf="00000000"}
        if(!Rrt.isEnabled){Rr="00000000"}
        if(!Lrt.isEnabled){lr="00000000"}
        if(lf.count<idcount){
            view.showToast(text: SetLan.Setlan("ID_code_should_be_8_characters").replace("8", "\(idcount)"))
             return
        }
        if(Rf.count<idcount){
               view.showToast(text: SetLan.Setlan("ID_code_should_be_8_characters").replace("8", "\(idcount)"))
            return
        }
        if(lr.count<idcount){
            view.showToast(text: SetLan.Setlan("ID_code_should_be_8_characters").replace("8", "\(idcount)"))
             return
        }
        if(Rr.count<idcount){
               view.showToast(text: SetLan.Setlan("ID_code_should_be_8_characters").replace("8", "\(idcount)"))
             return
        }
         let a=peacedefine().Program
        a.WriteRR=insert(Rrt.text!)
         a.WriteLf=insert(lft.text!)
         a.WriteLr=insert(Lrt.text!)
         a.WriteRf=insert(Rft.text!)
        act.changepage(to: a)
    }
    func queryid(){
        if deledate.db != nil {
            let sql="select `count` from idcopy where s19='\(mmynum!)'"
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
    func query(){
        if deledate.db != nil {
            let sql="select distinct `Orangepart(ProgramName)` from mmy_table where Make='\(act.Selectmake)' and Model='\(act.Selectmodel)' and year='\(act.Selectyear)'"
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
                    queryid()
                } }  } }
    func insert(_ a:String)->String{
        var tmp=a
        while(tmp.count<8){
            tmp="0"+tmp
        }
        if(mmynum=="RN1628"||mmynum=="SI2048"){
            let Writetmp=tmp.sub(0..<2)+"XX"+tmp.sub(4..<6)+"YY"
            return Writetmp.replace("XX", tmp.sub(6..<8)).replace("YY",tmp.sub(2..<4))
        }
        
        return tmp.uppercased()
    }
    
    @IBAction func toprogram(_ sender: Any) {
        PadSelect.Function=1
        let a=peacedefine().PadSelect
        a.act=self.act
        self.act.changepage(to: a)
    }
    func UdCondition(){
        DispatchQueue.global().async {
            for i in 0...1{
                let CH1=self.act.command.Command11(i, 1)
                let CH2=self.act.command.Command11(i, 2)
                DispatchQueue.main.async {
                    if(CH1){
                        if(i==0){
                           self.lft.isEnabled=true
                            self.lft.attributedPlaceholder = NSAttributedString(string: "LF ID Number",attributes: self.placeholserAttributes)
                        }else{
                            self.Rft.isEnabled=true
                            self.Rft.attributedPlaceholder = NSAttributedString(string: "RF ID Number",attributes: self.placeholserAttributes)
                        }
                    }else{
                        if(i==0){
                            self.lft.isEnabled=false
                            self.lft.text=""
                            self.lft.attributedPlaceholder = NSAttributedString(string: SetLan.Setlan("Unlinked"),attributes: self.placeholserAttributes)
                        }else{
                            self.Rft.isEnabled=false
                            self.Rft.text=""
                            self.Rft.attributedPlaceholder = NSAttributedString(string: SetLan.Setlan("Unlinked"),attributes: self.placeholserAttributes)
                        }
                    }
                    if(CH2){
                        if(i==0){
                            self.Lrt.isEnabled=true
                            self.Lrt.attributedPlaceholder = NSAttributedString(string: "LR ID Number",attributes: self.placeholserAttributes)
                        }else{
                            self.Rrt.isEnabled=true
                            self.Rrt.attributedPlaceholder = NSAttributedString(string: "RR ID Number",attributes: self.placeholserAttributes)
                        }
                    }else{
                        if(i==0){
                            self.Lrt.isEnabled=false
                            self.Lrt.text=""
                            self.Lrt.attributedPlaceholder = NSAttributedString(string: SetLan.Setlan("Unlinked"),attributes: self.placeholserAttributes)
                        }else{
                            self.Rrt.isEnabled=false
                            self.Rrt.text=""
                            self.Rrt.attributedPlaceholder = NSAttributedString(string: SetLan.Setlan("Unlinked"),attributes: self.placeholserAttributes)
                        }
                    }
                }
            }
            sleep(4)
            if(self.first){
                self.UdCondition()}
        }
    }
}
