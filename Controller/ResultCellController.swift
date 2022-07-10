//
//  ResultCellController.swift
//  ClothesFinder
//
//  Created by Phil John on 7/10/22.
//


import UIKit

class ResultCellController: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Similar to viewDidLoad in a ViewController
        
        // we set Lines property in Label
        // to 0 in order to scale with text
        // Also set the alignment to the top
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

