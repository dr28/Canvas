//
//  ViewController.swift
//  Canvas
//
//  Created by Deepthy on 10/4/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    
    private var trayOriginalCenter: CGPoint!
    private var trayCenterWhenOpen: CGPoint!
    private var trayCenterWhenClosed: CGPoint!
    private var trayIsOpen: Bool!

    private var newlyCreatedFace: UIImageView!
    private var newFaceOriginalCenter: CGPoint!
    
    private var smileyScale:CGFloat!
    private var smileyRotation:CGFloat!

    private var dragPoint = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupImage()

        trayCenterWhenOpen = CGPoint(x: 187.5, y: 566)
        trayCenterWhenClosed = CGPoint(x: 187.5, y: 726)
        trayView.center = trayCenterWhenClosed
        trayIsOpen = false
    }
    
    private func setupImage() {
        imageView1.image = imageView1.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView1.layer.cornerRadius = imageView1.frame.size.height/2
        
        imageView2.image = imageView2.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView2.layer.cornerRadius = imageView2.frame.size.height/2
        
        imageView3.image = imageView3.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView3.layer.cornerRadius = imageView3.frame.size.height/2
        
        imageView4.image = imageView4.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView4.layer.cornerRadius = imageView4.frame.size.height/2
        
        imageView5.image = imageView5.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView5.layer.cornerRadius = imageView5.frame.size.height/2
        
        imageView6.image = imageView6.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView6.layer.cornerRadius = imageView6.frame.size.height/2
    }

    @IBAction func onTapGesture(_ sender: Any) {

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {

            /*self.trayView.center = self.trayIsOpen ? self.trayCenterWhenClosed : self.trayCenterWhenOpen
            self.trayIsOpen = self.trayIsOpen ? false : true
            self.arrowImageView.transform = self.trayIsOpen ? CGAffineTransform.init(rotationAngle: 0) : CGAffineTransform.init(rotationAngle: CGFloat.pi)
            */
            if self.trayIsOpen {//moving down
                self.trayView.center = self.trayCenterWhenClosed
                self.trayIsOpen = false
                self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: 0)

            } else { //moving down
                self.trayView.center = self.trayCenterWhenOpen
                self.trayIsOpen = true
                self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)

            }
        })
    }
   
    @IBAction func onSmileyImagePanGesture(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: view)

        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            
            imageView.image = imageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.tintColor = UIColor(red: 157/255, green: 69/255, blue: 24/255, alpha: 1)//.brown*/
            newlyCreatedFace.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 7/255, alpha: 1)
            
            newlyCreatedFace.layer.cornerRadius = newlyCreatedFace.frame.size.height/2

            view.addSubview(newlyCreatedFace)
            
            newlyCreatedFace.center = imageView.center
            
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newFaceOriginalCenter = newlyCreatedFace.center

            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.isMultipleTouchEnabled = true
            

            UIView.animate(withDuration: 0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(newFacePanned))
            panGestureRecognizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(newFacePinched))
            pinchGestureRecognizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(newFaceRotated))
            rotationGestureRecognizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
            
        } else if sender.state == .changed {

            newlyCreatedFace.center = CGPoint.init(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newFaceDeleted))
            tapGestureRecognizer.numberOfTapsRequired = 2
            tapGestureRecognizer.delegate = self
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)

            if newlyCreatedFace.center.y > trayView.frame.origin.y {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)

                    self.newlyCreatedFace.center = CGPoint.init(x: self.newFaceOriginalCenter.x, y: self.newFaceOriginalCenter.y)

                }, completion: { (true) in
                    self.newlyCreatedFace.removeFromSuperview()

                })
            }
            else {
                //UIView.animate(withDuration: 0.1, animations: {
                    //self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
                //})
            }
        }
    }
    
    @objc private func newFacePanned(sender: UIPanGestureRecognizer){

        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newFaceOriginalCenter = sender.view?.center
            
        } else if sender.state == .changed {
            sender.view?.center = CGPoint(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {  }
    }
 
    @objc private func newFacePinched(sender: UIPinchGestureRecognizer){
        let scale = sender.scale
        
        if sender.state == .began {
            //print("began: \(scale)")
        } else if sender.state == .changed {
            //print("changed: \(scale)")
            smileyScale = scale
            handlePinchNRotate()
        
        } else if sender.state == .ended { }
    }
    
    @objc private func newFaceRotated(sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        
        if sender.state == .began {
            //print("began: \(rotation)")
        } else if sender.state == .changed {
            //print("changed: \(rotation)")
            smileyRotation = rotation
            handlePinchNRotate()
        } else if sender.state == .ended { }
        
    }
    
    private func handlePinchNRotate(){
        var transform = CGAffineTransform.identity
        if let smileyRotation = smileyRotation{
            transform = transform.rotated(by: smileyRotation)
        }
        if let smileyScale = smileyScale{
            transform = transform.scaledBy(x: smileyScale, y: smileyScale)
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.newlyCreatedFace.transform = transform
            
        })
    }
    
    @objc private func newFaceDeleted(sender: UITapGestureRecognizer) {
        let newFaceImageView = sender.view as! UIImageView
        newFaceImageView.removeFromSuperview()
    }
    
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            
            if trayView.center.y < trayCenterWhenOpen.y {
                dragPoint = dragPoint + 1
                if dragPoint == 10 {
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayOriginalCenter.y + ( translation.y.subtracting(10.0)) + 1.0)
                    self.dragPoint = 0
                }
            } else {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                //velocity.y > 0 -- going down velocity.y < 0 -- going up
                self.trayView.center = velocity.y > 0 ? self.trayCenterWhenClosed : self.trayCenterWhenOpen
                self.trayIsOpen = velocity.y > 0 ? false : true
                self.arrowImageView.transform = velocity.y > 0 ? CGAffineTransform.init(rotationAngle: 0) : CGAffineTransform.init(rotationAngle: CGFloat.pi)
            })
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
