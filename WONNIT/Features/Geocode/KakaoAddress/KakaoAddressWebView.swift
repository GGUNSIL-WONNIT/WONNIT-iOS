//
//  KakaoAddressWebView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/17/25.
//

import SwiftUI
import WebKit

struct KakaoAddressWebView: UIViewRepresentable {
    private let messageHandlerName = "callBackHandler"
    
    let pageURL: URL
    var onAddressPicked: (KakaoAddress) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onAddressPicked: onAddressPicked, messageHandlerName: messageHandlerName)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: messageHandlerName)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        let request = URLRequest(url: pageURL)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        private let onAddressPicked: (KakaoAddress) -> Void
        private let messageHandlerName: String
        
        init(onAddressPicked: @escaping (KakaoAddress) -> Void, messageHandlerName: String) {
            self.onAddressPicked = onAddressPicked
            self.messageHandlerName = messageHandlerName
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == messageHandlerName else { return }
            if let dict = message.body as? [String: Any] {
                let addr = KakaoAddress(
                    roadAddress: dict["roadAddress"] as? String ?? "",
                    jibunAddress: dict["jibunAddress"] as? String ?? "",
                    zonecode: String(describing: dict["zonecode"] ?? "")
                )
                onAddressPicked(addr)
                
                print(addr)
            }
        }
    }
}
