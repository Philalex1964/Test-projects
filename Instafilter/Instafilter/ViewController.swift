//
//  ViewController.swift
//  Instafilter
//
//  Created by Alexander Filippov on 15.2.22..
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var filterButton: UIButton!
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter = CIFilter(name: "CISepiaTone") {
        didSet {
            filterButton.titleLabel?.text = currentFilter?.name ?? "Choose current filter"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        intensity.value = 0.1
        filterButton.titleLabel?.text = currentFilter?.name ?? "Change filter"
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        filterButton.titleLabel?.text = currentFilter?.name ?? "Change filter"
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter?.inputKeys

        if ((inputKeys?.contains(kCIInputIntensityKey)) == true) {
            currentFilter?.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if ((inputKeys?.contains(kCIInputRadiusKey)) == true) {
            currentFilter?.setValue(intensity.value * 400, forKey: kCIInputRadiusKey)
        }
        
        if ((inputKeys?.contains(kCIInputScaleKey)) == true) {
            currentFilter?.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if ((inputKeys?.contains(kCIInputCenterKey)) == true) {
            currentFilter?.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }

        guard let outputImage = currentFilter?.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }

    // MARK: - Actions
    
    @IBAction func changeFilter(_ sender: UIButton) {
        if (imageView.image == nil) {
            let ac = UIAlertController(title: "Attention!", message: "Please, add a picture first!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            
            present(ac, animated: true)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error!", message: "No image to save found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // MARK:- @objc methods
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
}
