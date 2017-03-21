//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 06.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var colorText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var aboutUserLabel: UILabel!
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var userImageLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var colorButton1: UIButton!
    
    @IBOutlet weak var colorButton2: UIButton!
    
    @IBOutlet weak var colorButton3: UIButton!
    
    @IBOutlet weak var colorButton4: UIButton!
    
    @IBOutlet weak var colorButton5: UIButton!
    
    
    
    
    let picker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        view.addGestureRecognizer(tapGesture)
        nameField.delegate = self
        let tapImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTaped))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapImageGestureRecognizer)
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        // Debug info
        print("######################################")
        print("\(#function)")
        self.printDebug()
        print("######################################")
    }
    override func viewWillAppear(_ animated: Bool) {
        // Debug info
        print("######################################")
        print("\(#function)")
        self.printDebug()
        print("######################################")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Debug info
        print("######################################")
        print("\(#function)")
        self.printDebug()
        print("######################################")
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Debug info
        print("######################################")
        print("\(#function)")
        self.printDebug()
        print("######################################")
    }
    override func viewDidDisappear(_ animated: Bool) {
        // Debug info
        print("######################################")
        print("\(#function)")
        self.printDebug()
        print("######################################")
    }
    
    
    
    func printDebug(){
        print("nameField: "+nameField.description)
        print("colorText: "+colorText.description)
        print("userImage: "+userImage.description)
        print("aboutUserLabel: "+aboutUserLabel.description)
        print("aboutTextView: "+aboutTextView.description)
        print("userImageLabel: "+userImageLabel.description)
        print("saveButton: "+saveButton.description)
        print("colorButton1: "+colorButton1.description)
        print("colorButton2: "+colorButton2.description)
        print("colorButton3: "+colorButton3.description)
        print("colorButton4: "+colorButton4.description)
        print("colorButton5: "+colorButton5.description)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func onTapAction(){
        view.endEditing(true)
    }
    
    func imageTaped(){
        let alert = UIAlertController(title: "Выбрать фото профиля", message:nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { action in
        })
        alert.addAction(UIAlertAction(title: "Удалить фото", style: .destructive) { action in
            self.userImage.image = UIImage(named: "placeholder-user")
        })
        alert.addAction(UIAlertAction(title: "Выбрать фото", style: .default) { action in
            self.present(self.picker, animated: true, completion: nil)
        })

        self.present(alert, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Debug info
        print("######################################")
        print("\(#function)")
        self.printDebug()
        print("######################################")
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveAction(_ sender: Any) {
        print("Сохранение данных профиля")
    }
    
    @IBAction func colorButtonTaped(_ sender: UIButton) {
        colorText.textColor = sender.backgroundColor
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.userImage.image = chosenImage
        // use the image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

}

