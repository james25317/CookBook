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

    lazy var searchBar: UISearchBar = {

        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

        return searchBar
    }()

    // MARK: view lifecycle
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

        self.navigationController?.navigationBar.shadowImage = image
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // 向 HomeVM 綁定 Box 觀察資料變化(fetch成功後的值)，VC 這邊要做的事情
        viewModel.feedViewModels.bind { [weak self] _ in

            self?.tableView.reloadData()
        }

        // 要 Feeds 資料
        viewModel.fetchFeedsData()

        // Nib - 暫時屏蔽
        //setupTableView()

        // 搜尋欄 - 暫時屏蔽
        // setupSearchBar()
    }

    @IBAction func goTodayPage(_ sender: Any) {
        
        guard let todayVC = UIStoryboard.today
            .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }

        navigationController?.pushViewController(todayVC, animated: true)
    }

    @IBAction func goEditPage(_ sender: Any) {

        guard let editVC = UIStoryboard.edit
            .instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }

        navigationController?.pushViewController(editVC, animated: true)
    }

    @IBAction func goProfilePage(_ sender: Any) {

        guard let profileVC = UIStoryboard.profile
            .instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }

        navigationController?.pushViewController(profileVC, animated: true)
    }

    private func setupTableView() {

        tableView.registerCellWithNib(

            identifier: String(describing: FeedTableViewCell.self),
            bundle: nil
        )

        tableView.registerCellWithNib(

            identifier: String(describing: FeedChallengesTableViewCell.self),
            bundle: nil)
    }

    private func setupSearchBar() {

        searchBar.placeholder = "Search"

        searchBar.sizeToFit()

        let leftNavBarButton = UIBarButtonItem(customView: searchBar)

        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.feedViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellViewModel = self.viewModel.feedViewModels.value[indexPath.row]

        if cellViewModel.isChallenged == false {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FeedChallengesTableViewCell.self),
                for: indexPath
            )

            // 生成 ChallengeFeeds
            guard let feedChallengeCell = cell as? FeedChallengesTableViewCell else { return cell }

            feedChallengeCell.setup(viewModel: cellViewModel)

            return feedChallengeCell
        } else {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FeedTableViewCell.self),
                for: indexPath
            )

            // 生成 NormalFeeds
            guard let feedCell = cell as? FeedTableViewCell else { return cell }

            feedCell.setup(viewModel: cellViewModel)

            return feedCell
        }
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        let cellViewModel = self.viewModel.feedViewModels.value[indexPath.row]

        // 判斷是否為 ChallengeCell
        if cellViewModel.isChallenged == false {

            return
        } else {

            guard let readVC = UIStoryboard.read
                .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

            // 取 recipeId (feed.recipeId)
            let selectedFeed = viewModel.feedViewModels.value[indexPath.row].feed

            let recipeId = selectedFeed.recipeId

            // 傳 Id
            readVC.recipeId = recipeId

            self.navigationController?.pushViewController(readVC, animated: true)
        }
    }
}
