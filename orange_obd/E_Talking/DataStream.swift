//
//  DataStream.swift
//  ClientSocket
//
//  Created by 王建智 on 2019/10/4.
//  Copyright © 2019 KoKang Chu. All rights reserved.
//

import Foundation
class DataStream{
    var iStream: InputStream? = nil
    var oStream: OutputStream? = nil
    enum customError : Error{
        case readerror
    }
    func SetStream(){
        let _ = Stream.getStreamsToHost(withName: "35.240.51.141", port: 5021, inputStream: &iStream, outputStream: &oStream)
        iStream?.open()
        oStream?.open()
    }
    func writeINT(_ int:Int)throws{
 var alldata=Array(repeating: UInt8(0), count: 4)
        var tmpint=int
        alldata[0]=UInt8(int/256/256/256)
        alldata[1]=UInt8((int%(256*256*256))/256/256)
        alldata[2]=UInt8((int%(256*256))/256)
        alldata[3]=UInt8(int%256)
        let writesize=oStream?.write(alldata, maxLength: alldata.count)
        if(writesize != alldata.count){ throw customError.readerror}
    }
    func writeUTF(_ string: String)throws{
        let data = string.data(using: .utf8)!
        let buf=[UInt8](data)
        var alldata=Array(repeating: UInt8(0), count: 2)
        alldata[0]=UInt8(buf.count/256)
        alldata[1]=UInt8(buf.count%256)
        alldata += buf
        let writesize=oStream?.write(alldata, maxLength: alldata.count)
        if(writesize != alldata.count){ throw customError.readerror}
    }
    func ReadUTf()throws ->String{
        var buf=Array(repeating: UInt8(255), count: 2)
        let tmp=iStream?.read(&buf, maxLength: 2)
        if(tmp==0){ throw customError.readerror}else{
            let long=Int(buf[0])*256+Int(buf[1])
            buf=Array(repeating: UInt8(255), count: 0)
            var readsize=0
            while(readsize<long){
              var buf2=Array(repeating: UInt8(0), count: 1)
                let readcount=iStream!.read(&buf2, maxLength: 1)
                readsize += readcount
                if(readcount==1){buf += buf2}
            }
            let data=Data(bytes: buf, count: long)
            let string = String(decoding: data, as: UTF8.self)
            print(string)
            return string.replace("������", "�")
        }
    }
    func ReadInt()throws ->Int{
        var buf = Array(repeating: UInt8(0), count: 4)
         let tmp=iStream?.read(&buf, maxLength: 4)
        if(tmp==4){
           let int=Int(buf[0])*256*256*256+Int(buf[1])*256*256+Int(buf[2])*256+Int(buf[3])
            return int
        }else{throw customError.readerror}
    }
    func ReadData(){
          var buf = Array(repeating: UInt8(255), count: 1024)
//        buf.append(UInt8(9))
        if let n = iStream?.read(&buf, maxLength: 1024) {
            print(n)
            print(buf)
            print(Int(buf[0]))
        }
    }
}
