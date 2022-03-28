//
//  CellDocument.swift
//  DocScanner
//
//  Created by Ashish Maurya on 20/03/22.
//

import UIKit

class CellDocument: UICollectionViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    func configureCell(){
        self.viewCell.layer.borderColor = UIColor.gray.cgColor
        self.viewCell.layer.borderWidth = 1.0
        self.viewCell.layer.cornerRadius = 1.0
    }
    
    func updateValue(text: String){        
        self.lblData.text = text
    }

}
