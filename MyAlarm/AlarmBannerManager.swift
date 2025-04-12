//
//  AlarmBannerManager.swift
//  MyAlarm
//
//  Created by Raif Agovic on 10. 4. 2025..
//

import SwiftUI
import UIKit

class AlarmBannerManager {
    static let shared = AlarmBannerManager()
    private var window: UIWindow?
    
    func showBanner(alarm: Alarm, onStop: @escaping () -> Void) {
        guard window == nil else { return } // Prevent multiple banners
        
        let bannerView = AlarmBannerView(alarm: alarm, onStop: {
            self.dismissBanner()
            onStop()
        })
        
        let hostingController = UIHostingController(rootView: bannerView)
        hostingController.view.backgroundColor = .clear
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: scene)
            window.rootViewController = hostingController
            window.windowLevel = .alert + 1 // Ensure it appears on top
            window.backgroundColor = .clear
            window.isHidden = false
            
            self.window = window
        }
    }
    
    func dismissBanner() {
        window?.isHidden = true
        window = nil
    }
}

struct AlarmBannerView: View {
    let alarm: Alarm
    var onStop: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("⏰")
                    Text(alarm.label.isEmpty ? "Alarm" : alarm.label)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: onStop) {
                        Text("Stop")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, geometry.safeAreaInsets.top)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

func triggerAlarmBanner(alarm: Alarm) {
    AlarmBannerManager.shared.showBanner(alarm: alarm) {
        print("Alarm Stopped")
    }
}

