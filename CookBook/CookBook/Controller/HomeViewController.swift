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

        setupTableView()

        setupSearchBar()

        // 向 HomeVM 綁定 Box 觀察資料變化(fetch成功後的值)，VC 這邊要做的事情
        viewModel.feedViewModels.bind { [weak self] feeds in

            self?.tableView.reloadData()
        }

        // 向 HomeVM 要資料，回傳結果至 Box.value 給其他被綁定的 V
        viewModel.fetchData()
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

        // Adding challengeFeedCall logic later on

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FeedTableViewCell.self),
            for: indexPath
        )
        
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        guard let readVC = UIStoryboard.read
                .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        navigationController?.pushViewController(readVC, animated: true)
    }
}
