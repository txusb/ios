//
//  LanguageSetting.swift
//  txusb
//
//  Created by 王建智 on 2019/8/6.
//  Copyright © 2019 王建智. All rights reserved.
//

import UIKit

class LanguageSetting: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    let act=(UIApplication.shared.delegate as! AppDelegate).act!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return item.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
return item[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView.selectedRow(inComponent: 0))
        if(place==0){
            SelectAr.setTitle(item[pickerView.selectedRow(inComponent: 0)], for: .normal)
        }else{
             SelectLa.setTitle(item[pickerView.selectedRow(inComponent: 0)], for: .normal)
        }
    }
 
    @IBOutlet var SelectLa: UIButton!
    @IBOutlet var SelectAr: UIButton!
    @IBOutlet var closebt: UIButton!
    var place=0
    var item=["EU","North America","台灣","中國大陸"]
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var info: UILabel!
    @IBOutlet var lan: UILabel!
    @IBOutlet var area: UILabel!
    @IBOutlet var togive: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        area.text=SetLan.Setlan("Area")
        togive.text=SetLan.Setlan("to_give")
        info.text=SetLan.Setlan("Languages_info")
        lan.text=SetLan.Setlan("Languages")
    }

    @IBAction func SelectLan(_ sender: Any) {
         place=1
    item=["繁體中文","简体中文","Deutsche","English","Italiano"]
        picker.reloadAllComponents()
        picker.isHidden=false
        closebt.isHidden=false
    }
    @IBAction func SelectArea(_ sender: Any) {
        place=0
        item=["EU","North America","台灣","中國大陸"]
        picker.reloadAllComponents()
        picker.isHidden=false
        closebt.isHidden=false
    }
    @IBAction func close(_ sender: Any) {
         picker.isHidden=true
        closebt.isHidden=true
    }
    
    @IBAction func Set(_ sender: Any) {
        if(SelectLa.titleLabel?.text=="Select"){
           return
        }
         if(SelectAr.titleLabel?.text=="Select"){
            return
        }
        ViewController.writeshare(SelectAr.titleLabel!.text!, "Area")
        ViewController.writeshare(SelectLa.titleLabel!.text!, "lan")
        let a=peacedefine().HomePage
        act.changepage(to: a)
    }
}
