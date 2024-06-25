//
//  ImageCell.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
