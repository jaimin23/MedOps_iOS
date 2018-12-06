//
//  EvaluationDetailsController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-11.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import AVFoundation
import Swime    
import UPCarouselFlowLayout

class EvaluationDetailsController: UIViewController {
    

    @IBOutlet weak var evalDataImage: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var audioPlayerView: UIView!
    
    @IBOutlet weak var questionScroller: UICollectionView!
    var evaluation: Evaluation?
    var audioPlayer = AVAudioPlayer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionScroller.delegate = self
        questionScroller.dataSource = self
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60, height: 200)
        layout.scrollDirection = .horizontal
        questionScroller.collectionViewLayout = layout

        //set the image being displayed
        if let eval = evaluation {
            let mimeType = Swime.mimeType(data: eval.imageData)
            if(mimeType?.type == .jpg){
                audioPlayerView.isHidden = true
                let image = UIImage(data: eval.imageData)
                evalDataImage.image = image
            }
            else{
                evalDataImage.isHidden = true
                do{
                    audioPlayer = try AVAudioPlayer(data: eval.imageData)
                }catch{
                    print("Error \(error)")
                }
            }
        }
        
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        audioPlayer.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EvaluationDetailsController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (evaluation?.responses.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = questionScroller.dequeueReusableCell(withReuseIdentifier: "questionScroller", for: indexPath) as! QuestionCollectionCell
        
        cell.questionTitleText.text = evaluation?.responses[indexPath.row].questionText
        cell.answerLabelText.text = evaluation?.responses[indexPath.row].answerText
        
        return cell
    }
    
    
}
