//
//  FtpManager.swift
//  txusb
//
//  Created by 王建智 on 2019/7/15.
//  Copyright © 2019 王建智. All rights reserved.
//
//
import UIKit

import SQLite3
class FtpManage{
    func DowloadS19(_ s19:String)->String{
        let s19name=GetS19name(s19)
        SersorRecord.SersorCode_Sersion=s19name
        let url = URL(string: "http://bento2.orange-electronic.com/Orange%20Cloud/Database/SensorCode/SIII/\(s19)/\(s19name)")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                let ds=String(decoding: data!, as: UTF8.self).replace("\r", "").replace("\n", "")
                print(ds)
                return ds
            }catch{print(error)
                return "false"
            }
        }
        return "false"
    }
    func GetS19name(_ name:String) -> String {
        let url = URL(string: "http://bento2.orange-electronic.com/Orange%20Cloud/Database/SensorCode/SIII/\(name)/")
         var data: Data? = nil
              if let anUrl = url {
                  do{
                      try data = Data(contentsOf: anUrl)
                    let ds=String(decoding: data!, as: UTF8.self).components(separatedBy: "HREF=")
                      let filename=ds[2].components(separatedBy: ">")[1].components(separatedBy: "<")[0]
                      print(filename)
                      return filename
                  }catch{print(error)
                      return "false"
                  }
              }
              return "false"
    }
    func DowloadMmy(_ deledate:AppDelegate)->Bool{
        var Area=ViewController.getShare("Area")
        if(Area=="North America"){
            Area="US"
        }else{
            Area="EU"
        }
        let mmyan=mmyname(Area)
        if(mmyan.count>19){SersorRecord.DB_Version=mmyan.sub(16..<mmyan.count)}else{SersorRecord.DB_Version=mmyan}
        if(mmyan==ViewController.getShare("mmy")){
             let dst=NSHomeDirectory()+"/Documents/mmytb.db"
            if sqlite3_open(dst, &deledate.db) == SQLITE_OK{
                print("資料庫開啟成功")
                ViewController.writeshare(mmyan,"mmy")
                return true
            }else{
                print("資料庫開啟失敗")
                deledate.db=nil
                
            }
            }
        print("donload")
        let url = URL(string: "https://bento2.orange-electronic.com/Orange%20Cloud/Database/MMY/\(Area)/\(mmyan)")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                let dst=NSHomeDirectory()+"/Documents/mmytb.db"
                let urlfrompath = URL(fileURLWithPath: dst)
                try data?.write(to: urlfrompath)
                if sqlite3_open(dst, &deledate.db) == SQLITE_OK{
                    print("資料庫開啟成功")
                    ViewController.writeshare(mmyan,"mmy")
                  return true
                }else{
                    print("資料庫開啟失敗")
                    deledate.db=nil
                      return false
                }
            }catch{print(error)
                return false
            }
            
        }
        return false
    }
    func mmyname(_ area:String)->String{
        let url = URL(string: "https://bento2.orange-electronic.com/Orange%20Cloud/Database/MMY/\(area)/")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                let ds=String(decoding: data!, as: UTF8.self).components(separatedBy: "HREF=")
                let filename=ds[2].components(separatedBy: ">")[1].components(separatedBy: "<")[0]
                print(filename)
                return filename
            }catch{print(error)
                return "false"
            }
        }
        return "false"
    }
}
