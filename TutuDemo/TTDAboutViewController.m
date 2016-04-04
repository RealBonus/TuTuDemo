//
//  TTDAboutViewController.m
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDAboutViewController.h"

@interface TTDAboutViewController ()

@end

@implementation TTDAboutViewController

- (void)awakeFromNib {
    self.title = NSLocalizedString(@"About_window_Title", @"About window title");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    self.versionLabel.text = [NSString stringWithFormat:@"v%@ (%@)", appVersion, buildVersion];
    self.productLabel.text = NSLocalizedString(@"Product_full_name", @"App name on About page");
    self.copyrightTextView.text = NSLocalizedString(@"COPYRIGHT", @"Full copyright");
    
    /**
     * Another bug: if we set 'selectable = NO' in storyboard, textView will reset font and aligment.
     */
    self.copyrightTextView.selectable = NO;
}

@end
