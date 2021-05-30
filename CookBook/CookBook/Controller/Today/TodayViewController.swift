//
//  TodayViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var imageViewTodayRecipe: UIImageView!

    @IBOutlet weak var imageViewRecipeVideo: UIImageView!

    let viewModel = TodayViewModel()

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

        self.navigationController?.navigationBar.shadowImage = image
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.todayRecipeViewModel.bind { [weak self] todayRecipe in

            // 資料更新後的行為
        }

        // fetch video 資料回 VM.value
        viewModel.fetchTodayRecipeData()

        // query recipe 資料

        setupTodayRecipeTapGesture()

        setupRecipeVideoTapGesture()
    }
    
    @IBAction func skipThisPage(_ sender: UIButton) {

        // comes from HomePage goes here
        // navigationController?.popViewController(animated: true)

        // comes from beginning goes here
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

        navigationController?.pushViewController(readVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @objc func goTodayRecipeVideo() {

        print("video start")

        guard let todayVideoVC = storyboard?
                .instantiateViewController(withIdentifier: "TodayVideo") as? TodayVideoViewController else { return }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationItem.backBarButtonItem?.tintColor = .white

        // fetch 資料到資料後，傳 VM 過去
        todayVideoVC.viewModel = viewModel

        navigationController?.pushViewController(todayVideoVC, animated: true)
    }
}
