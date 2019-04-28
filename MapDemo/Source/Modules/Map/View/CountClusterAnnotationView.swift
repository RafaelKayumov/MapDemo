//
//  CountClusterAnnotationView.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation
import Cluster

class CountClusterAnnotationView: ClusterAnnotationView {

    override func configure() {
        super.configure()

        guard let annotation = annotation as? ClusterAnnotation else { return }
        let count = annotation.annotations.count
        let diameter = radius(for: count) * 2
        self.frame.size = CGSize(width: diameter, height: diameter)
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        countLabel.backgroundColor = .clusterColor
    }

    func radius(for count: Int) -> CGFloat {
        if count < 5 {
            return 10
        } else if count < 10 {
            return 12
        } else if count < 100 {
            return 14
        } else if count < 1000 {
            return 18
        } else {
            return 22
        }
    }
}
