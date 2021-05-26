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

    // 本地資料組
    var steps: [Step]? {

        didSet {

            guard let collectionView = collectionView else { return }

            // reload data
            collectionView.reloadData()
        }
    }

    var imagePicker = UIImagePickerController()

    var stepImageViewCell: EditStepsCollectionViewCell?

    override func viewDidLoad() {

        super.viewDidLoad()

        imagePicker.delegate = self

        setupCollecitonViewFlowLayout()
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave logic

        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAndLeave(_ sender: Any) {

        // uplaod before leave logic

        dismiss(animated: true, completion: nil)
    }

    private func setupCollecitonViewFlowLayout() {

        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 32)

        snapCollectionFlowLayout.scrollDirection = .horizontal
    }

    private func setupUploadMenu() {

        let controller = UIAlertController(
            title: "上傳步驟圖片",
            message: nil,
            preferredStyle: .actionSheet
        )

        let cameraAction = UIAlertAction(
            title: "拍照",
            style: .default) { _ in

            // 開啟相機
            self.openCamera()
        }

        let libraryAction = UIAlertAction(
            title: "相簿照片",
            style: .default) { _ in

            // 開啟相簿
            self.openAlbum()
        }

        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel)

        controller.addAction(cameraAction)

        controller.addAction(libraryAction)

        controller.addAction(cancelAction)

        present(controller, animated: true)
    }

    private func openCamera() {

        imagePicker.sourceType = .camera

        imagePicker.allowsEditing = true

        present(imagePicker, animated: true)
    }

    private func openAlbum() {

        imagePicker.sourceType = .savedPhotosAlbum

        imagePicker.allowsEditing = true

        present(imagePicker, animated: true)
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

            // write in steps data
            self?.steps?[indexPath.row].description = description
        }

        stepCell.onUploadedImageTapped = { [weak self] in

            // upload menu open
            self?.setupUploadMenu()

            // callback to know which cell is it
            self?.stepImageViewCell = stepCell
        }

        return stepCell
    }
}

extension EditStepsViewController: UICollectionViewDelegate {

}

extension EditStepsViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

            // upload function
            viewModel?.uploadImagePickerImage(with: image) { [weak self] result in

                switch result {

                case .failure(let error):

                    print("Error: \(error)")

                case .success(let downloadUrl):

                    print("Image upload success!, downloadUrl: \(downloadUrl)")

                    // located current indexPath of collectionViewCell
                    guard let cell = self?.collectionView.visibleCells[0],
                          let indexpath = self?.collectionView.indexPath(for: cell) else { return }

                    // write in steps data
                    self?.steps?[indexpath.row].image = downloadUrl
                }
            }

            // replace cell's image with pickerImgae
            stepImageViewCell?.setImage(with: image)

            // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true)
    }
}

extension EditStepsViewController: UINavigationControllerDelegate {

}
