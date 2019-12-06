import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    private var planes :[Plane] = [Plane]()
    var player: AVAudioPlayer?
    var AssetCount = 0
    
    private var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    func playSound(sound : String, format: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: format) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var popup:UIView!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AssetCount += 1
        let strCount = String(AssetCount)

        if popup != nil { // Dismiss the view from here
          popup.removeFromSuperview()
        }
        
        popup = UIView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))

        let lb = UILabel(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
        
        lb.text="Ghosts Banished: \(strCount)"

        // show on screen
        self.view.addSubview(popup)
        popup.addSubview(lb)
        lb.center = popup.center
    }
    
    @objc func dismissAlert(){
      if popup != nil { // Dismiss the view from here
        popup.removeFromSuperview()
      }
    }
    
    private func animatePlane(to destinationPoint: SCNVector3, node: SCNNode) {
        let action = SCNAction.move(to: destinationPoint, duration: 7)
        node.runAction(action) { [weak self] in
            if let finishNode = self?.sceneView.scene.rootNode.childNode(withName: "finish", recursively: true) {
                finishNode.removeFromParentNode()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            let plane = Plane(anchor: anchor as! ARPlaneAnchor)
            self.planes.append(plane)
            node.addChildNode(plane)
            
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            let x = CGFloat(planeAnchor.transform.columns.3.x)
            let y = CGFloat(planeAnchor.transform.columns.3.y)
            let z = CGFloat(planeAnchor.transform.columns.3.z)
            let position = SCNVector3(x,y,z)

            let fishScene = SCNScene(named: "fish.dae")!
            guard let fishNode = fishScene.rootNode.childNode(withName: "fish", recursively: true) else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `5.0` to the desired number of seconds.
               // Code you want to be delayed
                self.sceneView.scene.rootNode.addChildNode(fishNode)
                fishNode.position = position
            }
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first

        if plane == nil {
            return
        }

        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }

    //Method called when tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        
           if rec.state == .ended {
                guard let sceneView = rec.view as? ARSCNView else{
                    return
                }
                let location = rec.location(in: sceneView)
                let hits = self.sceneView.hitTest(location, options: nil)
                let tempCount = self.sceneView.scene.rootNode.childNodes.count
                if let hitTest = hits.first {
                        
                    let touchedNode = hitTest.node
                    touchedNode.isHidden = true

                    if self.sceneView.scene.rootNode.childNodes.count < tempCount {
                        score = score + 1
                    }
                }
           }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
