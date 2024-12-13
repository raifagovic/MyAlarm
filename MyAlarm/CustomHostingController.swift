//
//  CustomHostingController.swift
//  MyAlarm
//
//  Created by Raif Agovic on 13. 12. 2024..
//

import SwiftUI

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black // Set the background to black
    }
}
