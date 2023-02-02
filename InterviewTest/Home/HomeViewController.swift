//
//  ViewController.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/1.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var usdAmountLabel: UILabel!
    @IBOutlet weak var khrAmountLabel: UILabel!
    @IBOutlet weak var floatingView: UIView! {
        didSet {
            floatingView.layer.cornerRadius = 25
            floatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
            floatingView.layer.shadowOpacity = 0.1
            floatingView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    @IBOutlet weak var bannerLoadingLabel: UILabel! {
        didSet {
            bannerLoadingLabel.layer.cornerRadius = 6
            bannerLoadingLabel.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var bannerLoaingView: UIView! {
        didSet {
            bannerLoaingView.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var bannerCollectionView: UICollectionView!

    @IBOutlet weak var pageControl: UIPageControl!
    
    private var cancellables: Set<AnyCancellable> = []
    
    let refreshControl = UIRefreshControl()
    
    let viewModel = HomeViewModel()
    var favoriteModels: [FavoriteModel] = []
    var bannerModels: [BannerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        refreshControl.attributedTitle = NSAttributedString(string: "重新載入")
        scrollView.refreshControl = refreshControl
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 71, right: 0)
     
        configBannerCollectioView()
        configFavoriteCollectioView()

        bindEvent()
        bindUI()
    }
    
    func configBannerCollectioView() {
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        let flowLayout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.size.width - 48
        flowLayout?.itemSize = .init(width: width, height: 80)
        flowLayout?.estimatedItemSize = .zero
    }
    
    func configFavoriteCollectioView() {
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        let flowLayout = favoriteCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = .init(width: 80, height: 88)
        flowLayout?.estimatedItemSize = .zero
    }
    
    func bindEvent() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        eyeButton.addTarget(self, action: #selector(clickEyes), for: .touchUpInside)
        bellButton.addTarget(self, action: #selector(clickBell), for: .touchUpInside)
    }
    
    func bindUI() {
        Publishers.CombineLatest(viewModel.$usdAccountBalance, viewModel.$hiddenBalance)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] balance, hiddenBalance in
                self?.usdAmountLabel.text = hiddenBalance ? "********": balance.description
            }).store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.$hkrAccountBalance, viewModel.$hiddenBalance)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] balance, hiddenBalance in
                self?.khrAmountLabel.text = hiddenBalance ? "********": balance.description
            }).store(in: &cancellables)
        
        viewModel.$hiddenBalance
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] hiddenBalance in
            let image = hiddenBalance ? UIImage(named: "iconEye02Off") : UIImage(named: "iconEye01On")
            self?.eyeButton.setImage(image, for: .normal)
        }).store(in: &cancellables)
        
        viewModel.$refreshing
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] refreshing in
                self.refreshControl.endRefreshing()
            }).store(in: &cancellables)
        
        viewModel.$hasNotice
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] hasNotice in
                let image = hasNotice ? UIImage(named: "iconBell02Active") : UIImage(named: "iconBell01Nomal")
                self?.bellButton.setImage(image, for: .normal)
            }).store(in: &cancellables)
        
        viewModel.$favoriteModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] models in
                self.favoriteModels = models
                self.favoriteCollectionView.reloadData()
                self.favoriteCollectionView.isHidden = models.isEmpty
            }).store(in: &cancellables)
        
        viewModel.$bannerModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] models in
                self.bannerModels = models
                self.pageControl.numberOfPages = models.count
                self.bannerCollectionView.reloadData()
                self.bannerCollectionView.isHidden = models.isEmpty
            }).store(in: &cancellables)
    }
    
    @objc func refresh() {
        viewModel.refresh(firstOpen: false)
    }
    
    @objc func clickEyes() {
        viewModel.reverseEyes()
    }
    
    @objc func clickBell() {
        performSegue(withIdentifier: "homeToNotification", sender: nil)
    }


}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favoriteCollectionView {
            return favoriteModels.count
        } else {
            return bannerModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == favoriteCollectionView,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell {
            let model = favoriteModels[indexPath.row]
            cell.configure(model: model)
            return cell
        } else if collectionView == bannerCollectionView,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCell {
            let model = bannerModels[indexPath.row]
            cell.configure(model: model)
            return cell
        }else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = scrollView.contentOffset.x / scrollView.bounds.width
            pageControl.currentPage = Int(page)
    }
}

