//
//  Relarm.swift
//  txusb
//
//  Created by 王建智 on 2019/8/7.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit
import SQLite3
class Relarm: UIViewController {
let deledate = UIApplication.shared.delegate as! AppDelegate
       let activity=(UIApplication.shared.delegate as! AppDelegate).act!
    var position=0
    @IBOutlet var relarlmtext: UITextView!
    @IBOutlet var menu: UIButton!
    @IBOutlet var toper: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        toper.text="\(activity.Selectmake)/\(activity.Selectmodel)/\(activity.Selectyear)"
        if(position==0){    menu.setTitle(SetLan.Setlan("MENU"), for: .normal)}else{    menu.setTitle(SetLan.Setlan("Next"), for: .normal)}
        query()
    }
    
    @IBAction func Gomenu(_ sender: Any) {
        if(position==0){
            let a=peacedefine().HomePage
            activity.ChangePage(to: a)
        }else{
            if(PadSelect.Function==0){
                let a=peacedefine().Idcopy
                activity.ChangePage(to: a)
            }else{
                let a=peacedefine().Program
                activity.ChangePage(to: a)
            }
        }
    }
    func query(){
        if deledate.db != nil {
             let a=ViewController.getShare("lan")
            var colume="Relearn Procedure (English)"
            switch(a){
            case "English":
                colume="Relearn Procedure (English)"
                break
            case "繁體中文":
                 colume="Relearn Procedure (Traditional Chinese)"
                break
            case "简体中文":
                 colume="Relearn Procedure (Jane)"
                break
            case "Deutsch":
                 colume="Relearn Procedure (German)"
                break
            case "Italiano":
                 colume="Relearn Procedure (Italian)"
                break
            default:
                break;
            }
            let sql="select `\(colume)` from `Summary table` where make='\(activity.Selectmake)' and model='\(activity.Selectmodel)' and year='\(activity.Selectyear)' limit 0,1"
            var statement:OpaquePointer? = nil
            if sqlite3_prepare(deledate.db,sql,-1,&statement,nil) != SQLITE_OK{
                let errmsg=String(cString:sqlite3_errmsg(deledate.db))
                print(errmsg)
            }
            while sqlite3_step(statement)==SQLITE_ROW{
                let iid = sqlite3_column_text(statement,0)
                if iid != nil{
                    var iids = String(cString: iid!)
            if(iids.count==0){iids=SetLan.Setlan("norelarm")}
                    let paraph = NSMutableParagraphStyle()
                    paraph.lineSpacing = 10
                    let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18),
                                      NSAttributedString.Key.paragraphStyle: paraph]
                    relarlmtext.attributedText = NSAttributedString(string: iids, attributes: attributes)
                    print("s19:\(iids)")
                } }  } }
}
