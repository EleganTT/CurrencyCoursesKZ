//
//  SelectCourseCell.swift
//  CurrencyCourses
//
//  Created by Dmitriy Lee on 8/19/20.
//  Copyright © 2020 LEES Entertainment. All rights reserved.
//

import UIKit

class SelectCourseCell: UITableViewCell {
    
    @IBOutlet weak var selectImageFlag: UIImageView!
    @IBOutlet weak var selectLabelCurrencyName: UILabel!
    
    func selectInitCell(currency: Currency?) {
        selectImageFlag.image = currency?.imageFlag
        selectLabelCurrencyName.text = currency?.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
