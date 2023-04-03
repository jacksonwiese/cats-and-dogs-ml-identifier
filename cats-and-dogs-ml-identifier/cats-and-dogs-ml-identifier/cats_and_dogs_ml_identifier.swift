//
//  cats_and_dogs_ml_identifierApp.swift
//  cats-and-dogs-ml-identifier
//
//  Created by Jackson Wiese on 4/3/23.
//

import SwiftUI

@main
struct cats_and_dogs_ml_identifier: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: AnimalModel())
        }
    }
}
