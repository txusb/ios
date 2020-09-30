//
//  DonloadFile.swift
//  txusb
//
//  Created by Jianzhi.wang on 2020/3/16.
//  Copyright © 2020 王建智. All rights reserved.
//

import Foundation
import JzIos_Framework
import JzOsSqlHelper
import Foundation
import JzOsTool
import Alamofire
public class DonloadFile{
    
    public static  var url="http://bento2.orange-electronic.com/Orange%20Cloud/Beta"
    public static func dataloading(){
        if(JzActivity.getControlInstance.getPro("Beta","false")=="true"){
            print("為beta")
            DonloadFile.url="http://bento2.orange-electronic.com/Orange%20Cloud/Beta"
        }else{
            print("佈為beta")
            DonloadFile.url="http://bento2.orange-electronic.com/Orange%20Cloud"
        }
        let a=Progress()
        a.label=a.資料載入
        JzActivity.getControlInstance.openDiaLog(a,true,"Progress")
        let sql=SqlHelper("mmy.db")
        if(JzActivity.getControlInstance.getPro("dataloading", "false") != "false"){
            sql.autoCreat()
            PublicBeans.資料庫=sql
            JzActivity.getControlInstance.closeDialLog()
            return
        }
        DispatchQueue.global().async {
            //            if(!downAllobd()){dataloading()}
            if(!downAllS19()){DispatchQueue.main.async {dataloading()
                }
                return
            }
            print("下載s19成功")
            let mmy=mmyname()
            if(mmy==nil){
                DispatchQueue.main.async {dataloading()
                }
                return
            }else{
                sql.initByUrl(mmy!,{
                    result in
                    if(result){
                        print("資料庫開啟成功")
                        PublicBeans.資料庫=sql
                        JzActivity.getControlInstance.setPro("mmy", mmy!)
                        JzActivity.getControlInstance.setPro("dataloading", "true")
                        DispatchQueue.main.async {
                            JzActivity.getControlInstance.setPro("update", "nodata")
                            JzActivity.getControlInstance.closeDialLog()
                        }
                    }else{
                        DispatchQueue.main.async {
                            print("資料庫開啟失敗")
                            dataloading()
                            return
                        }
                    }
                })
            }
        }
    }
    public static func mmyname()->String?{
        let Area=JzActivity.getControlInstance.getPro("Area", "EU")
        let url = URL(string: "\(DonloadFile.url)/Database/MMY/\(Area)/")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                let ds=String(decoding: data!, as: UTF8.self).components(separatedBy: "HREF=")
                let filename=ds[2].components(separatedBy: ">")[1].components(separatedBy: "<")[0]
                print(filename)
                return "\(DonloadFile.url)/Database/MMY/\(Area)/\(filename)"
                
            }catch{print(error)
                return nil
            }
        }
        return nil
    }
    public static func progress(_ pro:Int){
        DispatchQueue.main.async {
            JzActivity.getControlInstance.closeDialLog()
            let a=Progress()
            a.label="\(a.資料載入)...\(pro)%"
            JzActivity.getControlInstance.openDiaLog(a,true,"Progress")
        }
    }
    public static func downAllS19()->Bool{
        PublicBeans.OBD資料庫.exSql("CREATE TABLE if not exists `s19` ( name VARCHAR, data TEXT);")
        let a = JzOSTool.http().listHttpFile("http://35.240.51.141:8077", "/Database/SensorCode/SIII/")
        if a != nil{
            print("s19數量:\(a!.count)")
            for i in 0..<a!.count{
                print("下載中:\(a![i])")
                if(!self.downs19(a![i])){
                    return false}
                progress(i*100/a!.count)
            }
        }else{
            print("失敗")
            return false
        }
        return true
    }
    public static func downs19(_ name:String)->Bool{
        if(name.isEmpty){return true}
        print("下載file:\(name)")
        let a=JzOSTool.http().listHttpFile("http://35.240.51.141:8077", "/Database/SensorCode/SIII/\(name)/")
        if let dir=a{
            print("dir.count:\(dir.count)")
            if(dir.count>0){
                if(JzActivity.getControlInstance.getPro(name, "nodata")==dir[1]){return true}
                let file=JzOSTool.http().getFileText("http://35.240.51.141:8077/Database/SensorCode/SIII/\(name)/\(dir[1])")
                print("data:\(file)")
                if file != nil{
                    PublicBeans.OBD資料庫.exSql("delete from `s19` where name='\(name)'")
                    PublicBeans.OBD資料庫.exSql("insert into `s19` (name,data) values ('\(name)','\(file!.replace("\r\n", ""))')")
                    JzActivity.getControlInstance.setPro(name,dir[1])
                    print("下載檔案","\(file!.replace("\r\n", ""))")
                    return true
                }else{
                    print("失敗")
                }
            }
        }
        return false
    }
    
 
}
