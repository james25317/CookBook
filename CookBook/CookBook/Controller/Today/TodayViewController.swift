//
//  TodayViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit
import FirebaseAuth

class TodayViewController: UIViewController {

    @IBOutlet weak var imageViewTodayRecipe: UIImageView!

    @IBOutlet weak var imageViewRecipeVideo: UIImageView!

    let viewModel = TodayViewModel()

    // Useage: UserManager.shared.uid
    let uid = UserManager.shared.uid

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

        self.navigationController?.navigationBar.shadowImage = image

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.fetchUserData(uid: uid)

        // fetch video 資料回 VM.value
        viewModel.fetchTodayRecipeData()

        // query recipe 資料
        viewModel.fetchOfficialRecipeData()

        viewModel.onReNewed = { [weak self] () in

            self?.imageViewTodayRecipe.loadImage(self?.viewModel.recipe?.mainImage)
        }

        viewModel.todayRecipeViewModel.bind { [weak self] todayRecipe in

            // 資料更新後的行為
        }

        setupTodayRecipeTapGesture()

        setupRecipeVideoTapGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // 臨時 SignOut
    @IBAction func signOut(_ sender: Any) {

        print("SignOut button tapped!")

        let firebaseAuth = Auth.auth()

        do {
            
            try firebaseAuth.signOut()

        } catch let signOutError as NSError {
            
            print("Error signing out: %@", signOutError)
        }
    }

    @IBAction func skipThisPage(_ sender: UIButton) {

        // comes from beginning goes here
        guard let homeVC = UIStoryboard.main
                .instantiateViewController(withIdentifier: "Home") as? HomeViewController else { return }

        // homeVC.navigationItem.setHidesBackButton(true, animated: false)

        navigationController?.pushViewController(homeVC, animated: true)
    }

    private func setupTodayRecipeTapGesture() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(goTodayReadPage))

        imageViewTodayRecipe.isUserInteractionEnabled = true

        imageViewTodayRecipe.addGestureRecognizer(gesture)
    }

    private func setupRecipeVideoTapGesture() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(goTodayRecipeVideo))

        imageViewRecipeVideo.isUserInteractionEnabled = true

        imageViewRecipeVideo.addGestureRecognizer(gesture)
    }

    @objc func goTodayReadPage() {

        guard let readVC = UIStoryboard.read
                .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.pushViewController(readVC, animated: true)

        // fetch 到資料後，傳 recipeId 過去
        guard let recipe = self.viewModel.recipe else { return }
        
        readVC.recipeId = recipe.id
    }
    
    @objc func goTodayRecipeVideo() {

        print("video start")

        guard let todayVideoVC = storyboard?
                .instantiateViewController(withIdentifier: "TodayVideo") as? TodayVideoViewController else { return }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationItem.backBarButtonItem?.tintColor = .white

        // fetch 到資料後，傳 VM 過去
        todayVideoVC.viewModel = viewModel

        navigationController?.pushViewController(todayVideoVC, animated: true)
    }
}
