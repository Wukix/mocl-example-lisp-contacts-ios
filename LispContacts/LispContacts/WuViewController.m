//
//  WuViewController.m
//  ProfileMe
//
//  Created by Wes Henderson on 2/15/13.
//  Copyright (c) 2013 Wukix. All rights reserved.
//

#import "WuViewController.h"
#include "mocl.h"

@interface WuViewController ()

@end

@implementation WuViewController

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if (handle_list_tap(location.y)) {
        [self performSegueWithIdentifier:@"TestSegue" sender:self];
    }
}

- (IBAction)onPlusTap:(id)sender {
    add_new_contact();
    [self performSegueWithIdentifier:@"NewContactSegue" sender:self];
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tapRecognizer addTarget:self action:@selector(handleSingleTap:)];
   // [_tapRecognizer addTarget:_ImgMain action:@selector(handleSingleTap:)];
    
    NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
    NSString *fontpath = [appFolderPath stringByAppendingString:@"/DejaVuSans.ttf"];
    set_font_path(fontpath);
    
    set_doc_dir([self applicationDocumentsDirectory]);
    set_temp_dir(NSTemporaryDirectory());
    
    load_contacts();
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    [self refresh];
}

- (void)refresh
{
    set_view_dimensions((int)[_scrollMain bounds].size.width * 2, (int)[_scrollMain bounds].size.height * 2);
    NSString *filename = draw_contact_list();
    UIImage *image = [UIImage imageWithContentsOfFile:filename];
    [_ImgMain setImage:image];
    [_ImgMain sizeToFit];
    [_scrollMain setContentSize:CGSizeMake([_scrollMain bounds].size.width, [image size].height + 300.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_ImgMain release];
    [_scrollMain release];
    [_btnPlus release];
    [_tapRecognizer release];
    [super dealloc];
}
@end
