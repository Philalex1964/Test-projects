//
//  ViewController.swift
//  Multithreading
//
//  Created by Aleksandar Filipov on 6/20/22.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    var arr = [1,2,3,4,5,6] // Shared resourse
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Arr before : \(arr)")
//
//        // A concurrent queue is created to run operations in parallel
//        let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)
//
//        // First block of code added to queue for execution
//        queue.async {
//            self.removeLast()
//        }
//
//        // Second block of code added to queue for execution
//        queue.async {
//            self.removeAll()
//        }
//
//        deadLock()
//    }
//
//    func removeAll() {
//        print("Remove all entry")
//        arr.removeAll()
//        print("Remove all end")
//    }
//
//    func removeLast() {
//        print("Remove last entry")
//        arr.removeLast()
//        print("Remove last end")
//    }
//
//    func deadLock() {
//        let serialQueue = DispatchQueue(label: "test.serialQueue")
//
//        serialQueue.sync {
//            print("In sync operation 1")
//            serialQueue.sync {
//                /*
//                 The code inside this closure should also be executed synchronously and on the same queue that is still executing the outer closure
//                 It will keep waiting for it to finish
//                 It will never be executed
//                 Deadlock.
//                 */
//                print("In sync operation 2")
//            }
//        }
//    }
//
//}

//import UIKit
//
//class ViewController: UIViewController {
//
//    // 1 Create Semaphore object
//    // Value here represents the number of concurrent threads can have access to particular section of code
//    let semaphore = DispatchSemaphore(value: 1)
//
//    var _arr = [1,2,3,4,5,6] // Shared resourse
//
//    private(set) var arr: [Int] {
//        get {
//            return _arr
//        }
//        set {
//            //2
//            semaphore.wait()
//            _arr = newValue
//            //3
//            semaphore.signal()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Arr before : \(arr)")
//
//        // A concurrent queue is created to run operations in parallel
//        let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)
//
//        // First block of code added to queue for execution
//        queue.async {
//            self.removeLast()
//        }
//
//        // Second block of code added to queue for execution
//        queue.async {
//            self.removeAll()
//        }
//
//    }
//
//    func removeAll() {
//        print("Remove all entry")
//        arr.removeAll()
//        print("Remove all end")
//    }
//
//    func removeLast() {
//        print("Remove last entry")
//        arr.removeLast()
//        print("Remove last end")
//    }
//}

import UIKit


struct Product {
    let name: String
    let cost: Int
    let image: UIImage
}

final class Network {
    private let urlSession = URLSession(configuration: .default)

    func getProducts(for userId: String, completion: @escaping ([Product]) -> Void) {
        guard let url = URL(string: "baseURL/products/user/\(userId)") else {
            completion([])
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        urlSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion([Product(name: "Just an example", cost: 1000, image: UIImage())])
            }
        }
    }
}

final class ViewController: UIViewController {
    private let network: Network
    private var products: [Product]
    private let userId: String = "user-id"
    required init?(coder: NSCoder) {
        fatalError()
    }
    init(network: Network, products: [Product]) {
        self.network = network
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
    override func loadView() {
        view = UIView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getProducts()
    }
    private func getProducts() {
        network.getProducts(for: userId) { [weak self] products in
            self?.products = products
        }
    }
}
