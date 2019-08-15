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
        let url = URL(string: "ftp://orangerd:orangetpms@61.221.15.194:21/OrangeTool/Database/SensorCode/SIII/\(s19)/\(GetS19name(s19))")
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
        let url = URL(string: "ftp://orangerd:orangetpms@61.221.15.194:21/OrangeTool/Database/SensorCode/SIII/\(name)/")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                  var ds=String(decoding: data!, as: UTF8.self).split(separator: " ")
                print(String(ds[ds.count-1]).replace("\n","").replace("\r", "")+"ss")
                return String(ds[ds.count-1]).replace("\n","").replace("\r", "")
            }catch{print(error)
                return "false"
            }
        }
        return "false"
    }
    func DowloadMmy(_ deledate:AppDelegate)->Bool{
        let url = URL(string: "ftp://orangerd:orangetpms@61.221.15.194:21/OrangeTool/Database/MMY/EU/\(mmyname())")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                let dst=NSHomeDirectory()+"/Documents/mmytb.db"
                let urlfrompath = URL(fileURLWithPath: dst)
                try data?.write(to: urlfrompath)
                if sqlite3_open(dst, &deledate.db) == SQLITE_OK{
                    print("資料庫開啟成功")
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
        let url = URL(string: "ftp://orangerd:orangetpms@61.221.15.194:21/OrangeTool/Database/MMY/EU/")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                var ds=String(decoding: data!, as: UTF8.self).split(separator: " ")
                print(String(ds[ds.count-1]).replace("\n","").replace("\r", "")+"ss")
                return String(ds[ds.count-1]).replace("\n","").replace("\r", "")
            }catch{print(error)
                return "false"
            }
        }
        return "false"
    }
}
