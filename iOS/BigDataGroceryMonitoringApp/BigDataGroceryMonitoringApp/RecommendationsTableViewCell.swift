//
//  RecommendationsTableViewCell.swift
//  BigDataGroceryMonitoringApp

import UIKit

class RecommendationsTableViewCell: UITableViewCell {
  var selectedItem: RecommendationModel?
  @IBOutlet weak var imageVW: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var desc: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }
    
}
