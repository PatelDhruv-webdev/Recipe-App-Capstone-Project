//
//  File.swift
//  Capstone-Recipe-app
//
//  Created by Dhruv Patel on 08/06/24.
//


import Foundation

class Recipe {
    var title: String
    var description: String
    var imageName: String // This should match an image in your asset catalog

    init(title: String, description: String, imageName: String) {
        self.title = title
        self.description = description
        self.imageName = imageName
    }
}
