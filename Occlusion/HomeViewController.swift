import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    var backGroundPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playBackgroundMusic(fileNamed: "GoodNight.mp3")
        
    }
    
    func playBackgroundMusic (fileNamed: String) {
        let url = Bundle.main.url(forResource: fileNamed, withExtension: nil)
        
        guard let newUrl = url else {
            print("Could not find file called \(fileNamed)")
            return
        }
        do {
            backGroundPlayer = try AVAudioPlayer(contentsOf: newUrl)
            backGroundPlayer.numberOfLoops = -1
            backGroundPlayer.prepareToPlay()
            backGroundPlayer.play()
        }
        catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func startButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToInstruction", sender: self)
    }
}
