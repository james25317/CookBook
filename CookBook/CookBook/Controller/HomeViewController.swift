//
//  ViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/12.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            self.tableView.delegate = self
            
            self.tableView.dataSource = self
        }
    }

    let viewModel = HomeViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()

        // 向 HomeVM 綁定 Box 觀察資料變化(fetch成功後的值)，VC 這邊要做的事情
        viewModel.feedViewModels.bind { [weak self] feeds in
            self?.tableView.reloadData()
        }

        setupTableView()

        // 向 HomeVM 要資料，回傳結果至 Box.value 給其他被綁定的 V
        viewModel.fetchData()
    }

    @IBAction func showTodayPage(_ sender: Any) {
        
        guard let todayVC = UIStoryboard.today
            .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }

        navigationController?.pushViewController(todayVC, animated: true)
    }

    @IBAction func showEditPage(_ sender: Any) {

        guard let editVC = UIStoryboard.edit
            .instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }

        present(editVC, animated: true, completion: nil)
    }

    @IBAction func showProfilePage(_ sender: Any) {

        guard let profileVC = UIStoryboard.profile
            .instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }

        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func setupTableView() {

        tableView.registerCellWithNib(identifier: "FeedTableViewCell", bundle: nil)

        tableView.registerCellWithNib(identifier: "FeedChallengesTableViewCell", bundle: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.feedViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Adding challengeFeedCall logic later on

        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath)
        guard let feedCell = cell as? FeedTableViewCell else { return cell }

        // 匯入VM資料至Cell
        let cellViewModel = self.viewModel.feedViewModels.value[indexPath.item]

        // 這邊定義了 onDead: closure 的觸發行為，當 _ 觸發時，啟動對應行為
        cellViewModel.onDead = { [weak self] in

            print("onDead was activated")
            self?.viewModel.fetchData()

        }

        feedCell.setup(viewModel: cellViewModel)

        return feedCell
    }
}

extension HomeViewController: UITableViewDelegate {
}
