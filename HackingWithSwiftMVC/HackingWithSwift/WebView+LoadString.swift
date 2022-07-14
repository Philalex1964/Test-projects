//
//  WebView+LoadString.swift
//  HackingWithSwift
//
//  Created by Aleksandar Filipov on 7/14/22.
//  Copyright © 2022 Hacking with Swift. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        let request = URLRequest(url: url)
        load(request)
    }
}
