import UIKit

class ViewController: UIViewController {

    // 1 Create Semaphore object
    // Value here represents the number of concurrent threads can have access to particular section of code
    let semaphore = DispatchSemaphore(value: 1)

    var _arr = [1,2,3,4,5,6] // Shared resourse

    private(set) var arr: [Int] {
        get {
            return _arr
        }
        set {
            //2
            semaphore.wait()
            _arr = newValue
            //3
            semaphore.signal()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Arr before : \(arr)")

        // A concurrent queue is created to run operations in parallel
        let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)

        // First block of code added to queue for execution
        queue.async {
            self.removeLast()
        }

        // Second block of code added to queue for execution
        queue.async {
            self.removeAll()
        }

    }

    func removeAll() {
        print("Remove all entry")
        arr.removeAll()
        print("Remove all end")
    }

    func removeLast() {
        print("Remove last entry")
        arr.removeLast()
        print("Remove last end")
    }
    
    
}

let semaphore = DispatchSemaphore(value: 1)

var _arr = [1,2,3,4,5,6] // Shared resourse

private(set) var arr: [Int] {
    get {
        return _arr
    }
    set {
        //2
        semaphore.wait()
        _arr = newValue
        //3
        semaphore.signal()
    }
}

func removeAll() {
    print("Remove all entry")
    arr.removeAll()
    print("Remove all end")
}

func removeLast() {
    print("Remove last entry")
    arr.removeLast()
    print("Remove last end")
}

print("Arr before : \(arr)")

// A concurrent queue is created to run operations in parallel
let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)

// First block of code added to queue for execution
queue.async {
    removeLast()
}

// Second block of code added to queue for execution
queue.async {
    removeAll()
}

// Check for current thread space
let current = Thread.current
print ( "current thread", current, current.stackSize)
// create new secondary thread and check the default stack size
let t = Thread()
t.name
= "secondary"
print ("secondary thread with default size",t, t.stackSize)
// create new secondary thread and assign stack size
let t1 = Thread()
t1.name = "secondary1"
t1.stackSize = 4096 * 512 //multiple

print ("New secondary thread with default size",t1, t1.stackSize)

print(Thread.isMainThread)

class Thredtest {
    func createThread() {
//        Thread.detachNewThreadSelector(#selector(print), toTarget: self, with: nil)
        let thread = Thread(target: self, selector: #selector(print),  object:  nil)
        thread.start()
    }
    
    @objc func print() {
        Swift.print("Thread loop running")
    }
}

let threadClass = Thredtest()
threadClass.createThread()

let dispatchQueue = DispatchQueue(label: "queue name")

//let dispatchQueue1 = DispatchQueue(label: <#T##String#>,
//                                   qos: <#T##DispatchQoS#>,
//                                   attributes: <#T##DispatchQueue.Attributes#>,
//                                   autoreleaseFrequency: <#T##DispatchQueue.AutoreleaseFrequency#>,
//                                   target: <#T##DispatchQueue?#>)

print("1st statement")
// execute task syncronously
DispatchQueue.global().sync {
print("syncronous task")
}

print ("next statement")

print("2nd statement")
// execute task syncronously
DispatchQueue.global().async {
print("asyncronous task")
}

print ("next statement1")

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


