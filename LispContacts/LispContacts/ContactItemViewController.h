//
//  ContactItemViewController.h
//  ProfileMe
//
//  Created by Wes Henderson on 4/2/13.
//  Copyright (c) 2013 Wukix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactItemViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
- (void)refresh;
@end
