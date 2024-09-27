//
//  PushNotificationManager.swift
//  iOS-Module
//
//  Created by 이영호 on 9/23/24.
//

import Foundation
import UserNotifications
import UIKit

public class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    public static let shared = PushNotificationManager()
    
    private override init() {}
    
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            } else if granted {
                print("")
            }
        }
    }
    
    public func registerForPushNotificaitons() { // Add_server
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .denied:
                print("User denied notifications.")
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .ephemeral:
                print("error")
            @unknown default:
                break
            }
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { // Add_server - 원격 푸시 알림 등록 성공시 호출, 토근 생성
        let tokenParts = deviceToken.map { data in String(format: "02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { // "" 실패 시 호출, 에러 메시지 전송
           print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Add_server - foreground 상태일 때 알림을 .banner, .sound 형태로 처리
   public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { // foreground 상태, 알람 표시
       completionHandler([.banner, .sound])
   }
   
   // Add_server - 알림 클릭 또는 기타 상호작용을 하였을때, 사용자의 정보를 출력하며 작업 끝 알리기
   public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) { // 사용자가 알림을 클릭하거나 상호작용 했을때, 사용자 정보 가져오기
       let userInfo = response.notification.request.content.userInfo
       print("User tapped notification with info: \(userInfo)")
       completionHandler()
   }
    
    public func scheduleLocalNotification(title: String, body: String, sound: UNNotificationSound, timeInterval: TimeInterval = 5) { // none_server - 알림의 형태 및 반복으로 호출할 것인지 등을 정하고 UNUserNotificationCenter 에 전송
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule local notification: \(error.localizedDescription)")
            } else {
                print("Local notificaiton scheduled: \(title)")
            }
        }
    }
    
    
}
