//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by PeterDing on 2018/9/3.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var pageControl: UIPageControl!
    
    private var list = [1,2,3,4,5,6,7,8]
   
    private let widthRatio: CGFloat = 0.75
    private let itemSpacing: CGFloat = 30

    private var collectionMargin: CGFloat = 0
    private var itemWidth: CGFloat = 0
 
    
    @IBOutlet weak var mainCollectionView: UICollectionView!{
        didSet {
            mainCollectionView.dataSource = self
            mainCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl = UIPageControl()
        pageControl.currentPage = 0
         self.pageControl.numberOfPages = list.count
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as! InfoCollectionViewCell
        cell.infoLabel.text = String(list[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemWidth = collectionView.bounds.width * widthRatio
        collectionMargin = collectionView.bounds.width * ( 1 - widthRatio) / 2
        return CGSize(width: itemWidth, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: collectionMargin, bottom: 0, right: collectionMargin)
    }
}


extension ViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(mainCollectionView.contentSize.width)
        var newPage = Float(self.pageControl.currentPage)
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}

