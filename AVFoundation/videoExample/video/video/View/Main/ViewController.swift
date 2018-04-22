//
//  ViewController.swift
//  video
//
//  Created by Seong ho Hong on 2018. 4. 21..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet var videoListCollectionView: UICollectionView!
    var imagePicker: UIImagePickerController!
    var videoURLs = [NSURL]()
    var currentTableIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        videoListCollectionView.dataSource = self
        videoListCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addVideoClip(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addVideoURL(url: NSURL) {
        videoURLs.append(url)
        self.videoListCollectionView.reloadData()
    }
    
    func previewImageFromVideo(url: NSURL) -> UIImage? {
        let asset = AVAsset(url: url as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print(error)
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            if let indexPath = videoListCollectionView.indexPathsForSelectedItems {
                let videoURL = videoURLs[indexPath[0].row]
                if let videoPlayer = segue.destination as? VideoPlayer {
                    videoPlayer.videoURL = videoURL
                }
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let theImagePath:NSURL = info["UIImagePickerControllerMediaURL"] as! NSURL
        addVideoURL(url: theImagePath)
        
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: "videoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        
        if let previewImage = previewImageFromVideo(url: videoURLs[indexPath.row]) {
            cell.putVideo(info: previewImage)
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 325)
    }
}
