//
//  AddBirthdayViewController.swift
//  Birthday Notes
//
//  Created by mac on 06.10.2021.
//

import UIKit
import RealmSwift

class AddBirthdayViewController: UIViewController {
    // MARK: - Properties
    private let realmModel = RealmModel()
    private let notificationCenter = UNUserNotificationCenter.current()
    // MARK: - Views
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Surname"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday Date"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.placeholder = " Enter your name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.placeholder = " Enter your surname"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        title = "Detail Birthday"
        let rightButtonItem = UIBarButtonItem.init(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]
    }
    
    @objc private func rightButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        setBirthday()
        sendNotificationEveryYear()
    }
    
    private func setBirthday() {
        realmModel.id = UUID().uuidString
        realmModel.name = nameTextField.text ?? ""
        realmModel.surname = surnameTextField.text ?? ""
        realmModel.birthdayDate = datePicker.date
        
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(realmModel)
        }
    }
    
    private func sendNotificationEveryYear() {
        let content = UNMutableNotificationContent()
        content.title = "Birthday Note"
        content.body = "Today \(realmModel.name) \(realmModel.surname) is celebrating his birthday🥳🎉 Don't forget to congratulate him 🎁"
        content.sound = UNNotificationSound.default
        
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: realmModel.birthdayDate)
        //        dateComponents.hour = 8
        dateComponents.hour = 19
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        if let identifier = realmModel.id as String? {
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger
            )
            notificationCenter.add(request, withCompletionHandler: nil)
        }
    }
    private func setupViews() {
        view.addSubview(nameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(dateLabel)
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -245),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 340),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -205),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 350),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            surnameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -145),
            surnameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surnameLabel.widthAnchor.constraint(equalToConstant: 340),
            surnameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            surnameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -105),
            surnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surnameTextField.widthAnchor.constraint(equalToConstant: 350),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -45),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 300),
            dateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -5),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            datePicker.widthAnchor.constraint(equalToConstant: 300),
            datePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
        view.backgroundColor = .systemGroupedBackground
    }
}

extension AddBirthdayViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
        print(#function)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(#function)
    }
}
