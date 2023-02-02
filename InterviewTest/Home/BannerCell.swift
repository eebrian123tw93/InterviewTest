//
//  BannerCell.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//


import UIKit

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(model: BannerModel) {
        let urlString = model.linkURL
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async { [self] in
                self.bannerImageView.image = UIImage(data: data)
            }
        }
        
    }
    
}

