//
//  UploadViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Çiçek on 9.08.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    @IBAction func actionUploadClicked(_ sender: Any) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("Media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpeg")
            imageRef.putData(data, metadata: nil) { metaData, error in
                
                
                
                if error != nil {
                    self.makeAlert(title: "Upload Photo Error", message: error?.localizedDescription ?? "Error" , alertButtonTitle: "Ok")
                }
                else {
                    imageRef.downloadURL { url , error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                           
                            
                            // DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            
                            // bu referans üstteki firestoreDatabase'den türeyecek
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl as Any , "postedByUser" : Auth.auth().currentUser!.email! , "postComment": self.imageDescriptionTextField.text! , "date": FieldValue.serverTimestamp() , "likes" : 0 ] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error" , alertButtonTitle: "Ok")
                                }
                                else {
                                    self.imageView.image = UIImage(named: "finger_tap.png")
                                    self.imageDescriptionTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
                
            }
        }
    }
    

    
}
