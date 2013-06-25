//
//  ContactItemViewController.m
//  ProfileMe
//
//  Created by Wes Henderson on 4/2/13.
//  Copyright (c) 2013 Wukix. All rights reserved.
//

#import "ContactItemViewController.h"
#include "mocl.h"

@interface ContactItemViewController ()

@end

@implementation ContactItemViewController

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
	// Do any additional setup after loading the view.
    [self refresh];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    //CGPoint location = [sender locationInView:[[sender view] superview]];
    //tapped_mobile_number_p(location.x, location.y);
    //printf("wtf!\n");
}

- (void)refresh
{
    NSString *filename = draw_contact_item();
    [_imageView setImage:[UIImage imageWithContentsOfFile:filename]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}
@end
