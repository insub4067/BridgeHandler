//
//  WebView.swift
//  TEST
//
//  Created by 김인섭 on 2023/06/28.
//

import SwiftUI
import WebKit
import Combine

struct WebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        context.coordinator.webView = .init()
        context.coordinator.webView.configuration.userContentController.add(context.coordinator, name: BridgeRequest.name)
        return context.coordinator.webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        .init()
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        
        var webView: WKWebView!
        var cancellable = Set<AnyCancellable>()
        weak var navigator: Navigator?
        
        override init() {
            super.init()
            addKeyboardObserver()
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            
            BridgeHandler.handle(message: message, navigator: navigator)
        }
        
        func addKeyboardObserver() {
            
            NotificationCenter
                .default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.webView.scrollView.setContentOffset(.zero, animated: false)
                }
                .store(in: &cancellable)
            
            NotificationCenter
                .default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.webView.scrollView.setContentOffset(.zero, animated: false)
                }
                .store(in: &cancellable)
        }
    }
}

struct BridgeHandler {
    
    static func handle(message: WKScriptMessage, navigator: Navigator?) {
        
        guard let request = BridgeRequest(message: message)
        else { return }
        
        switch request.function {
            
        case .goHome:
            break
        case .goProfile:
            break
        case .goWebView:
            break
        }
    }
}

struct BridgeRequest {
    
    static let name = "toNative"
    
    var function: BridgeFunction
    var parameters: [String: Any]
    
    init?(message: WKScriptMessage) {
        
        guard message.name == Self.name,
              let body = message.body as? [String: Any],
              let functionString = body["function"] as? String,
              let function = BridgeFunction(rawValue: functionString),
              let parameters = body["parameters"] as? [String: Any]
        else { return nil }
        
        self.function = function
        self.parameters = parameters
    }
}

enum BridgeFunction: String {
    
    case goHome, goProfile, goWebView
}

class Navigator {
    
    func navigate(to: UIViewController) {
        
    }
}
