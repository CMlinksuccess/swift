//
//  AppDelegate.swift
//  LearnSwift
//
//  Created by ECOOP－09 on 16/8/4.
//  Copyright © 2016年 ECOOP－09. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewCtrol:ViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame:UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.viewCtrol = ViewController.init()
        
        self.window?.rootViewController = self.viewCtrol
        self.window?.makeKeyAndVisible()
  
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
//        ShareSDK.registerApp("17174ab640504",
 //                            activePlatforms :
 //           [
               
 //               SSDKPlatformType.typeCopy.rawValue,
//                SSDKPlatformType.typeMail.rawValue,
//                SSDKPlatformType.typeSMS.rawValue

 //           ],
                             // onImport 里的代码,需要连接社交平台SDK时触发
 //           onImport: {(platform : SSDKPlatformType) -> Void in
//                switch platform
//                {
//                case SSDKPlatformType.TypeSinaWeibo:
//                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
//
//                default:
//                    break
//                }
//            },
//            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//                switch platform
//                {
//                case SSDKPlatformType.TypeSinaWeibo:
//                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                    appInfo.SSDKSetupSinaWeiboByAppKey("2086533852",
//                        appSecret : "75bddd3a5326965b94247b594d2b39b2",
//                        redirectUri : "https://api.weibo.com/oauth2/default.html",
//                        authType : SSDKAuthTypeWeb)
//                    
//                default:
//                    break
//                }
//        })
  
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

