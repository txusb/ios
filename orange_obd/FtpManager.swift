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
        let url = URL(string: "http://35.240.51.141:8077/Database/SensorCode/SIII/\(s19)/\(GetS19name(s19))")
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
        let url = URL(string: "http://35.240.51.141:8077/Database/SensorCode/SIII/\(name)/")
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
        let mmyan=mmyname()
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
        let url = URL(string: "http://35.240.51.141:8077/Database/MMY/EU/\(mmyan)")
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
    func mmyname()->String {
        let url = URL(string: "http://35.240.51.141:8077/Database/MMY/EU/")
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
