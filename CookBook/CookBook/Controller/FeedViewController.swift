//
//  ViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/12.
//

import UIKit

class FeedViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      self.tableView.delegate = self
      self.tableView.dataSource = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()
  }

  private func setupTableView() {
    tableView.registerCellWithNib(identifier: "FeedTableViewCell", bundle: nil)
    // tableView.registerCellWithNib(identifier: "FeedChallengesTableViewCell", bundle: nil)
  }
}

extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath)

    guard let feedCell = cell as? FeedTableViewCell else {
      return cell
    }

    // setup feedCell content in FeedTableViewCell.swift
    // Adding challengeFeedCall lateron

    return feedCell
  }
}

extension FeedViewController: UITableViewDelegate {
}
