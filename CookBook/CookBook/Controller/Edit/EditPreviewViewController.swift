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

        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel?.onCreatedDone = { [weak self] () in

            guard let editDoneVC = UIStoryboard.editDone
                .instantiateViewController(
                        withIdentifier: "EditDone"
                    ) as? EditDoneViewController else { return }

            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            self?.navigationController?.pushViewController(editDoneVC, animated: true)

            editDoneVC.viewModel = self?.viewModel

            CBProgressHUD.showSuccess(text: "CookBook Created")
        }

        viewModel?.onChallengeCreatedDone = { [weak self] () in

            guard let editChallengeDoneVC = UIStoryboard.editDone
                .instantiateViewController(
                        withIdentifier: "EditChallengeDone"
                    ) as? EditChallengeDoneViewController else { return }

            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            self?.navigationController?.pushViewController(editChallengeDoneVC, animated: true)

            editChallengeDoneVC.viewModel = self?.viewModel

            CBProgressHUD.showSuccess(text: "Challenge CookBook Created")
        }

        viewModel?.recipeViewModel.bind { [weak self] recipe in

            self?.sectionButtons[SectionType.ingredients.rawValue]
                .setTitle("Ingredient (\(recipe?.ingredients.count ?? 0))", for: .normal)

            self?.sectionButtons[SectionType.steps.rawValue]
                .setTitle("Step (\(recipe?.steps.count ?? 0))", for: .normal)
        }

        sectionButtons[SectionType.ingredients.rawValue].isSelected = true
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func saveDraftOrLeave(_ sender: Any) {

        present(
            .saveDraftAlert(
                title: "Save as Draft?",
                message: "You can find your unfinished CookBook in your profile page."
            ) {
                self.goHomeVC()
            }, animated: true
        )
    }

    @IBAction func goEditDonePage(_ sender: Any) {

        guard let value = viewModel?.recipeViewModel.value,
            let mainImage = value.recipe.steps.last?.image else { return }

        value.recipe.mainImage = mainImage

        value.recipe.isEditDone = true

        viewModel?.updateRecipeEditStatus()

        viewModel?.uploadMainImage(with: mainImage)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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

        UIView.animate(withDuration: 0.3) { [weak self] in

            self?.view.layoutIfNeeded()
        }
    }

    private func updateContainer(type: SectionType) {

        containerViews.forEach { $0.isHidden = true }

        switch type {

        case .ingredients:

            ingredientsContainerView.isHidden = false

        case .steps:

            stepsContainerView.isHidden = false
        }
    }

    private func setupConfirmationAlert() {

        //        present(
        //            .saveDraftAlert(
        //                title: "Save as Draft?",
        //                message: "You can find your unfinished CookBook in your profile page.") {
        //
        //                self.goHomeVC()
        //            }, animated: true
        //        )

        //        let alertController = UIAlertController.saveDraftAlert(
        //            title: "Save as Draft?",
        //            message: "You can find your unfinished CookBook in your profile page.") {
        //
        //            self.goHomeVC()
        //        }
        //
        //        self.present(
        //            alertController,
        //            animated: true,
        //            completion: nil
        //        )
        
        //        let alertController = UIAlertController(
        //            title: "Save as Draft?",
        //            message: "You can find your unfinished CookBook in your profile page.",
        //            preferredStyle: .alert
        //        )
        //
        //        let cancelAction = UIAlertAction(
        //            title: "Cancel",
        //            style: .cancel,
        //            handler: nil
        //        )
        //
        //        alertController.addAction(cancelAction)
        //
        //        let saveAction = UIAlertAction(
        //            title: "Save",
        //            style: .default
        //            ) { _ in
        //
        //            self.goHomeVC()
        //        }
        //
        //        alertController.addAction(saveAction)
        //
        //        self.present(
        //            alertController,
        //            animated: true,
        //            completion: nil
        //        )
    }

    private func goHomeVC() {

        guard let navigationController = self.navigationController,
            let homeVC = navigationController.viewControllers.first(
                where: { $0 is HomeViewController }
            ) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }
}
