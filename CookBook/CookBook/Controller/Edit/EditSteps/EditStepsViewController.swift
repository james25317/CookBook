//
//  EditStepsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit
import FirebaseStorage

class EditStepsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }

    @IBOutlet weak var snapCollectionFlowLayout: SnapCollectionFlowLayout!

    var viewModel: EditViewModel? {

        didSet {

            guard let viewModel = viewModel else { return }

            steps = viewModel.recipeViewModel.value?.steps
        }
    }

    // Local Steps Struct
    var steps: [Step]? {

        didSet {

            guard let collectionView = collectionView else { return }

            collectionView.reloadData()
        }
    }

    var imagePicker = UIImagePickerController()

    var stepImageViewCell: EditStepsCollectionViewCell?

    override func viewDidLoad() {

        super.viewDidLoad()

        imagePicker.delegate = self

        view.layoutIfNeeded()

        setupCollecitonViewFlowLayout()
    }

    @IBAction func leave(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func addNewStep(_ sender: Any) {

        guard let step = viewModel?.step else { return }

        steps?.append(step)

        if let steps = steps {

            let numberOfRowCounts = steps.count - 1

            scrollToItem(to: numberOfRowCounts)
        }
    }

    @IBAction func toTapSave(_ sender: Any) {

        guard let viewModel = viewModel,
            let steps = steps else { return }
        
        viewModel.uploadSteps(with: steps)

        CBProgressHUD.showSuccess(text: "Steps Added")

        dismiss(animated: true, completion: nil)
    }

    private func setupCollecitonViewFlowLayout() {

        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)

        snapCollectionFlowLayout.scrollDirection = .horizontal
    }

    private func setupUploadMenu() {

        let controller = UIAlertController(
            title: "Upload Picture",
            message: nil,
            preferredStyle: .actionSheet
        )

        let cameraAction = UIAlertAction(
            title: "Camera",
            style: .default) { _ in

            self.openCamera()
        }

        let libraryAction = UIAlertAction(
            title: "Album",
            style: .default) { _ in

            self.openAlbum()
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel)

        controller.addAction(cameraAction)

        controller.addAction(libraryAction)

        controller.addAction(cancelAction)

        present(controller, animated: true)
    }

    private func openCamera() {

        imagePicker.sourceType = .camera

        present(imagePicker, animated: true)
    }

    private func openAlbum() {

        imagePicker.sourceType = .savedPhotosAlbum

        present(imagePicker, animated: true)
    }

    private func scrollToItem(to index: Int) {

        collectionView.scrollToItem(
            at: IndexPath(row: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
}

extension EditStepsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let steps = steps else { return 0 }

        return steps.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: EditStepsCollectionViewCell.self),
            for: indexPath
        )

        guard let stepCell = cell as? EditStepsCollectionViewCell else { return cell }

        guard let steps = steps else { return cell }

        let step = steps[indexPath.row]

        stepCell.setupCell(with: step, at: indexPath.row)

        stepCell.onDescriptionChanged = { [weak self] description in

            self?.steps?[indexPath.row].description = description
        }

        stepCell.onUploadedImageTapped = { [weak self] in

            self?.setupUploadMenu()

            self?.stepImageViewCell = stepCell
        }

        stepCell.onDeleteStep = { [weak self] in

            self?.steps?.remove(at: indexPath.row)
        }

        return stepCell
    }
}

extension EditStepsViewController: UICollectionViewDelegate {

}

extension EditStepsViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            viewModel?.uploadImagePickerImage(with: image) { [weak self] result in

                switch result {

                case .failure(let error):

                    print("Error: \(error)")

                case .success(let downloadUrl):

                    print("Image upload success!, downloadUrl: \(downloadUrl)")

                    guard let cell = self?.stepImageViewCell,
                        let indexpath = self?.collectionView.indexPath(for: cell) else { return }

                    self?.stepImageViewCell?.setupImage(with: image)
                    
                    self?.steps?[indexpath.row].image = downloadUrl
                }
            }
        }

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true)
    }
}

extension EditStepsViewController: UINavigationControllerDelegate {

}
