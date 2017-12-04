//
//  LocalizationManager.swift
//
//
//  Created by MileyLiu on 8/11/17.
//

//
//import UIKit
//
//
//func LocalizedString(_ key:String) -> String {
//
//    return LocalizationManager.shareManger.localizedString(key)
//}
//
//class LocalizationManager: NSObject {
//    var bundle:Bundle?
//
//    static let shareManger:LocalizationManger = {
//
//        let instance = LocalizationManger()
//        return instance
//    }()
//
//    override init() {
//
//        super.init()
//
//        initLangage()
//    }
//
//    func setUserLanguage(language:String) {
//
//        UserDefaults.standard.setValue(language, forKey: "UserLanguage")
//        UserDefaults.standard.synchronize()
//
//        let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj")
//
//        bundle = Bundle.init(path: bundlePath!)
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangedUserLanguageNotification"), object: language)
//
//    }
//    class func reloadRootViewControlle() {
//
//        let delegate = UIApplication.shared.delegate!
//
//        let tabbarVc = UITabBarController()
//
//        delegate.window??.rootViewController = tabbarVc
//    }
//
//    fileprivate func localizedString(_ key: String) -> String {
//
//        return LanguageHelper.getString(key: key, tableName: "", bundle: bundle!, value: "")
//    }
//
//    func initLangage() {
//
//        if let userLanguage = UserDefaults.standard.value(forKey: "UserLanguage") as? String   {
//
//            let bundlePath = Bundle.main.path(forResource: userLanguage, ofType: "lproj")
//
//            bundle = Bundle.init(path: bundlePath!)
//
//        }else {
//
//            var language = NSLocale.preferredLanguages.first
//
//            UserDefaults.standard.setValue(language, forKey: "UserLanguage")
//
//            if (language == "zh-Hans-HK") || (language == "zh-Hans-CN") || (language == "zh-Hans") || (language == "zh-Hans-US") {
//
//                language = "zh-Hans"
//
//            }else if language == "zh-HK" || language == "zh-Hant-CN" || language == "zh-Hant" {
//
//                language = "zh-Hant"
//
//            }else {
//
//                language = "en"
//            }
//
//            UserDefaults.standard.setValue(language, forKey: "UserLanguage")
//            UserDefaults.standard.synchronize()
//
//            let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj")
//
//            bundle = Bundle.init(path: bundlePath!)
//        }
//
//    }
//
//}
//
//
//
