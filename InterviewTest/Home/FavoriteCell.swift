//
//  FavoriteCell.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var transTypeImagView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(model: FavoriteModel) {
        nicknameLabel.text = model.nickname
        guard let favoriteType = FavoriteType(rawValue: model.transType) else { return }
        
        switch favoriteType {
        case .cube:
            transTypeImagView.image = UIImage(named: "button00ElementScrollTree")
        case .mobile:
            transTypeImagView.image = UIImage(named: "button00ElementScrollMobile")
        case .pmf:
            transTypeImagView.image = UIImage(named: "button00ElementScrollBuilding")
        case .creditCard:
            transTypeImagView.image = UIImage(named: "button00ElementScrollCreditCard")
        }
        
    }
    
}

