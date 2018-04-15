//
//  Constants.swift
//  DailyUseWord
//
//  Created by Muhammad Burhan on 10/12/2017.
//  Copyright © 2017 Burhan Mughal. All rights reserved.
//

import UIKit

let languageKey = "language"
let wordsKey    = "words"
let voiceKey    = "voice"

let langEng     = "English"
let langChi     = "中文"
let langPer     = "فارسی"
    
func setDefaultLang(lang:String){
    UserDefaults.standard.set(lang, forKey: languageKey)
}

func setDefaultWord(word:String){
    UserDefaults.standard.set(word, forKey: wordsKey)
}

func setDefaultVoice(voice:String){
    UserDefaults.standard.set(voice, forKey: voiceKey)
}

func getDefaultLang()->String{
    return UserDefaults.standard.value(forKey: languageKey) as! String
}

func getDefaultWord()->String{
    return UserDefaults.standard.value(forKey: wordsKey) as! String
}

func getDefaultVoice()->String{
    return UserDefaults.standard.value(forKey: voiceKey) as! String
}

