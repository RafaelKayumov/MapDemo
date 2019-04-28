//
//  NSData+Cache.swift
//  MapDemo
//
//  Created by Rafael Kayumov on 28/04/2019.
//  Copyright © 2019 Rafael Kayumov. All rights reserved.
//

import Foundation

extension Data {

    private func writeTo(_ fileName: String) {
        let url = URL.tempURLFor(fileName)
        try? write(to: url, options: .atomicWrite)
    }

    func writeTo(_ fileName: String, completion: @escaping () -> Void = {}) {
        DispatchQueue.global(qos: .background).async {
            self.writeTo(fileName)
            completion()
        }
    }
}
