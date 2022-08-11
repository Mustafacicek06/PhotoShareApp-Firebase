//
//  FeedViewController.swift
//  PhotoShareApp
//
//  Created by Mustafa Çiçek on 9.08.2022.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    var postModels =  [PostModel]()
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
    }
    
    
    func getDataFromFirestore() {
        let firestore = Firestore.firestore()
        
        //let settings = firestore.settings
        
        firestore.collection("posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { [self] snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", alertButtonTitle: "Ok")
                
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedByUser") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageURL = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageURL)
                        }
                        
                    }
                    print(userEmailArray.count)
                    self.tableView.reloadData()
                   
                }
                
            }
        }
      
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // oluşturduğum cell'i verdim buraya
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.userCommentLabel.text = userCommentArray[indexPath.row]
        // placeHolder fotoğraf yüklenene kadar bir şey göstermek istersen diye
        // normal telefonda daha hızlı calısır
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.hiddenDocumentIdLabel.text = documentIdArray[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }

 

}
