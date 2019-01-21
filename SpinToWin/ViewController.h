//
//  ViewController.h
//  SpinToWin
//
//  Created by Sergey on 20/01/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;
@import Foundation;

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *star1;
@property (weak, nonatomic) IBOutlet UILabel *star2;
@property (weak, nonatomic) IBOutlet UILabel *star3;
@property (weak, nonatomic) IBOutlet UILabel *star4;
@property (weak, nonatomic) IBOutlet UILabel *star5;
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property NSInteger currentGrade;
@property NSInteger oldCurrentGrade;
@property NSInteger currentLevel;
@property NSInteger oldCurrentLevel;
@property NSInteger currentScore;
@property NSInteger currentTriangle;
@property NSInteger previousTriangle;
@property Boolean transitonFinish;
@property NSInteger hod;

@end

