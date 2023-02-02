//
//  BannerCell.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//


import UIKit
import Combine

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!

    private var cancellables: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
        bannerImageView.image = nil
    }
    
    func configure(model: BannerModel) {
      
    }
    
    func willDisplay(model: BannerModel) {
        let urlString = model.linkURL
        guard let url = URL(string: urlString) else { return }
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: bannerImageView)
            .store(in: &cancellables)
    }
    
}

