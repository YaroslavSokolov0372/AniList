//
//  prepareHTMLDescription.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/01/2024.
//

import Foundation
import SwiftSoup


extension String {
    func prepareHTMLDescription() -> Self {
        let doc = try! SwiftSoup.parse(self)
        let body = doc.body()
        let text = try! body?.text()
        return text!
    }
}
