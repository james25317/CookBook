//
//  ReadModeViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class ReadModeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {

            self.collectionView.delegate = self

            self.collectionView.dataSource = self
        }
    }

    // CustomFlow Layout Outlet
    @IBOutlet weak var snapCollectionFlowLayout: SnapCollectionFlowLayout!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupCollecitonView()

        setupCollecitonViewFlowLayout()
    }

    @IBAction func leave(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    private func setupCollecitonView() {

        collectionView.registerCellWithNib(identifier: "ReadStepsCollectionViewCell", bundle: nil)

        collectionView.registerCellWithNib(identifier: "ReadIngredientsCollectionViewCell", bundle: nil)

        collectionView.backgroundColor = .clear
    }

    private func setupCollecitonViewFlowLayout() {

        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 32)

        snapCollectionFlowLayout.scrollDirection = .horizontal
    }
}

extension ReadModeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 6
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadStepsCollectionViewCell", for: indexPath)

        guard let readCell = cell as? ReadStepsCollectionViewCell else { return cell }

        return readCell
    }
}

extension ReadModeViewController: UICollectionViewDelegate {

}
