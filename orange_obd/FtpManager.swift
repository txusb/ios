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
        let url = URL(string: "ftp://orangetpms:12345678@61.221.15.194:21/orangetpms/s19file/\(s19).s19")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                var ds=String(decoding: data!, as: UTF8.self).replace("\r", "").replace("\n", "")
                print(ds)
                return ds
            }catch{print(error)
                return "false"
            }
        }
        return "false"
    }
    func DowloadMmy(_ deledate:AppDelegate)->Bool{
        let url = URL(string: "ftp://orangetpms:12345678@61.221.15.194:21/orangetpms/mmytable/usb_tx_mmy.db")
        var data: Data? = nil
        if let anUrl = url {
            do{
                try data = Data(contentsOf: anUrl)
                let fm=FileManager.default
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
}
