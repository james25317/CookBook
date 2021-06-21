//
//  ViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/12.
//

import UIKit
import EasyRefresher

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            self.tableView.delegate = self

            self.tableView.dataSource = self
        }
    }

    let viewModel = HomeViewModel()

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

        self.navigationController?.navigationBar.shadowImage = image

        self.navigationItem.setHidesBackButton(true, animated: true)

        viewModel.fetchFeedsData()

        CBProgressHUD.show()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.feedViewModels.bind { [weak self] _ in

            self?.tableView.reloadData()

            CBProgressHUD.dismiss()
        }
        
        viewModel.scrollToTop = { [weak self] () in

            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }

        setupRefresher()
    }

    @IBAction func goTodayPage(_ sender: Any) {

        navigationController?.push(to: .today)
//        guard let todayVC = UIStoryboard.today
//            .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }
//
//        navigationController?.pushViewController(todayVC, animated: true)
    }

    @IBAction func goEditPage(_ sender: Any) {

        navigationController?.push(to: .editName)
//        guard let editVC = UIStoryboard.edit
//            .instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }
//
//        navigationController?.pushViewController(editVC, animated: true)
    }

    @IBAction func goProfilePage(_ sender: Any) {

        navigationController?.push(to: .profile)
//        guard let profileVC = UIStoryboard.profile
//            .instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }
//
//        navigationController?.pushViewController(profileVC, animated: true)
    }

    private func setupRefresher() {

        self.tableView.refresh.header = RefreshHeader(delegate: self)

        tableView.refresh.header.setTitle("loading...", for: .refreshing)

        tableView.refresh.header.addRefreshClosure { [weak self] in

            self?.viewModel.fetchFeedsData()

            self?.viewModel.onScrollToTop()

            self?.tableView.refresh.header.endRefreshing()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.filteredBlockListFromFeeds().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellViewModel = self.viewModel.filteredBlockListFromFeeds()[indexPath.row]

        if !cellViewModel.isChallenged {

            // challenge Feed
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FeedChallengeTableViewCell.self),
                for: indexPath
            )

            guard let feedChallengeCell = cell as? FeedChallengeTableViewCell else { return cell }

            feedChallengeCell.setup(viewModel: cellViewModel)

            return feedChallengeCell
        } else if cellViewModel.isChallenged &&
            !cellViewModel.challenger.isEmpty &&
            !cellViewModel.challengerRecipeId.isEmpty {

            // challengeDone Feed
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FeedChallengeDoneTableViewCell.self),
                for: indexPath
            )

            guard let feedChallengeDoneCell = cell as? FeedChallengeDoneTableViewCell else { return cell }

            feedChallengeDoneCell.onOwnerTapped = { [weak self] () in

                guard let readVC = UIStoryboard.read
                    .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

                readVC.recipeId = cellViewModel.recipeId

                self?.navigationController?.pushViewController(readVC, animated: true)
            }

            feedChallengeDoneCell.onChallengerTapped = { [weak self] () in
                
                guard let readVC = UIStoryboard.read
                    .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

                readVC.recipeId = cellViewModel.challengerRecipeId

                self?.navigationController?.pushViewController(readVC, animated: true)
            }

            feedChallengeDoneCell.setup(viewModel: cellViewModel)

            return feedChallengeDoneCell
        } else {

            // usual Feed
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FeedTableViewCell.self),
                for: indexPath
            )

            guard let feedCell = cell as? FeedTableViewCell else { return cell }

            feedCell.setup(viewModel: cellViewModel)

            return feedCell
        }
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        let cellViewModel = self.viewModel.filteredBlockListFromFeeds()[indexPath.row]
        
        if !cellViewModel.challenger.isEmpty {

            // ChallengeDoneCell
            print("ChallengeDoneCell tapped")

            return
        } else if cellViewModel.isChallenged == false {

            // ChallengeCell
            guard let challengeVC = UIStoryboard.challenge
                .instantiateViewController(withIdentifier: "Challenge") as? ChallengeViewController else { return }

            challengeVC.viewModel.recipeId = cellViewModel.feed.recipeId

            challengeVC.viewModel.selectedFeed = cellViewModel.feed

            self.navigationController?.pushViewController(challengeVC, animated: true)

            print("ChallengeCell tapped")
        } else {

            // NormalCell
            guard let readVC = UIStoryboard.read
                .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

            let selectedFeed = cellViewModel.feed

            let recipeId = selectedFeed.recipeId

            readVC.recipeId = recipeId

            self.navigationController?.pushViewController(readVC, animated: true)

            print("NormalCell tapped")
        }
    }
}

extension HomeViewController: RefreshDelegate {

    func refresherDidRefresh(_ refresher: Refresher) {

        // behavior after refreshed
        print("Home Feed Refreshed.")
    }
}
