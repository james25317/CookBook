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

    @IBOutlet weak var labelUserEmail: UILabel!

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

    let editViewModel = EditViewModel()

    // Useage: UserManager.shared.uid
    let uid = UserManager.shared.uid

    // 一旦根據按鈕的 type 被按到，type 賦值觸發 reloadData()
    private var type: ProfileViewModel.SortType = .recipes {

        didSet {

            collectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
//        let image = UIImage()
//
//        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//
//        self.navigationController?.navigationBar.shadowImage = image
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // self.navigationController?.navigationBar.backgroundColor = .white

        CBProgressHUD.show()

        // fetch profile
        fetchProfileData(uid: uid)

        setupProfileInfo()

        setupCollectionView()

        // 綁定 Fb Recipes 資料
        viewModel.recipeViewModels.bind { [weak self] recipes in

            self?.collectionView.reloadData()

            CBProgressHUD.dismiss()
        }

        // 綁定 Fb User 資料
        viewModel.userViewModel.bind { [weak self] user in

            self?.setupProfileInfo()
        }

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

        // viewModel.fetchOwnerRecipesData(with: uid)

        // viewModel.fetchFavoritesRecipesData(with: uid)

        // viewModel.fetchChallengesRecipesData(with: uid)

        viewModel.fetchRecipesData()

        viewModel.fetchUserData(uid: uid)
    }

    private func setupProfileInfo() {

        guard let value = viewModel.userViewModel.value else { return }

        if value.portrait.isEmpty {

            imageViewUserPortrait.image = UIImage(named: "CookBook_image_placholder_portrait")
        } else {

            imageViewUserPortrait.loadImage(value.portrait)
        }

        labelUserEmail.text = value.user.email

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

        // let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1)) / columnCount)

        let width = floor((UIScreen.main.bounds.width - itemSpace * (columnCount - 1)) / columnCount)

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

        let topConstraint = profileView.topAnchor.constraint(equalTo: collectionView.topAnchor)

        // let topConstraint = profileView.topAnchor.constraint(equalTo: collectionView.contentLayoutGuide.topAnchor)

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

        return viewModel.switchSection(uid: uid, sortType: type).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )

        guard let recipeCell = cell as? ProfileCollectionViewCell else { return cell }
        
        // 根據按鈕來源切換不同section的資料生成
        let cellViewModel = self.viewModel.switchSection(uid: uid, sortType: type)[indexPath.row]

        // 根據 isEditDone 生成樣式
        if !cellViewModel.isEditDone {

            recipeCell.viewDraftView.isHidden = false

            recipeCell.viewRecipeView.isHidden = true

            recipeCell.setup(viewModel: cellViewModel)

            return recipeCell
        } else {

            recipeCell.viewDraftView.isHidden = true

            recipeCell.viewRecipeView.isHidden = false

            recipeCell.setup(viewModel: cellViewModel)

            return recipeCell
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: false)
        
        // let selectedItem = viewModel.recipeViewModels.value[indexPath.row].recipe

        let selectedItem = viewModel.switchSection(uid: uid, sortType: type)[indexPath.row].recipe

        // 根據 isEditDone 決定去的方向
        if !selectedItem.isEditDone {

            // go EditPreviewPage
            guard let previewVC = UIStoryboard.edit
                .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

            // 用 selectedItem.id 重新取得 Fb 的綁定
            editViewModel.fetchRecipe(documentId: selectedItem.id!)

            // pass data
            previewVC.viewModel = editViewModel

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            navigationController?.pushViewController(previewVC, animated: true)
        } else {

            // go ReadPage
            guard let readVC = UIStoryboard.read
                    .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

            let recipeId = selectedItem.id

            // 傳 Id
            readVC.recipeId = recipeId

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            self.navigationController?.pushViewController(readVC, animated: true)
        }
    }
}
