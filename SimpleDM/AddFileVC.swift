//
//  AddFileVC.swift
//  SimpleDM
//
//  Created by Sam on 11/23/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit
//import RxCocoa


class AddFileVC: UIViewController {

    @IBOutlet weak var nameField:       UITextField!
    @IBOutlet weak var urlField:        UITextField!
    @IBOutlet weak var doneButton:      UIBarButtonItem!
    @IBOutlet weak var changeUrlLable:  UILabel!
    @IBOutlet weak var changeNameLable: UILabel!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//       let nameValid = nameField.rx_text
//           .map {$0.charactets.count>=1}
//           .shareReplay(1)
//        
//        let urlValid = urlField.rx_text
//            .map {$0.charactets.count>=1}
//            .shareReplay(1)
       
      //  let everyThingValid = Observate.combine
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    -(void)addDownloadFile
//    {
//    NSInteger maxQuantity = self.mainViewController.DM.maxDownloadQuantity ;
//    NSInteger quantityNow = [self.mainViewController.DM.downloadFiles count];
//    
//    if(quantityNow <maxQuantity ){
//    [self.mainViewController.DM addDownloadFileForUrl:self.url.text
//    withName:self.titleName.text];
//    [self.mainViewController.table reloadData];
//    }
//    else
//    {
//    UIAlertController *alertController = [UIAlertController
//    alertControllerWithTitle:@"Max quantity"
//    message:@"Remove completed downloads"
//    preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
//    style:UIAlertActionStyleDefault
//    handler:nil];
//    [alertController addAction:ok];
//    
//    [self presentViewController:alertController
//    animated:YES
//    completion:nil];
//    
//    }
//    }


   }
