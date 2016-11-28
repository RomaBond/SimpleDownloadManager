//
//  AddFileVC.swift
//  SimpleDM
//
//  Created by Sam on 11/23/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit
//import RxCocoa


class AddFileVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField:       UITextField!
    @IBOutlet weak var urlField:        UITextField!
    @IBOutlet weak var doneButton:      UIBarButtonItem!
    @IBOutlet weak var changeUrlLable:  UILabel!
    @IBOutlet weak var changeNameLable: UILabel!
  
    var downloadTableVC:DownloadTableVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        urlField.becomeFirstResponder()
    }
    
    func isCorrectFill() -> (Bool)
    {
        var isCorect = true;
        if (urlField.text!.isEqual("") ||
            nameField.text!.isEqual(""))
        {
            isCorect = false
        }
        return isCorect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField.isEqual(urlField))
        {
            nameField .becomeFirstResponder()
        }
        else
        {
            if (isCorrectFill())
            {
                nameField.resignFirstResponder()
                doneButton.isEnabled = true
            }
        }
        return true
    }


    func addDownloadFile() ->()
    {
      let manager = downloadTableVC?.downloadManager
        
      let maxQuantity = manager?.maxDownloadQuantity
      let quantityNow = manager?.downloadFiles.count
      
        if (quantityNow! < maxQuantity!)
        {
         manager?.addDownloadFileForUrl(urlString: urlField.text!,
                                         withName: nameField.text!)
         downloadTableVC?.table.reloadData()
        }
        else
        {
         print("Remove completed downloads")
        }
        
    }
    

    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        addDownloadFile()
        _ = self.navigationController?.popToViewController(self.downloadTableVC!, animated: true)
    }
    
  

   }
