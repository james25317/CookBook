//
//  ProfileViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ProfileViewController: UIViewController {

    private enum SortType: Int {

        case recipes = 0

        case favorites = 1

        case challenges = 2
    }

    @IBOutlet var profileView: UIView!

    @IBOutlet weak var imageViewUserPortrait: UIImageView!

    @IBOutlet weak var labelUserName: UILabel!

    @IBOutlet weak var indicatorView: UIView!

    @IBOutlet weak var labelUserId: UILabel!

    @IBOutlet weak var labelRecipesCounts: UILabel!

    @IBOutlet weak var labelFavoritesCounts: UILabel!

    @IBOutlet weak var labelChallengeCounts: UILabel!

    @IBOutlet weak var indicatorCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var sortButtons: [UIButton]!

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            self.collectionView.delegate = self

            self.collectionView.dataSource = self
        }
    }

    let viewModel = ProfileViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()

        // 綁定 Fb Recipes 資料
        viewModel.recipeViewModels.bind { [weak self] recipes in

            self?.collectionView.reloadData()
        }

        // 綁定 Fb User 資料
        viewModel.userViewModel.bind { [weak self] user in

            self?.setupProfileInfo()
        }

        // fetch 資料
        // 該 UserDocumentId
        let ownerId = "UserDocumentId"

        // viewModel.fetchRecipesData()

        viewModel.fetchOwnerRecipesData(with: ownerId)

        viewModel.fetchFavoritesRecipesData(with: ownerId)

        viewModel.fetchChallengesRecipesData(with: ownerId)

        viewModel.fetchUserData()

        setupProfileInfo()

        setupCollectionView()

        sortButtons[SortType.recipes.rawValue].isSelected = true
    }


    @IBAction func onChangeSortType(_ sender: UIButton) {

        for button in sortButtons {

            button.isSelected = false
        }

        sender.isSelected = true

        moveIndicatorView(reference: sender)

        guard let type = SortType(rawValue: sender.tag) else { return }

        updateCollectionView(type: type)
    }

    private func setupProfileInfo() {

        guard let data = viewModel.userViewModel.value else { return }

        imageViewUserPortrait.loadImage(data.portrait)

        labelUserId.text = data.appleId

        labelRecipesCounts.text = String(describing: data.recipesCounts)

        labelFavoritesCounts.text = String(describing: data.favoritesCounts)

        labelChallengeCounts.text = String(describing: data.challengesCounts)

        roundedPortrait()
    }

    private func roundedPortrait() {

        imageViewUserPortrait.layer.cornerRadius = imageViewUserPortrait.frame.size.height / 2
    }

    private func setupCollectionView() {

        collectionView.backgroundColor = UIColor.white

        setupCollectionViewLayout()

        addProfileViewContraints()
    }

    private func setupCollectionViewLayout() {

        let itemSpace: CGFloat = 3

        let columnCount: CGFloat = 3

        let flowLayout = UICollectionViewFlowLayout()

        let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1)) / columnCount)

        flowLayout.sectionInset = UIEdgeInsets(top: 360, left: 0, bottom: 0, right: 0)

        flowLayout.itemSize = CGSize(width: width, height: width)

        flowLayout.estimatedItemSize = .zero

        flowLayout.minimumInteritemSpacing = itemSpace

        flowLayout.minimumLineSpacing = itemSpace

        collectionView.collectionViewLayout = flowLayout
    }

    private func addProfileViewContraints() {

        profileView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.addSubview(profileView)

        NSLayoutConstraint.activate([

            profileView.heightAnchor.constraint(equalToConstant: 360),

            profileView.leadingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.leadingAnchor),

            profileView.trailingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.trailingAnchor),

            profileView.bottomAnchor.constraint(
                greaterThanOrEqualTo: collectionView.safeAreaLayoutGuide.topAnchor,
                constant: 48
            )
        ])

        let topConstraint = profileView.topAnchor.constraint(equalTo: collectionView.contentLayoutGuide.topAnchor)

        topConstraint.priority = UILayoutPriority(999)

        topConstraint.isActive = true
    }

    private func moveIndicatorView(reference: UIView) {

        indicatorCenterXConstraint.isActive = false

        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor)

        indicatorCenterXConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            self?.view.layoutIfNeeded()
        })
    }

    private func updateCollectionView(type: SortType) {

        // 根據點擊的按鈕來源判斷向哪個 Collection 叫資料（？）
    }
}

extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.recipeViewModels.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )

        guard let recipeCell = cell as? ProfileCollectionViewCell else { return cell }

        let cellViewModel = self.viewModel.recipeViewModels.value[indexPath.item]

        cellViewModel.onFetch = { [weak self] in

            print("onFetch was activated")

            self?.viewModel.fetchRecipesData()
        }

        recipeCell.setup(viewModel: cellViewModel)

        return recipeCell
    }
}

extension ProfileViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: false)

        guard let readVC = UIStoryboard.read
                .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        // 取 recipeId (recipe.id)
        let selectedItem = viewModel.recipeViewModels.value[indexPath.row].recipe

        let recipeId = selectedItem.id

        // 傳 Id
        readVC.recipeId = recipeId

        // readVC.setupRecipePreview(with: selectedRecipe)

        self.navigationController?.pushViewController(readVC, animated: true)
    }
}
