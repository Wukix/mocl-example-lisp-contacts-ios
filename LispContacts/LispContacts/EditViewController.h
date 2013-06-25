//
//  EditViewController.h
//  ProfileMe
//
//  Created by Wes Henderson on 4/4/13.
//  Copyright (c) 2013 Wukix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController
- (IBAction)onCancel:(id)sender;
- (void)refreshListController;
@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) IBOutlet UITextField *txtMobile;
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UIButton *btnDeleteContact;

@end
