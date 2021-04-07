//
//  CourseCell.swift
//  CurrencyCourses
//
//  Created by Dmitriy Lee on 8/15/20.
//  Copyright © 2020 LEES Entertainment. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelQuant: UILabel!
    @IBOutlet weak var labelCourse: UILabel!
    
    func initCell(currency: Currency?) {
        imageFlag.image = currency?.imageFlag
        labelCurrencyName.text = currency?.title
        labelQuant.text = currency?.quant
        labelCourse.text = currency?.description
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
