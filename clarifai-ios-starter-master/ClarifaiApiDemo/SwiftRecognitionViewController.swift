//
//  SwiftRecognitionViewController.swift
//  ClarifaiApiDemo
//

import UIKit

/**
 * This view controller performs recognition using the Clarifai API.
 */
class SwiftRecognitionViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!

    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)

    @IBAction func buttonPressed(sender: UIButton) {
        // Show a UIImagePickerController to let the user pick an image from their library.
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.allowsEditing = false
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // The user picked an image. Send it to Clarifai for recognition.
            imageView.image = image
            textView.text = "Recognizing..."
            button.enabled = false
            recognizeImage(image)
        }
    }

    private func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var foodlist : [String] = ["banana", "apple", "orange", "pepper", "avocado", "lemon", "ham", "salmon", "pork", "chicken", "egg", "milk", "tomato", "noodles", "cheddar"]
        var foodfound : [String] = []
        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!

        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                for n in results![0].tags{
                    if foodlist.contains(n){
                        foodfound.append(n)
                    }
                }
                self.textView.text = "Tags:\n" + foodfound.joinWithSeparator(", ")
            }
            self.button.enabled = true
        }
    }
}
