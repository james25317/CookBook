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

    private let uid = UserManager.shared.uid

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

        self.navigationController?.navigationBar.shadowImage = image

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.fetchUser(uid: uid)

        viewModel.fetchTodayRecipe()

        viewModel.fetchOfficialRecipe()

        viewModel.onLoadImage = { [weak self] () in

            self?.imageViewTodayRecipe.loadImage(self?.viewModel.officialRecipe?.mainImage)
        }

        setupTodayRecipeTapGesture()

        setupRecipeVideoTapGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // SignOut
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

        guard let homeVC = UIStoryboard.main
            .instantiateViewController(withIdentifier: "Home") as? HomeViewController else { return }

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

        guard let recipe = self.viewModel.officialRecipe else { return }
        
        readVC.recipeId = recipe.id
    }
    
    @objc func goTodayRecipeVideo() {

        // hard coded uid for admin
        if UserManager.shared.uid == "EkrSAora4PRxZ1H22ggj6UfjU6A3" {

            guard let todayVideoVC = storyboard?
                .instantiateViewController(withIdentifier: "TodayVideo") as? TodayVideoViewController else { return }

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            navigationItem.backBarButtonItem?.tintColor = .white

            todayVideoVC.viewModel = viewModel

            navigationController?.pushViewController(todayVideoVC, animated: true)
        } else {

            CBProgressHUD.showText(text: "Coming Soon")
        }
    }
}
