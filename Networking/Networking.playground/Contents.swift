import UIKit

var greeting = "Hello, playground"

if let url = URL(string: "https://www.hackingwithswift.com") {
    do {
        let contents = try String(contentsOf: url)
        print(contents)
    } catch {
        // contents could not be loaded
    }
} else {
    // the URL was bad!
}
