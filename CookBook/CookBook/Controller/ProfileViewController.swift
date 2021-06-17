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

    private let uid = UserManager.shared.uid

    private var sortType: ProfileViewModel.SortType = .recipes {

        didSet {

            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        CBProgressHUD.show()

        fetchProfileData(uid: uid)

        setupProfileInfo()

        setupCollectionView()

        viewModel.recipeViewModels.bind { [weak self] _ in

            self?.collectionView.reloadData()

            CBProgressHUD.dismiss()
        }

        viewModel.userViewModel.bind { [weak self] _ in

            self?.setupProfileInfo()
        }

        sortButtons.first?.isSelected = true
    }

    @IBAction func onChangeSortType(_ sender: UIButton) {

        for button in sortButtons {

            button.isSelected = false
        }

        sender.isSelected = true

        moveIndicatorView(reference: sender)

        guard let type = ProfileViewModel.SortType(rawValue: sender.tag) else { return }

        self.sortType = type
    }

    private func fetchProfileData(uid: String) {

        viewModel.fetchRecipes()

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
    }

    private func setupCollectionView() {

        setupCollectionViewLayout()

        addProfileViewContraints()
    }

    private func setupCollectionViewLayout() {

        let itemSpace: CGFloat = 3

        let columnCount: CGFloat = 3

        let flowLayout = UICollectionViewFlowLayout()

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

        let topConstraint = profileView.topAnchor.constraint(equalTo: collectionView.contentLayoutGuide.topAnchor)

        topConstraint.priority = UILayoutPriority(999)

        topConstraint.isActive = true
    }

    private func moveIndicatorView(reference: UIView) {

        indicatorCenterXConstraint.isActive = false

        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor)

        indicatorCenterXConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in

            self?.view.layoutIfNeeded()
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.switchSection(uid: uid, sortType: sortType).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )

        guard let recipeCell = cell as? ProfileCollectionViewCell else { return cell }

        let cellViewModel = self.viewModel.switchSection(uid: uid, sortType: sortType)[indexPath.row]

        if !cellViewModel.isEditDone {

            // Draft Cell
            recipeCell.viewDraftView.isHidden = false

            recipeCell.viewRecipeView.isHidden = true

            recipeCell.setup(viewModel: cellViewModel)

            return recipeCell
        } else {

            // Usual Cell
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

        let selectedItem = viewModel.switchSection(uid: uid, sortType: sortType)[indexPath.row].recipe

        if !selectedItem.isEditDone {

            // UserFlow: Countinue Editing
            guard let previewVC = UIStoryboard.edit
                .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

            guard let recipeId = selectedItem.id else { return }

            editViewModel.fetchRecipe(documentId: recipeId)

            previewVC.viewModel = editViewModel

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            navigationController?.pushViewController(previewVC, animated: true)
        } else {

            // UserFlow: Read Recipe
            guard let readVC = UIStoryboard.read
                .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

            let recipeId = selectedItem.id
            
            readVC.recipeId = recipeId

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            self.navigationController?.pushViewController(readVC, animated: true)
        }
    }
}
