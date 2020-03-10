//
//  CreateViewController.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/10/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostImageViewController: UIViewController {
    
    @IBOutlet weak var photoCaptionTextField: UITextField!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            photoImage.image = selectedImage
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Your Photo"
        photoCaptionTextField.delegate = self
        
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(longPressGesture)
    }
    
    //------------------------------------------------------------------------------
    
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        guard let photoName = photoCaptionTextField.text?.capitalized, !photoName.isEmpty,
            let selectedPhoto = selectedImage else {
                showAlert(title: "Missing Fields", message: "All fields are required")
                return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please complete your Profile")
            return
        }
        
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedPhoto, rect: photoImage.bounds)
        
        dbService.createPhoto(photoName: photoName, userPostedName: displayName) { [weak self](result) in
            switch result {
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error Capturing Photo", message: "\(error.localizedDescription)")
                }
            case .success(let documentId):
                self?.uploadPhoto(photo: resizedImage, documentId: documentId)
                self?.showAlert(title: "", message: "Image added to your collection")
            }
        }
        dismiss(animated: true)
    }
    
    
    
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto(userId: documentId, photoId: documentId, image: photo) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateItemImageURL(url, documentId: documentId)
            }
        }
    }
    
    
    
    private func updateItemImageURL(_ url: URL, documentId: String) {
        Firestore.firestore().collection(DatabaseService.imageCollection).document(documentId).updateData(
        ["imageURL" : url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Fail to Update", message: "\(error.localizedDescription)")
                }
            } else {
                
                print("updated item image")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}

//------------------------------------------------------------------------------
// MARK: EXTENSIONS

extension PostImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not get image")
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

extension PostImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
