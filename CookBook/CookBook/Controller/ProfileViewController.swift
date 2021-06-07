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

    // mockuid
    let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

    // 一旦根據按鈕的 type 被按到，type 賦值觸發 reloadData()
    private var type: ProfileViewModel.SortType = .recipes {

        didSet {

            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        CBProgressHUD.show()

        // fetch profile
        fetchProfileData(uid: uid)

        // 綁定 Fb Recipes 資料
        viewModel.recipeViewModels.bind { [weak self] recipes in

            self?.collectionView.reloadData()

            CBProgressHUD.dismiss()
        }

        // 綁定 Fb User 資料
        viewModel.userViewModel.bind { [weak self] user in

            self?.setupProfileInfo()
        }
        
        setupProfileInfo()

        setupCollectionView()

        sortButtons.first!.isSelected = true
    }

    @IBAction func onChangeSortType(_ sender: UIButton) {

        for button in sortButtons {

            button.isSelected = false
        }

        sender.isSelected = true

        moveIndicatorView(reference: sender)

        // 根據 button.tag 決定 ViewModel 資料切換的 type
        guard let type = ProfileViewModel.SortType(rawValue: sender.tag) else { return }

        self.type = type
    }

    private func fetchProfileData(uid: String) {

        viewModel.fetchOwnerRecipesData(with: uid)

        viewModel.fetchFavoritesRecipesData(with: uid)

        viewModel.fetchChallengesRecipesData(with: uid)

        viewModel.fetchUserData(uid: uid)
    }

    private func setupProfileInfo() {

        guard let value = viewModel.userViewModel.value else { return }

        imageViewUserPortrait.loadImage(value.portrait)

        labelUserId.text = value.user.email

        labelRecipesCounts.text = String(describing: value.recipesCounts)

        labelFavoritesCounts.text = String(describing: value.favoritesCounts)

        labelChallengeCounts.text = String(describing: value.challengesCounts)

        // roundedPortrait()
    }

    private func roundedPortrait() {

        imageViewUserPortrait.layer.cornerRadius = imageViewUserPortrait.frame.size.height / 2
    }

    private func setupCollectionView() {

        // collectionView.backgroundColor = UIColor.white

        setupCollectionViewLayout()

        addProfileViewContraints()
    }

    private func setupCollectionViewLayout() {

        let itemSpace: CGFloat = 3

        let columnCount: CGFloat = 3

        let flowLayout = UICollectionViewFlowLayout()

        let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1)) / columnCount)

        flowLayout.sectionInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)

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

            profileView.heightAnchor.constraint(equalToConstant: 300),

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
}

extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // guard let uid = UserDefaults.standard.string(forKey: UserDefaults.Keys.uid.rawValue) else { return 0 }

        // mockuid
        let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        return viewModel.switchSection(with: uid, sortType: type).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )

        guard let recipeCell = cell as? ProfileCollectionViewCell else { return cell }

        // guard let uid = UserDefaults.standard.string(forKey: UserDefaults.Keys.uid.rawValue) else { return cell }

        // mockuid
        let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        // 根據按鈕來源切換不同section的資料生成
        let cellViewModel = self.viewModel.switchSection(with: uid, sortType: type)[indexPath.row]

        // 根據 isEditDone 生成樣式
        if !cellViewModel.isEditDone {

            recipeCell.viewDraftView.isHidden = false

            recipeCell.imageViewIcon.isHidden = true

            recipeCell.labelLikesCounts.isHidden = true

            recipeCell.setup(viewModel: cellViewModel)

            return recipeCell
        } else {

            recipeCell.setup(viewModel: cellViewModel)

            return recipeCell
        }
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
        
        self.navigationController?.pushViewController(readVC, animated: true)
    }
}
