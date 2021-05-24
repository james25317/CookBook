//
//  EditStepsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditStepsViewController: UIViewController {

    var viewModel: EditViewModel? {

        didSet {

            guard let viewModel = viewModel else { return }

            steps = viewModel.recipeViewModel.value?.steps
        }
    }

    // 本地資料組
    var steps: [Step]? {

        didSet {

            // 值變動，觸發刷新畫面
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave logic

        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAndLeave(_ sender: Any) {

        // uplaod before leave logic

        dismiss(animated: true, completion: nil)
    }
}
