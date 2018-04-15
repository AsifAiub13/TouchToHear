//
//  ViewController.swift
//  DailyUseWord
//
//  Created by Muhammad Burhan on 09/12/2017.
//  Copyright © 2017 Burhan Mughal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var tblButtons: UITableView!
    var colorsArray         =
        [UIColor.init(red: 216/255.0, green: 211/255.0, blue: 188/255.0, alpha: 1.0),UIColor.init(red: 154/255.0, green: 208/255.0, blue: 236/255.0, alpha: 1.0),UIColor.init(red: 140/255.0, green: 127/255.0, blue: 126/255.0, alpha: 1.0),UIColor.init(red: 235/255.0, green: 236/255.0, blue: 166/255.0, alpha: 1.0),UIColor.init(red: 229/255.0, green: 222/255.0, blue: 202/255.0, alpha: 1.0),UIColor.init(red: 164/255.0, green: 42/255.0, blue: 98/255.0, alpha: 1.0),UIColor.init(red: 76/255.0, green: 143/255.0, blue: 42/255.0, alpha: 1.0),UIColor.init(red: 241/255.0, green: 188/255.0, blue: 122/255.0, alpha: 1.0),UIColor.init(red: 167/255.0, green: 116/255.0, blue: 52/255.0, alpha: 1.0),UIColor.init(red: 211/255.0, green: 220/255.0, blue: 108/255.0, alpha: 1.0),UIColor.init(red: 200/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1.0),UIColor.init(red: 203/255.0, green: 37/255.0, blue: 39/255.0, alpha: 1.0),UIColor.init(red: 16/255.0, green: 54/255.0, blue: 106/255.0, alpha: 1.0),UIColor.init(red: 250/255.0, green: 232/255.0, blue: 153/255.0, alpha: 1.0),UIColor.init(red: 214/255.0, green: 178/255.0, blue: 206/255.0, alpha: 1.0),UIColor.init(red: 223/255.0, green: 213/255.0, blue: 202/255.0, alpha: 1.0),UIColor.init(red: 235/255.0, green: 194/255.0, blue: 132/255.0, alpha: 1.0),UIColor.init(red: 230/255.0, green: 221/255.0, blue: 198/255.0, alpha: 1.0),UIColor.init(red: 167/255.0, green: 116/255.0, blue: 52/255.0, alpha: 1.0),UIColor.init(red: 200/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1.0)]
    var titlesArrayEnglish  = ["Kitchen","Restaurant","Supermarket","Men's Wear","Women's Wear","Children's Wear","Hotel","Money","Digital Devices","Picnic","Airport","Anatomy","Medicine","Date & Time","Sport","Transportation","Animals","Family","Conversation","Others"]
    
    var titlesArrayChinese   = ["厨房","餐厅","超市","男士服装","女士服装","儿童服装","酒店","钱","数字设备","野餐","机场","解剖","医学","日期和时间","运动","通运输","动物","家庭","谈话","别人"]
    
    var titlesArrayPersian   = ["آشپزخانه","رستوران","سوپرمارکت","پوشاک آقایان","پوشاک بانوان","پوشاک کودکان","اسکان و اقامت","پول و ارتباطات","وسایل دیجیتال","پیک نیک","فرودگاه","اناتومی و بیماری","پزشکی و دارو","تاریخ و زمان","ورزش","حمل و نقل","حیوانات","خانواده","مکالمه","موارد دیگر"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSettings.layer.cornerRadius = 25
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblButtons.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArrayEnglish.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell") as! ButtonsTableViewCell
        
        buttonsCell.firstButton.backgroundColor     = colorsArray[(indexPath.row * 2)]
        buttonsCell.secondButton.backgroundColor    = colorsArray[(indexPath.row * 2) + 1]
        
        if getDefaultLang() == langEng{
            buttonsCell.firstButton.setTitle(titlesArrayEnglish[indexPath.row * 2], for: .normal)
            buttonsCell.secondButton.setTitle(titlesArrayEnglish[(indexPath.row * 2) + 1], for: .normal)
        }else if getDefaultLang() == langChi{
            buttonsCell.firstButton.setTitle(titlesArrayChinese[indexPath.row * 2], for: .normal)
            buttonsCell.secondButton.setTitle(titlesArrayChinese[(indexPath.row * 2) + 1], for: .normal)
        }else if getDefaultLang() == langPer{
            buttonsCell.firstButton.setTitle(titlesArrayPersian[indexPath.row * 2], for: .normal)
            buttonsCell.secondButton.setTitle(titlesArrayPersian[(indexPath.row * 2) + 1], for: .normal)
        }
        
        buttonsCell.firstButton.layer.cornerRadius  = 10
        buttonsCell.secondButton.layer.cornerRadius = 10
        
        buttonsCell.firstButton.tag = indexPath.row * 2
        buttonsCell.secondButton.tag = (indexPath.row * 2) + 1
        buttonsCell.firstButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        buttonsCell.secondButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        buttonsCell.selectionStyle = .none
        
        return buttonsCell
    }

    @objc func buttonTapped(sender:UIButton){
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
}

