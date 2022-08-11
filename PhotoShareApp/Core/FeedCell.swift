//
//  FeedCell.swift
//  PhotoShareApp
//
//  Created by Mustafa Çiçek on 11.08.2022.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userCommentLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var hiddenDocumentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestore = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            
            let likeStore = ["likes" : likeCount + 1 ] as [String : Any]
            
            // merge direkt o nesneyi günceller , diger degiskenlere dokunmaz db'deki
            firestore.collection("posts").document(hiddenDocumentIdLabel.text!).setData(likeStore, merge: true)
        }
        
       
    }
}
