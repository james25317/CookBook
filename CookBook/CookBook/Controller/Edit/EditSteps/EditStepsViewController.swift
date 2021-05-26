//
//  EditStepsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditStepsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }

    @IBOutlet weak var snapCollectionFlowLayout: SnapCollectionFlowLayout!

    var viewModel: EditViewModel? {

        didSet {

            guard let viewModel = viewModel else { return }

            steps = viewModel.recipeViewModel.value?.steps
        }
    }

    // 本地資料組
    var steps: [Step]? {

        didSet {

            guard let collectionView = collectionView else { return }

            // 值變動，觸發刷新畫面
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setupCollecitonViewFlowLayout()

        if steps == nil {

            steps?.append(Step(
                description: "",
                image: "初始化描述"
            ))
        }
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave logic

        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAndLeave(_ sender: Any) {

        // uplaod before leave logic

        dismiss(animated: true, completion: nil)
    }

    private func setupCollecitonViewFlowLayout() {

        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 32)

        snapCollectionFlowLayout.scrollDirection = .horizontal
    }
}

extension EditStepsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let steps = steps else { return 0 }

        return steps.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: EditStepsCollectionViewCell.self),
            for: indexPath
        )

        guard let stepsCell = cell as? EditStepsCollectionViewCell else { return cell }

        guard let steps = steps else { return cell }

        // out of range
        let step = steps[indexPath.row]

        // setupCell
        stepsCell.setupCell(with: step, at: indexPath.row)

        // 定義 onDescriptionChanged closure 行為
        stepsCell.onDescriptionChanged = { [weak self] description in

            self?.steps?[indexPath.row].description = description
        }

        return stepsCell
    }
}

extension EditStepsViewController: UICollectionViewDelegate {


}
