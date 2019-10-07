//
//  ViewController.swift
//  orange_obd
//
//  Created by 王建智 on 2019/7/4.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit
import Lottie
import CoreBluetooth
class ViewController: UIViewController,CBCentralManagerDelegate, CBPeripheralDelegate{
    enum SendDataError: Error {
        case CharacteristicNotFound
    }
    @IBOutlet var rightop: UIButton!
    let delgate=UIApplication.shared.delegate as! AppDelegate
    var IsConnect=false
    var connectblename=""
    var ISRUN=false
    var haveble=false
    @IBOutlet var padicon: UIImageView!
    var bles:[String]=[String]()
    var centralManager: CBCentralManager!
    // 儲存連上的 peripheral，此變數一定要宣告為全域
    var connectPeripheral: CBPeripheral!
    // 記錄所有的 characteristic
    var charDictionary = [String: CBCharacteristic]()
    let C001_CHARACTERISTIC = "8D81"
    
    func isPaired() -> Bool {
        let user = UserDefaults.standard
        if let uuidString = user.string(forKey: "KEY_PERIPHERAL_UUID")
        {
            print("uuid是\(uuidString)")
            let uuid = UUID(uuidString: uuidString)
            let list = centralManager.retrievePeripherals(withIdentifiers: [uuid!])
            if list.count > 0 {
                connectPeripheral = list.first!
                connectPeripheral.delegate = self
                return true
            }
        }
        return false
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // 先判斷藍牙是否開啟，如果不是藍牙4.x ，也會傳回電源未開啟
        guard central.state == .poweredOn else {
            // iOS 會出現對話框提醒使用者
            haveble=false
            return
        }
        haveble=true
        if(isPaired()){
            print("yes")
           unpair()}
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let deviceName = peripheral.name else {
            return
        }
        print("找到藍牙裝置:\(deviceName)")
        if !(bles.contains(deviceName)){bles.append(deviceName)
        }
        guard deviceName.range(of: connectblename) != nil
            else {
                return
        }
        central.stopScan()
        let user = UserDefaults.standard
        user.set(peripheral.identifier.uuidString, forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        connectPeripheral = peripheral
        connectPeripheral.delegate = self
        centralManager.connect(connectPeripheral, options: nil)
        print("最大傳輸單元\( connectPeripheral.maximumWriteValueLength(for: .withResponse))")
    }
    /* 3號method */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 清除上一次儲存的 characteristic 資料
        charDictionary = [:]
        // 將觸發 4號method
        peripheral.discoverServices(nil)
    }
    /* 4號method */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        for service in peripheral.services! {
            // 將觸發 5號method
            connectPeripheral.discoverCharacteristics(nil, for: service)
        }
    }
     /* 5號method */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
         self.IsConnect=false
        for characteristic in service.characteristics! {
            let uuidString = characteristic.uuid.uuidString
            charDictionary[uuidString] = characteristic
            if(uuidString=="8D81"){
                 self.IsConnect=true
                print("yes")
        connectPeripheral.setNotifyValue(true, for: characteristic)
            }
            print(uuidString)
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    /* 將資料傳送到 peripheral */
    func sendData(_ data:String,_ len:Int)  {
        guard let characteristic = charDictionary["8D82"] else {
            print("寫入失敗")
            return
        }
         CheckLen=len
         TmpData=""
         Rx=""
        var Tda=""
        let spi=350
        if(data.count>spi){
            var long=0
    if(data.count%spi==0){long=data.count/spi}else{
                long=data.count/spi+1
            }
            for i in 0..<long{
             let pastTime = Date().timeIntervalSince1970
                while(GetTime(pastTime)<0.05){

                }
                if(i==long-1){
        Tda="87"+data.sub(i*spi..<data.count)+"78"
//      Tda="8702bb78"
                }else{
                    if(i==0){
                        var slon=String(format:"%2X",long).replace(" ", "")
                        if(slon.count<2){slon="0"+slon}
        Tda="87\(slon)"+data.sub(i*spi..<i*spi+spi)
//                        Tda="870\(long)aa"
                    }else{
                Tda="87"+data.sub(i*spi..<i*spi+spi)
//                         Tda="87cc"
                    }
                }
            connectPeripheral.setNotifyValue(true, for: charDictionary[C001_CHARACTERISTIC]!)
connectPeripheral.writeValue(
                    Tda.HexToByte()!,
                    for: characteristic,
                    type: .withoutResponse
                )
print("傳送\(Tda)\n資料長度\(Tda.count)/\(Tda.HexToByte())")
            }
        }else{
print("傳送\(data)\n資料長度\(data.count)/\(data.HexToByte())")
            connectPeripheral.writeValue(
                data.HexToByte()!,
                for: characteristic,
                type: .withoutResponse
            )
//            sleep(1)
//print("傳送87D20402131B0A9978\n資料長度\("87D20402131B0A78".count))")
//            connectPeripheral.writeValue(
//                "87D20402131B0A78".HexToByte()!,
//                for: characteristic,
//                type: .withoutResponse
//            )
        }
    }
    func GetTime(_ timeStamp: Double)-> Double{
        let currentTime = Date().timeIntervalSince1970
        let reduceTime : TimeInterval = currentTime - timeStamp
        return reduceTime
    }
    /* 將資料傳送到 peripheral 時如果遇到錯誤會呼叫 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("寫入資料錯誤: \(error!)")
        }else{
   
        }
    }
    var CheckLen=0
    var TmpData=""
    var Rx=""
    /* 取得 peripheral 送過來的資料 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print(error!)
            return
        }
        let data = characteristic.value
        //            let string = "> " + String(data: data as Data, encoding: .utf8)!
        for i in 0...data!.count-1{
    TmpData=TmpData+String(format:"%02X",data![i])
        }
        if(TmpData.count==CheckLen){Rx=TmpData
         print("---------收到數據ㄦ---------")
        print(Rx)
        }
    }
    /* 斷線處理 */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("連線中斷")
        IsConnect=false
        connectblename=""
        view.showToast(text: "Bluetooth is disconnected")
        let a=peacedefine().HomePage
        changepage(to: a)
        if isPaired() {
            centralManager.connect(connectPeripheral, options: nil)
        }
    }
    /* 解配對 */
    func unpair() {
        let user = UserDefaults.standard
        user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        guard connectPeripheral != nil else {
            return
        }
        centralManager.cancelPeripheralConnection(connectPeripheral)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")
        
        if error != nil {
            print("\(error.debugDescription)")
            return
        }
        if ((characteristic.descriptors) != nil) {
            
            for x in characteristic.descriptors!{
                let descript = x as CBDescriptor?
                print("function name: DidDiscoverDescriptorForChar \(String(describing: descript?.description))")
            }
            
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("--------send-------")
        print()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /////
    
   
    @IBOutlet var tlkingBt: UIButton!
    let deledate = UIApplication.shared.delegate as! AppDelegate
    var timer: Timer?
    var etalk=E_Command()
    @IBOutlet var tit: UILabel!
    @IBOutlet var LoadingView: UIView!
    var selectedPageContainer: UIViewController!
    @IBOutlet var Connectlabel: UILabel!
    let animationView = AnimationView(name: "simple-loader2")
    var Pagememory=[UIViewController]()
    var command=Command()
    @IBOutlet var back: UIButton!
    @IBOutlet var Container: UIView!
        var Selectmake=""
        var Selectmodel=""
        var Selectyear=""
        var directfit=""
    override func viewDidLoad() {
        super.viewDidLoad()
        command.act=self
        print(ViewController.getShare("lan"))
        delgate.act=self
        let queue = DispatchQueue.main
        centralManager = CBCentralManager(delegate: self, queue: queue)
       dowload_mmy()
    if(ViewController.getShare("admin")=="nodata"){
            let a=peacedefine().LanguageSetting
            a.page=1
            changepage(to:a)
        }else{
            let a=peacedefine().HomePage
            changepage(to:a)
        }
       
        animationView.center = self.view.center
        animationView.frame = CGRect(x: animationView.frame.minX, y: animationView.frame.minY+20, width: 200, height: 200)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode=LottieLoopMode.loop
        view.addSubview(animationView)
    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(CheckPlace), userInfo: nil, repeats: true)
        Function.GetVersion()
    }
    func dowload_mmy(){
        self.DataLoading()
        DispatchQueue.global().async {
            let res=FtpManage().DowloadMmy(self.deledate)
            DispatchQueue.main.async {
                if(res){
                    self.pause()
                }else{self.dowload_mmy()}
            }
        }
    }
    var isloading=false
    func play() {
        animationView.center = self.view.center
        animationView.frame = CGRect(x: animationView.frame.minX, y: animationView.frame.minY+20, width: 200, height: 200)
        LoadingView.center = self.view.center
        isloading=true
        LoadingView.isHidden=false
        animationView.isHidden=false
        animationView.play()
    }
    func pause() {
         isloading=false
        animationView.pause()
        LoadingView.isHidden=true
        animationView.isHidden=true
    }
    func goscanner(to newViewController: UIViewController){
        addChild(newViewController)
        self.view.addSubview(newViewController.view)
        newViewController.view.frame = self.view.bounds
        newViewController.didMove(toParent: self)
    }
    func changepage(to newViewController: UIViewController) {
        tlkingBt.isHidden=true
        Pagememory.append(newViewController)
        if selectedPageContainer != nil {
            selectedPageContainer.willMove(toParent: nil)
    selectedPageContainer.view.removeFromSuperview()
            selectedPageContainer.removeFromParent()
        }
        addChild(newViewController)
    self.Container.addSubview(newViewController.view)
        newViewController.view.frame = Container.bounds
        newViewController.didMove(toParent: self)
        self.selectedPageContainer = newViewController
        if(Pagememory.count>=2){
            self.back.isHidden=false
        }
    }

    @IBAction func GoBack(_ sender: Any) {
        if(isloading){return}
        if selectedPageContainer != nil {
            selectedPageContainer.willMove(toParent: nil)
            selectedPageContainer.view.removeFromSuperview()
            selectedPageContainer.removeFromParent()
        }
let newViewController=Pagememory[Pagememory.count-2]
        ;
        addChild(newViewController)
        self.Container.addSubview(newViewController.view)
        newViewController.view.frame = Container.bounds
        newViewController.didMove(toParent: self)
        self.selectedPageContainer = newViewController
        Pagememory.remove(at: Pagememory.count-1)
        if(Pagememory.count<2){
            self.back.isHidden=true
            self.rightop.isHidden=false
            self.ISRUN=false
            self.padicon.isHidden=true
        }
    }
    
    @IBAction func Signout(_ sender: Any) {
        let a=peacedefine().Signout
        a.act=self
        goscanner(to: a)
    }
    func DataLoading(){
       Connectlabel.text=SetLan.Setlan("Data_Loading")
        play()
    }
    func Connecting(){
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        Connectlabel.text=SetLan.Setlan("paired with your device")
        play()
        DispatchQueue.global().async {
            var fal=0
            while(true){
                if(self.IsConnect||fal==10){
                    DispatchQueue.main.async {
                        self.pause()
                        if(self.IsConnect){
                            if(PadSelect.Scanner_OR_Select==0){ let a=peacedefine().QrScanner
                                self.changepage(to: a)}else{
                                let a=peacedefine().SelectMake
                                a.act=self
                                self.changepage(to: a)
                            }
                        }
                        if(fal==10){self.connectblename=""}
                    }
                    break
                }
                sleep(1)
                fal+=1
            }
        }
    }
    @ objc func CheckPlace(){
        if(IsConnect&&ISRUN){padicon.isHidden=false}else{
            padicon.isHidden=true
        }
    }
   
    static func getShare(_ name:String)->String{
        let preferences = UserDefaults.standard
        let currentLevelKey = name
        if preferences.object(forKey: currentLevelKey) == nil {
            return "nodata"
        } else {
            let currentLevel = preferences.string(forKey: currentLevelKey)!
            return currentLevel
        }
    }
  
    static func writeshare(_ name:String,_ key:String){
        let preferences = UserDefaults.standard
        preferences.set(name,forKey: key)
        let didSave = preferences.synchronize()
        if !didSave {
            print("saverror")
        }
}
    @IBAction func ToTalking(_ sender: Any) {
        let a=peacedefine().TalkingActivity
        changepage(to: a)
    }
    
}
