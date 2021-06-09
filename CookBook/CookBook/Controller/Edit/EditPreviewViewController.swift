//
//  EditPreviewViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class EditPreviewViewController: UIViewController {

    private enum SectionType: Int {

        case ingredients = 0

        case steps = 1
    }

    private enum Segue {

        static let ingredients = "SegueIngredients"

        static let steps = "SegueSteps"
    }

    @IBOutlet weak var labelRecipeName: UILabel!

    @IBOutlet weak var indicatorView: UIView!

    @IBOutlet weak var indicatorCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var ingredientsContainerView: UIView!

    @IBOutlet weak var stepsContainerView: UIView!

    @IBOutlet var sectionButtons: [UIButton]!

    var containerViews: [UIView] {

        return [ingredientsContainerView, stepsContainerView]
    }

    var viewModel: EditViewModel?

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel?.recipeViewModel.bind { [weak self] recipe in

            // self?.labelRecipeName.text = recipe?.name

            self?.sectionButtons[SectionType.ingredients.rawValue]
                .setTitle("Ingredient (\(recipe?.ingredients.count ?? 0))", for: .normal)

            self?.sectionButtons[SectionType.steps.rawValue]
                .setTitle("Step (\(recipe?.steps.count ?? 0))", for: .normal)
        }

        // set first button is selected by default
        sectionButtons[SectionType.ingredients.rawValue].isSelected = true
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func back(_ sender: Any) {

        // discard for now
        navigationController?.popViewController(animated: true)
    }

    @IBAction func leave(_ sender: Any) {

        // alertPopup
        setupAlert()
    }

    // MARK: go EditDone Page and pass data
    @IBAction func goEditDonePage(_ sender: Any) {

        // 判斷_資料屬性
        // assign latest mainImage data
        guard let value = viewModel?.recipeViewModel.value,
              let mainImage = value.recipe.steps.last?.image else { return }

        // assign 本地 mainImage 資料
        value.recipe.mainImage = mainImage

        // assign 本地 isEditDone 資料
        value.recipe.isEditDone = true

        // updat isEditDone
        viewModel?.updateIsEditDone()

        if !value.recipe.challenger.isEmpty {

            // go challengeDonePage
            guard let editChallengeDoneVC = UIStoryboard.editDone
                .instantiateViewController(
                        withIdentifier: "EditChallengeDone"
                    ) as? EditChallengeDoneViewController else { return }

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            // update MainImage
            viewModel?.updateMainImage(with: mainImage) { [weak self] result in

                switch result {

                case .failure(let error):

                    print("updated error: \(error)")

                case .success(let mainImage):

                    print("MainImage: \(mainImage) updated")

                    // pass latest recipe data to EditDone
                    editChallengeDoneVC.viewModel = self?.viewModel
                    
                    CBProgressHUD.showSuccess(text: "Challenge CookBook Created")

                    self?.navigationController?.pushViewController(editChallengeDoneVC, animated: true)
                }
            }
        } else {

            // go editDonePage
            guard let editDoneVC = UIStoryboard.editDone
                .instantiateViewController(withIdentifier: "EditDone") as? EditDoneViewController else { return }

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            // update MainImage
            viewModel?.updateMainImage(with: mainImage) { [weak self] result in

                switch result {

                case .failure(let error):

                    print("updated error: \(error)")

                case .success(let mainImage):

                    print("MainImage: \(mainImage) updated")
                    
                    // pass latest recipe data to EditDone
                    editDoneVC.viewModel = self?.viewModel

                    CBProgressHUD.showSuccess(text: "CookBook Created")

                    self?.navigationController?.pushViewController(editDoneVC, animated: true)
                }
            }
        }
    }

    @IBAction func onChangeSections(_ sender: UIButton) {

        for button in sectionButtons {

            button.isSelected = false
        }

        sender.isSelected = true

        moveIndicatorView(reference: sender)

        guard let type = SectionType(rawValue: sender.tag) else { return }

        updateContainer(type: type)
    }

    // MARK: Prepare segue for data transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // guard let viewModel = viewModel else { return }

        let identifier = segue.identifier

        if identifier == Segue.ingredients {

            guard let ingredientsPreviewVC = segue.destination as? EditIngredientsPreviewViewController else { return }

            ingredientsPreviewVC.viewModel = viewModel
        } else if identifier == Segue.steps {

            guard let stepsPreviewVC = segue.destination as? EditStepsPreviewViewController else { return }

            stepsPreviewVC.viewModel = viewModel
        }
    }

    private func moveIndicatorView(reference: UIView) {

        indicatorCenterXConstraint.isActive = false

        indicatorCenterXConstraint = indicatorView
            .centerXAnchor.constraint(equalTo: reference.centerXAnchor)

        indicatorCenterXConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            self?.view.layoutIfNeeded()
        })
    }

    private func updateContainer(type: SectionType) {

        containerViews.forEach({ $0.isHidden = true })

        switch type {

        case .ingredients:
            ingredientsContainerView.isHidden = false

        case .steps:
            stepsContainerView.isHidden = false
        }
    }

    private func setupAlert() {

        let alertController = UIAlertController(
            title: "Save as Draft?",
            message: "You can find your unfinished CookBook in your profile page.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )

        let saveAction = UIAlertAction(
            title: "Save",
            style: .default
            ) { _ in

            // save and leave
            // isEditDone = false
            self.goHomeVC()
        }

        alertController.addAction(cancelAction)

        alertController.addAction(saveAction)

        self.present(
            alertController,
            animated: true,
            completion: nil
        )
    }

    private func goHomeVC() {

        // back to homeVC
        guard let navigationController = self.navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }
}
