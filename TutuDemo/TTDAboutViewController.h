//
//  TTDAboutViewController.h
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDAboutViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *productLabel;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UITextView *copyrightTextView;

@end
