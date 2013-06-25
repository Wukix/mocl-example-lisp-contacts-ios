//
//  WuViewController.h
//  ProfileMe
//
//  Created by Wes Henderson on 2/15/13.
//  Copyright (c) 2013 Wukix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *ImgMain;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnPlus;
@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
- (void)refresh;
@end
