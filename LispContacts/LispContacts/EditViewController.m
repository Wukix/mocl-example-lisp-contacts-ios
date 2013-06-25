//
//  EditViewController.m
//  ProfileMe
//
//  Created by Wes Henderson on 4/4/13.
//  Copyright (c) 2013 Wukix. All rights reserved.
//

#import "EditViewController.h"
#import "ContactItemViewController.h"
#import "WuViewController.h"
#include "mocl.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (is_new_contact()) {
        [_btnDeleteContact setHidden:YES];
        [self setTitle:@"New Contact"];
    }
    else {
        [_btnDeleteContact setHidden:NO];
        [self setTitle:@"Edit"];
    }
    
    [_txtName setText:get_contact_name()];
    [_txtMobile setText:get_contact_mobile()];
    [_txtEmail setText:get_contact_email()];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDoneTap:(id)sender {
    [[self view] endEditing:YES];
    update_contact([_txtName text], [_txtMobile text], [_txtEmail text]);
    save_contacts();
    
    if ([[[self navigationController] viewControllers] count] > 1) {
        id maybeItemController = [[[self navigationController] viewControllers] objectAtIndex:1];
        if ([maybeItemController respondsToSelector:@selector(refresh)]) {
            [maybeItemController refresh];
        }
    }
    
    [self refreshListController];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)refreshListController {
    WuViewController *listController = [[[self navigationController] viewControllers] objectAtIndex:0];
    [listController refresh];
}

- (IBAction)onDeleteTap:(id)sender {
    delete_contact();
    [self refreshListController];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [_txtName release];
    [_txtMobile release];
    [_txtEmail release];
    [_btnDeleteContact release];
    [super dealloc];
}
@end
