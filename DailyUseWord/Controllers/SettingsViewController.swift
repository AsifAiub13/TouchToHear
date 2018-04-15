//
//  SettingsViewController.swift
//  DailyUseWord
//
//  Created by Muhammad Burhan on 09/12/2017.
//  Copyright © 2017 Burhan Mughal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,SAMenuDropDownDelegate {

    @IBOutlet weak var checkBoxPersian: UIImageView!
    @IBOutlet weak var checkBoxChinese: UIImageView!
    @IBOutlet weak var checkBoxEnglish: UIImageView!
    
    @IBOutlet weak var checkBoxEnglishVoice: UIImageView!
    @IBOutlet weak var checkBoxChineseVoice: UIImageView!
    @IBOutlet weak var checkBoxPersianVoice: UIImageView!
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    
    var dropDownMenu    : SAMenuDropDown! = nil
    var languagesArray  = ["English","中文","فارسی"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDropDown.layer.cornerRadius = 5
        self.btnDropDown.layer.borderColor = UIColor.black.cgColor
        self.btnDropDown.layer.borderWidth = 5
        self.btnLanguage.setTitle(getDefaultLang(), for: .normal)
        
        if getDefaultWord() == langEng{
            self.checkBoxEnglish.image = UIImage.init(named: "checkBox")
            self.checkBoxChinese.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxPersian.image = UIImage.init(named: "checkBoxUn")
        }else if getDefaultWord() == langChi{
            self.checkBoxEnglish.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxChinese.image = UIImage.init(named: "checkBox")
            self.checkBoxPersian.image = UIImage.init(named: "checkBoxUn")
        }else if getDefaultWord() == langPer{
            self.checkBoxEnglish.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxChinese.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxPersian.image = UIImage.init(named: "checkBox")
        }
        
        if getDefaultVoice() == langEng{
            self.checkBoxEnglishVoice.image = UIImage.init(named: "checkBox")
            self.checkBoxChineseVoice.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxPersianVoice.image = UIImage.init(named: "checkBoxUn")
        }else if getDefaultVoice() == langChi{
            self.checkBoxEnglishVoice.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxChineseVoice.image = UIImage.init(named: "checkBox")
            self.checkBoxPersianVoice.image = UIImage.init(named: "checkBoxUn")
        }else if getDefaultVoice() == langPer{
            self.checkBoxEnglishVoice.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxChineseVoice.image = UIImage.init(named: "checkBoxUn")
            self.checkBoxPersianVoice.image = UIImage.init(named: "checkBox")
        }
    }

    @IBAction func btnLanguageTapped(_ sender: UIButton) {
        if dropDownMenu != nil {
            dropDownMenu.isHidden = true
            dropDownMenu = nil
            return
        }
        createAndShowDropDown(sender: sender)
    }
    
    //MARK:- DROPDOWN
    func createAndShowDropDown(sender:Any){
        dropDownMenu = SAMenuDropDown.init(source: sender as! UIButton, menuHeight: 132, itemName: languagesArray)
        dropDownMenu.showSADropDownMenu(withAnimation: kSAMenuDropAnimationDirectionBottom)
        dropDownMenu.delegate = self
        self.view.bringSubview(toFront: dropDownMenu)
    }
    
    func saDropMenu(_ menuSender: SAMenuDropDown!, didClickedAt buttonIndex: Int) {
        btnLanguage.setTitle(languagesArray[buttonIndex], for: .normal)
        setDefaultLang(lang: languagesArray[buttonIndex])
    }
    
    @IBAction func btnWordsTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            checkBoxEnglish.image = UIImage.init(named: "checkBox")
            checkBoxChinese.image = UIImage.init(named: "checkBoxUn")
            checkBoxPersian.image = UIImage.init(named: "checkBoxUn")
            setDefaultWord(word: langEng)
            break
        case 1:
            checkBoxEnglish.image = UIImage.init(named: "checkBoxUn")
            checkBoxChinese.image = UIImage.init(named: "checkBox")
            checkBoxPersian.image = UIImage.init(named: "checkBoxUn")
            setDefaultWord(word: langChi)
            break
        case 2:
            checkBoxEnglish.image = UIImage.init(named: "checkBoxUn")
            checkBoxChinese.image = UIImage.init(named: "checkBoxUn")
            checkBoxPersian.image = UIImage.init(named: "checkBox")
            setDefaultWord(word: langPer)
            break
        default:
            break
        }
    }
    
    @IBAction func btnVoiceTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            checkBoxEnglishVoice.image = UIImage.init(named: "checkBox")
            checkBoxChineseVoice.image = UIImage.init(named: "checkBoxUn")
            checkBoxPersianVoice.image = UIImage.init(named: "checkBoxUn")
            setDefaultVoice(voice: langEng)
            break
        case 1:
            checkBoxEnglishVoice.image = UIImage.init(named: "checkBoxUn")
            checkBoxChineseVoice.image = UIImage.init(named: "checkBox")
            checkBoxPersianVoice.image = UIImage.init(named: "checkBoxUn")
            setDefaultVoice(voice: langChi)
            break
        case 2:
            checkBoxEnglishVoice.image = UIImage.init(named: "checkBoxUn")
            checkBoxChineseVoice.image = UIImage.init(named: "checkBoxUn")
            checkBoxPersianVoice.image = UIImage.init(named: "checkBox")
            setDefaultVoice(voice: langPer)
            break
        default:
            break
        }
    }
    
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
