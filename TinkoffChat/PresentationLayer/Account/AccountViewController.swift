//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 06.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var colorText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var aboutUserLabel: UILabel!
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var userImageLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveButtonOperations: UIButton!
    
    
    @IBOutlet weak var colorButton1: UIButton!
    
    @IBOutlet weak var colorButton2: UIButton!
    
    @IBOutlet weak var colorButton3: UIButton!
    
    @IBOutlet weak var colorButton4: UIButton!
    
    @IBOutlet weak var colorButton5: UIButton!
    let GCDManager: GCDDataManager = GCDDataManager()
    let operationManager: OperationDataManager = OperationDataManager()
    let coreDataManager: StorageManager = StorageManager()
    
    
    var saving: Bool  = false{
        didSet{
            if(saving){
                activityIndicator.startAnimating()
                saveButton.isEnabled = false
                saveButtonOperations.isEnabled = false
            }
            else{
                activityIndicator.stopAnimating()
                saveButton.isEnabled = true
                saveButtonOperations.isEnabled = true
            }
        }
    }
    
    let picker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configurateController()
        //GCDManager.retrive(closure: self.setInfo)
        coreDataManager.retrive(closure: self.setInfo)

    }
    func configurateController(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        view.addGestureRecognizer(tapGesture)
        nameField.delegate = self
        let tapImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTaped))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapImageGestureRecognizer)
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        activityIndicator.hidesWhenStopped = true
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
    
    
    
    func setInfo(user:UserData?){
        if let data = user{
            self.userImage.image = data.image
            self.aboutTextView.text = data.about
            self.colorText.textColor = data.color
            self.nameField.text = data.name
            
        }
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saving = true
        let toSaveObject = UserData(name: nameField.text, image: userImage.image, about: aboutTextView.text, color: colorText.textColor)
        if let sender = sender as? UIButton{
            switch sender.tag {
            case 1:
                print("GCD")
                GCDManager.save(object: toSaveObject, closure: { 
                    self.saveClosure()
                })
            case 2:
                print("Operation")
                operationManager.save(object: toSaveObject, closure: {
                    self.saveClosure()
                })
            case 3:
                print("CoreData")
                coreDataManager.save(object: toSaveObject, closure: {
                    self.saveClosure()
                })
            default:
                print("default")
            }
        }
    }
    
    func saveClosure(){
        self.saving = false
        let alert = UIAlertController(title: "Сохранение успешно", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
        self.present(alert, animated: true)
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
    
    @IBAction func cancelTaped(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}

