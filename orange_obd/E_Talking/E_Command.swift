//
//  E_Command.swift
//  txusb
//
//  Created by 王建智 on 2019/10/4.
//  Copyright © 2019 王建智. All rights reserved.
//

import Foundation
class E_Command {
     var admin=""
    func Sendmail(_ ad:String,_ file:String,_ message:String)->Bool{
        do{
            var stream=DataStream()
            stream.SetStream()
            try stream.writeUTF(admin)
            try stream.writeUTF(admin)
            try stream.writeINT(3)
            try stream.writeUTF(ad)
            try stream.writeUTF(file)
            try stream.writeUTF(message)
            if(try stream.ReadInt()==1){return true}else{return false}
        }catch{
            return false
        }
    }
    func Getmail(take:String,it:MessageItem,ad:String)->MessageItem {
        do{
            let originsize=it.admin.count
            let stream=DataStream()
            stream.SetStream()
            try stream.writeUTF(admin)
            try stream.writeUTF(admin)
            try stream.writeINT(2)
            try stream.writeUTF(ad)
            try stream.writeUTF(take)
            var a=try stream.ReadUTf()
            while(a != "完畢"){
                it.add(a, try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf())
                a=try stream.ReadUTf()
            }
            if(originsize==it.admin.count){it.button=true}
            it.success=true
            return it
        }catch{
            it.success=false
            return it
        }
    }
    func GetNewMail(take:String,it:MessageItem,ad:String)->MessageItem {
        do{
            let stream=DataStream()
            stream.SetStream()
            try stream.writeUTF(admin)
            try stream.writeUTF(admin)
            try stream.writeINT(4)
            try stream.writeUTF(ad)
            try stream.writeUTF(take)
            var a=try stream.ReadUTf()
            while(a != "完畢"){
                it.addzero(a, try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf(), try stream.ReadUTf())
                a=try stream.ReadUTf()
            }
            it.success=true
            return it
        }catch{
            it.success=false
            return it
        }
    }
}
