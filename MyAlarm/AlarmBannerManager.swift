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
    
    func showBanner(alarm: Alarm, onStop: @escaping () -> Void, onSnooze: @escaping () -> Void) {
        guard window == nil else { return } // Prevent multiple banners
        
        let bannerView = AlarmBannerView(
            alarm: alarm,
            onStop: {
                self.dismissBanner()
                print("Stop tapped")
                onStop()
            },
            onSnooze: {
                self.dismissBanner()
                onSnooze()
            }
        )
        
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
        print("🔧 AlarmBannerManager: dismissBanner() called")
        
        if let window = window {
            // Explicitly remove the rootViewController
            window.rootViewController = nil
            window.isHidden = true
            
            // Remove strong reference
            self.window = nil
        }
    }
}

struct AlarmBannerView: View {
    let alarm: Alarm
    var onStop: () -> Void
    var onSnooze: () -> Void

    // Dynamically fetch top safe area inset from active window
    private var topInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: \.isKeyWindow)?
            .safeAreaInsets.top ?? 44
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("⏰")
                Text(alarm.label.isEmpty ? "Alarm" : alarm.label)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                
                if alarm.snoozeDuration > 0 {
                    Button(action: onSnooze) {
                        Text("Snooze")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
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
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, topInset - 2) // Respect notch/Dynamic Island
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.clear)
        .ignoresSafeArea() // Let it flow behind if needed
    }
}
