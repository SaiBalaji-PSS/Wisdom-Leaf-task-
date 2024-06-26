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
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    var isCheckBoxSelected = false
    var cellIndex: IndexPath = IndexPath()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photoImageView.image = UIImage(named: "noimageicon")
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(imageData: Image){
    
        self.titleLbl.text = imageData.author ?? ""
        self.descriptionLbl.text = "DOWNLOAD URL: \(imageData.downloadURL ?? "")"
    
     


        //DOWNLOAD THE IMAGE FROM THE URL AND RESIZE THE IMAGE AND SET IT TO THE UIIMAGEVIEW
        self.photoImageView.sd_setImage(with: URL(string: imageData.downloadURL ?? ""),placeholderImage: UIImage(named: "noimageicon")) { (image, error, cache, urls) in
           
                //print("CELL HEIGHT IS \(self.frame.height)")
                if let downladedImage = image{
                    let resizedImage = downladedImage.resized(to: CGSize(width: 100, height: 100))
                    self.photoImageView.image = resizedImage
                    self.photoImageView.sd_imageIndicator = .none
                    
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
