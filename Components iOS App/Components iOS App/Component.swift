//
//  Component.swift
//  Components iOS App
//
//  Created by Dhruv Patel on 19/07/24.
//
import Foundation

enum ComponentType {
    case textInputOutput
    case control
    case containerView
    case list
}

struct Component: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let type: ComponentType
}
