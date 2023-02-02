//
//  NotificationViewController.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//
import UIKit
import Combine

class NotificationViewController: UIViewController, UITableViewDataSource {

    private var cancellables: Set<AnyCancellable> = []
    let viewModel = NotificationViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    let refreshControl = UIRefreshControl()
    var models: [NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "重新載入")
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        backButton.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        bindUI()
    }

    
    func bindUI() {
        
        viewModel.$refreshing
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] refreshing in
                self.refreshControl.endRefreshing()
            }).store(in: &cancellables)
        
        viewModel.$notificationModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] models in
                self.models = models
                self.tableView.reloadData()
            }).store(in: &cancellables)
        
    }
    
    @objc func refresh() {
        viewModel.refresh()
    }
    
    @objc func clickBack() {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell{
            let model = models[indexPath.row]
            cell.configure(model: model)
            return cell
        } else {
            let cell = UITableViewCell()
         
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    

}
