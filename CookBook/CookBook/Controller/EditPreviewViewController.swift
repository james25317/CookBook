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

            self?.sectionButtons[SectionType.ingredients.rawValue]
                .setTitle("Ingredient (\(recipe?.ingredients.count ?? 0))", for: .normal)

            self?.sectionButtons[SectionType.steps.rawValue]
                .setTitle( "Step (\(recipe?.steps.count ?? 0))", for: .normal)
        }

        // set first button is selected by default
        sectionButtons[SectionType.ingredients.rawValue].isSelected = true
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func back(_ sender: Any) {

        navigationController?.popViewController(animated: true)
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave goes here

        // leave directly goes here
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func goEditDonePage(_ sender: Any) {

        guard let editVC = UIStoryboard.editDone
            .instantiateViewController(withIdentifier: "EditDone") as? EditDoneViewController else { return }

        navigationController?.pushViewController(editVC, animated: true)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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

        guard let viewModel = viewModel else { return }

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
}
