//
//  ImageCell.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import UIKit
import SDWebImage


protocol ImageCellDelegate: AnyObject{
    func checkBoxPressed(isChecked: Bool,index: IndexPath)
}

class ImageCell: UITableViewCell {
    weak var delegate: ImageCellDelegate?
    private var cachedImage: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    var isCheckBoxSelected = false
    var cellIndex: IndexPath = IndexPath()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(imageData: Image){
    
        self.titleLbl.text = imageData.author ?? ""
        self.descriptionLbl.text = "DOWNLOAD URL: \(imageData.downloadURL ?? "")"
        self.photoImageView.contentMode = .scaleToFill
        self.photoImageView.clipsToBounds = true
     
        self.photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        
        self.photoImageView.sd_setImage(with: URL(string: imageData.downloadURL ?? "")) { (image, error, cache, urls) in
            if (error != nil) {
                self.photoImageView.image = UIImage(named: "noimageicon")
            } else {
                //print("CELL HEIGHT IS \(self.frame.height)")
                self.photoImageView.image = image
            }
        }
        
        
        

        self.checkBoxBtn.setImage(imageData.isChecked ? UIImage(named: "checked") : UIImage(named: "unchecked") , for: .normal)
        self.isCheckBoxSelected = imageData.isChecked
    }
    
    @IBAction func checkBoxBtnPressed(_ sender: UIButton) {

        self.isCheckBoxSelected.toggle()
        print(isCheckBoxSelected)
        delegate?.checkBoxPressed(isChecked: self.isCheckBoxSelected, index: cellIndex)
        
    }
    
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
