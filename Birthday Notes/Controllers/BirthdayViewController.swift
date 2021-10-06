//
//  BirthdayViewController.swift
//  Birthday Notes
//
//  Created by mac on 06.10.2021.
//

import UIKit
import RealmSwift

class BirthdayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    private let realm = try! Realm()
    private lazy var items: Results<RealmModel>! = {
        self.realm.objects(RealmModel.self).sorted(byKeyPath: "name", ascending: true)
    }()
    
    private lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        tableView.register(BirthdayTableViewCell.self,
                           forCellReuseIdentifier: BirthdayTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupView()
        setupNavigationController()
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func setupNavigationController() {
        title = "Birthday Note"
        let rightButtonItem = UIBarButtonItem.init(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]
    }
    
    @objc private func rightButtonAction(sender: UIBarButtonItem) {
        let detailViewController = AddBirthdayViewController()
        self.navigationController?.pushViewController(detailViewController,
                                                      animated: true)
    }
    
    private func setupView() {
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            setEmptyMessage("To add a birthday, click 'Add' in the upper right corner")
        } else {
            setEmptyMessage("")
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayTableViewCell.identifier,
                                                 for: indexPath) as! BirthdayTableViewCell
        let item = BirthdayCellViewModel(items[indexPath.row])
        cell.fill(item: item)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        
        if editingStyle == .delete {
            if let identifier = item.id as String? {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers:
                                                            [identifier])
            }
            try! self.realm.write {
                self.realm.delete(item)
            }
            tableView.reloadData()
            return
        }
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension BirthdayViewController {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: view.frame.size.width,
                    height: view.frame.size.width)
            )
        )
        messageLabel.frame = view.bounds
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 19)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
}
