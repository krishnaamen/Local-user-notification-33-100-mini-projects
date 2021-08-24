//
//  ViewController.swift
//  Local-notification
//
//  Created by Macbook on 23/08/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    var notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            if granted{
                self.notificationCenter.delegate = self
            }
        }
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    @objc
    func dateChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let date = dateFormatter.string(from: datePicker.date)
        dateLabel.text = date
        
    }

    @IBAction func notificationPressed(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Hello guys!!"
        content.subtitle = "This is the notification of Krishna Khanal"
        content.body = "In this notification we give information to the user"
        content.sound = .default
        content.badge = 1
        // add image to notification
        let url = Bundle.main.url(forResource: "shuva", withExtension: "png")
        let attachment = try! UNNotificationAttachment(identifier: "shuva", url: url!, options: [:])
        content.attachments = [attachment]
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = "idfr"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) {error in
            if error != nil{
                print(error?.localizedDescription ?? "Noti error")
            }
        }
        let like = UNNotificationAction.init(identifier: "Like", title: "Like", options: .foreground)
        let delete = UNNotificationAction.init(identifier: "Delete", title: "Delete", options: .destructive)
        let category = UNNotificationCategory.init(identifier: content.categoryIdentifier, actions: [delete,like], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
        
        
        
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.badge,.sound])
        //        if #available(iOS 14.0, *) {
        //            completionHandler([.list, .banner, .sound, .badge])
        //        } else {
        //            completionHandler([.alert, .sound, .badge])
        //        }
    }
    
    
    @IBAction func btnSegmentTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            datePicker.preferredDatePickerStyle = .inline
        case 1:
            datePicker.preferredDatePickerStyle = .wheels
        default:
            datePicker.preferredDatePickerStyle = .compact
        }
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController{
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    
}

