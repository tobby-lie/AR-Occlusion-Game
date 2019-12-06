import UIKit

class InstructionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func ritualButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "instructionToAR", sender: self)
    }
}
