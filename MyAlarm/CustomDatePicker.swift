//
//  CustomDatePicker.swift
//  MyAlarm
//
//  Created by Raif Agovic on 11. 1. 2025..
//

import SwiftUI
import UIKit

// Custom UIViewRepresentable for UIKit DatePicker
struct CustomDatePicker: UIViewRepresentable {
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        
        // UIDatePicker setup
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setDate(selectedDate, animated: false)
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        
        // Add highlight effect
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        highlightView.layer.cornerRadius = 10
        highlightView.clipsToBounds = true
        
        // Add to container
        container.addSubview(highlightView)
        container.addSubview(datePicker)
        
        // Constraints
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            highlightView.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
            highlightView.heightAnchor.constraint(equalToConstant: 40),
            highlightView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            highlightView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: container.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let datePicker = uiView.subviews.first(where: { $0 is UIDatePicker }) as? UIDatePicker {
            datePicker.setDate(selectedDate, animated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomDatePicker
        
        init(_ parent: CustomDatePicker) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selectedDate = sender.date
        }
    }
}
