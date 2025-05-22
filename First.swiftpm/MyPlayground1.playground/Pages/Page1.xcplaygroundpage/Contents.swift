import UIKit
import PlaygroundSupport

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        doMath(a: 2.0, b: 1.0, operation: "+")
    }
    
    func doMath(a: Double, b: Double, operation: String) {
        print("Performing \(operation) on \(a) and \(b)")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 200, width: 500, height: 20)
        label.text = "Check debug area below for math output!"
        label.textColor = .black
        
        // Perform math operation separately
        doMath(a: 2.0, b: 5.0, operation: "+")
        
        view.addSubview(label)
        self.view = view
    }
}

print("Starting playground...")
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = MyViewController()
