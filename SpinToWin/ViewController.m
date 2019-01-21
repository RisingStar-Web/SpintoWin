//
//  ViewController.m
//  SpinToWin
//
//  Created by Sergey on 20/01/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

@end

@implementation ViewController

NSMutableString *_currentPage;
NSString *_path;

int color1triangle, color1nextTriangle,
    color2triangle, color2nextTriangle,
    color3triangle, color3nextTriangle,
    color4triangle, color4nextTriangle,
    color5triangle, color5nextTriangle;

bool touchViewOnOf;

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentScore"];
    if (_currentScore<1) _currentScore=100;
    [[NSUserDefaults standardUserDefaults] setInteger:_currentScore forKey:@"CurrentScore"];
    
    _currentPage =  [[[NSBundle mainBundle] pathForResource:@"game" ofType:@"html"] mutableCopy];
    
    NSData *htmlData = [NSData dataWithContentsOfFile:_currentPage];
    _path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:_path];
    [_webView setOpaque:NO];
//    [_webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
    [_webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:baseURL];
    
    _webView.navigationDelegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
//    RedPentacle.hidden = YES;
    
    touchViewOnOf = TRUE;
    
    _touchView.userInteractionEnabled = YES;
    
    _currentLevel = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentLevel"];
    ////////NSLog(@"_currentLevel = %i", _currentLevel);
    if ((_currentLevel <= 0)||(_currentLevel >24)) {
        _currentLevel = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentLevel forKey:@"CurrentLevel"];
    }
    _currentGrade = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentGrade"];
    ////////NSLog(@"_currentGrade = %i", _currentGrade);
    if ((_currentGrade <= 1)||(_currentGrade >31)) {
        _currentGrade = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentGrade forKey:@"CurrentGrade"];
    }
    
    _currentScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentScore"];
    if (_currentScore<1) _currentScore=0;
    
    _currentScoreLabel.text =  [NSString stringWithFormat:@"%d", _currentScore];
    if (_currentScore == 100)  {
        _currentScoreLabel.text =  [NSString stringWithFormat:@"%@", NSLocalizedString(@"Collect one color", nil) ];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"changedLevelOrGrade"]) {
        [self newLevelStart];
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"changedLevelOrGrade"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self setLevelLetter];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    touchViewOnOf = FALSE;
    
    _touchView.userInteractionEnabled = NO;
    
    _oldCurrentLevel = _currentLevel;
    _oldCurrentGrade = _currentGrade;
    // [self saveLastphrase:nil];
    //Let iPhone  sleeping
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //[self stopTimer];
    [super viewDidDisappear:animated];
}

- (int)randomColor {
    int randomValue = arc4random_uniform(_currentLevel+6) + 1;
    // //////NSLog(@"randomColor = %i", randomValue);
    return randomValue;
}

- (void) showHideLocks {
    if (_currentGrade==1)
    {
        
        // _star1.text = @"";
        // _star2.text = @"";
        //  _star3.text = @"";
        // _star4.text = @"";
        // _star5.text = @"";
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
        
    }
    else if (_currentGrade==2)
    {
        
        _star1.text = @"🙈";
        //  _star2.text = @"";
        // _star3.text = @"";
        // _star4.text = @"";
        // _star5.text = @"";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    else if (_currentGrade==3)
    {
        
        _star3.text = @"🙈";
        _star5.text = @"🙈";
        //visible hidden
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==4)
    {
        // _star1.text = @"";
        //  _star2.text = @"";
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        //  _star5.text = @"";
        //visible hidden
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    } else if (_currentGrade==5)
    {
        _star1.text = @"🙈";
        _star2.text = @"🙈";
        
        _star4.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    else if (_currentGrade==6)
        //Правый закрытый замок и левый открытый замок
    {
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        _star5.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==7)
        // Правый закрытый замок,  нижний и левый - открытые замки
    {
        _star1.text = @"🙈";
        _star2.text = @"🙈";
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    else if (_currentGrade==8)
        // Правый и левый закрытые замки
    {
        _star1.text = @"🙈";
        _star2.text = @"🙈";
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        _star5.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==9)
        // Правый и левый закрытые замки, нижний открытый замок
    {
        _star4.text = @"🛑";
        
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    else if (_currentGrade==10)
        // Все - открытые замки
    {
        _star1.text = @"🛑";
        
        _star3.text = @"🙈";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==11)
        //  Правый закрытый замок, остальные - открытые замки
    {
        _star4.text = @"🛑";
        _star5.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==12)
        //Правый и левый закрытые замки, остальные - открытые замки
    {
        _star1.text = @"🙈";
        _star3.text = @"🛑";
        
        _star5.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==13)
        // Правый, нижний, левый - закрытые замки
    {
        _star1.text = @"🛑";
        _star2.text = @"🙈";
        
        _star4.text = @"🙈";
        
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    else if (_currentGrade==14)
        // Правый, нижний, левый - закрытые замки
    {
        _star2.text = @"🛑";
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        _star5.text = @"🙈";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==15)
    {
        
        _star1.text = @"🙈";
        _star2.text = @"🙈";
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        _star5.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    else if (_currentGrade==16)
    {
        
        _star2.text = @"🛑";
        
        _star4.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    else if (_currentGrade==17)
    {
        
        _star1.text = @"🛑";
        
        _star5.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==18)
    {
        
        _star2.text = @"🛑";
        _star3.text = @"🙈";
        _star4.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==19)
    {
        
        _star1.text = @"🛑";
        _star2.text = @"🙈";
        _star5.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==20)
    {
        
        _star3.text = @"🙈";
        _star4.text = @"🛑";
        _star5.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==21)
    {
        
        _star2.text = @"🛑";
        _star3.text = @"🙈";
        _star4.text = @"🛑";
        _star5.text = @"🙈";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==22)
    {
        _star1.text = @"🙈";
        _star2.text = @"🛑";
        _star3.text = @"🙈";
        _star4.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==23)
    {
        
        _star1.text = @"🙈";
        _star2.text = @"🛑";
        _star3.text = @"🙈";
        _star4.text = @"🛑";
        _star5.text = @"🙈";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==24)
    {
        
        _star1.text = @"🛑";
        _star2.text = @"🙈";
        _star3.text = @"🙈";
        _star4.text = @"🙈";
        _star5.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==25)
    {
        
        _star1.text = @"🛑";
        _star2.text = @"🛑";
        _star4.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==26)
    {
        
        _star1.text = @"🛑";
        
        _star4.text = @"🛑";
        _star5.text = @"🛑";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==27)
    {
        
        _star1.text = @"🙈";
        _star2.text = @"🛑";
        _star3.text = @"🛑";
        _star4.text = @"🛑";
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==28)
    {
        
        _star1.text = @"🛑";
        _star2.text = @"🛑";
        _star3.text = @"🛑";
        _star4.text = @"🙈";
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==29)
    {
        
        _star1.text = @"🙈";
        _star2.text = @"🛑";
        _star3.text = @"🛑";
        _star4.text = @"🛑";
        _star5.text = @"🙈";
        
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    else if (_currentGrade==30)
    {
        
        _star1.text = @"🛑";
        _star2.text = @"🛑";
        _star3.text = @"🛑";
        _star4.text = @"🛑";
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    }
    
    else if (_currentGrade==31)
    {
        
        _star1.text = @"🙈";
        _star2.text = @"🛑";
        _star3.text = @"🛑";
        _star4.text = @"🛑";
        _star5.text = @"🛑";
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'visible';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'visible';" completionHandler:nil];
    }
    
    
}

- (NSString*)ourColors:(int)numberOfCOLOR {
    NSString* ourColorsSTRING = @"#fc7c7e";
    switch(numberOfCOLOR) {
        case 1:
        {
            ourColorsSTRING =    @"#fc7c7e";
            break;
        }
        case 2:
        {
            ourColorsSTRING =    @"#83c9fd";
            break;
        }
        case 3:
        {
            ourColorsSTRING =    @"#f4e443";
            break;
        }
            
        case 4:
        {
            ourColorsSTRING =    @"#b5df36";
            break;
        }
        case 5:
        {
            ourColorsSTRING =    @"#f9ad2a";
            break;
        }
        case 6:
        {
            ourColorsSTRING =    @"#6090c0";
            break;
        }
        case 7:
        {
            ourColorsSTRING =    @"#D2B48C";
            break;
        }
        case 8:
        { // v
            ourColorsSTRING = @"#FFCCCC";
            break;
        }
        case 9:
        { //
            ourColorsSTRING = @"#99CCCC";
            break;
        }
        case 10:
        { // Chartreuse
            ourColorsSTRING =     @"#FF00FF";
            break;
        }
        case 11:
        { // YellowGreen
            ourColorsSTRING =    @"#9ACD32";
            break;
        }
        case 12:
        { // Wheat
            ourColorsSTRING =    @"#40E0D0";
            break;
        }
        case 13:
        { // White
            ourColorsSTRING = @"#9900CC";
            break;
        }
        case 14:
        { // SpringGreen
            ourColorsSTRING =    @"#c8c8c8";
            break;
        }
        case 15:
        { // SteelBlue
            ourColorsSTRING =    @"#4682B4";
            break;
        }
        case 16:
        { // Tan
            ourColorsSTRING =   @"#F5DEB3";
            break;
        }
        case 17:
        { //  Teal
            ourColorsSTRING =    @"#008080";
            break;
        }
        case 18:
        { // Thistle
            ourColorsSTRING =    @"#D8BFD8";
            break;
        }
        case 19:
        { // Tomato
            ourColorsSTRING =    @"#FF6347";
            break;
        }
        case 20:
        { //  Turquoise
            ourColorsSTRING =  @"#FF99CC";
            
            break;
        }
        case 21:
        { // Violet
            ourColorsSTRING =    @"#EE82EE";
            break;
        }
        case 22:
        { // Wheat
            ourColorsSTRING =    @"#00FFFF";
            break;
        }
        case 23:
        { // White
            ourColorsSTRING = @"#00FF7F";
            break;
        }
        case 24:
        { //  Yellow
            ourColorsSTRING =    @"#FFFF00";
            break;
        }
            
        case 25:
        { //
            ourColorsSTRING =     @"#8A2BE2";
            
            break;
        }
        case 26:
        { //  WhiteSmoke
            ourColorsSTRING =    @"#F5F5F5";
            break;
        }
        case 27:
        { //  WhiteSmoke
            ourColorsSTRING =    @"#CC9999";
            break;
        }
        case 28:
            
        { //  WhiteSmoke
            ourColorsSTRING =   @"#7FFF00";
            break;
        }
    }  //
    return ourColorsSTRING;
}

- (void)setNewLevelColors {
    // ////////NSLog(@"%@", @"* setNewLevelColors");
    
    if (_currentLevel==1) {
        
        color1triangle = 1;
        color1nextTriangle = 5;
        color2triangle = 2;
        color2nextTriangle = 1;
        color3triangle = 3;
        color3nextTriangle = 6;
        color4triangle = 4;
        color4nextTriangle = 6;
        color5triangle = 5;
        color5nextTriangle = 2;
    }
    else  {
        color1triangle = [self randomColor];
        color2triangle =  [self randomColor];
        while (color1triangle==color2triangle) {
            color2triangle =  [self randomColor];
        }
        color3triangle =  [self randomColor];
        while ((color3triangle==color2triangle) || (color3triangle==color1triangle)) {
            color3triangle =  [self randomColor];
        }
        color4triangle = [self randomColor];
        while ((color3triangle==color4triangle) || (color4triangle==color2triangle)|| (color4triangle==color1triangle)) {
            color4triangle =  [self randomColor];
        }
        color5triangle = [self randomColor];
        while ((color1triangle==color5triangle) || (color2triangle==color5triangle)|| (color3triangle==color5triangle)|| (color4triangle==color5triangle)) {
            color5triangle =  [self randomColor];
        }
        
        
        color1nextTriangle = [self randomColor];
        while (color1nextTriangle==color4triangle) {
            color1nextTriangle =  [self randomColor];
        }
        color2nextTriangle = [self randomColor];
        while (color1nextTriangle==color2nextTriangle) {
            color2nextTriangle =  [self randomColor];
        }
        
        color3nextTriangle = [self randomColor];
        while (color3nextTriangle==color2nextTriangle) {
            color3nextTriangle =  [self randomColor];
        }
        color4nextTriangle = [self randomColor];
        while (color4nextTriangle==color3nextTriangle) {
            color4nextTriangle =  [self randomColor];
        }
        
        color5nextTriangle = [self randomColor];
        
    }
    
    // 1 triangle1
    NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 2 color1nextTriangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1next').style.borderBottom='119.10px solid %@';",  [self ourColors:color1nextTriangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 3 color2triangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 4 color2nextTriangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2next').style.borderBottom='119.10px solid %@';",  [self ourColors:color2nextTriangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 5 color3triangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 6 color3nextTriangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3next').style.borderBottom='119.10px solid %@';",  [self ourColors:color3nextTriangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 7 triangle4
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 8 color4nextTriangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4next').style.borderBottom='119.10px solid %@';",  [self ourColors:color4nextTriangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    // FINISH set 8 color4nextTriangle
    
    // 9 triangle5
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    
    // 10 color5nextTriangle
    JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5next').style.borderBottom='119.10px solid %@';",  [self ourColors:color5nextTriangle]];
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    // FINISH set 10 color4nextTriangle- (NSString*)ourColors:(int)numberOfCOLOR {
    
}

- (NSString*)setLevelLetter {
    ////////NSLog(@"%@", @"* setLevelLetter");
    
    NSArray *greekLetters = [NSArray arrayWithObjects: @"α", @"β", @"γ", @"δ",  @"ε",  @"ζ",  @"η", @"θ",  @" ι",  @"κ",  @"λ",  @"μ",  @"ν",  @"ξ",  @"ο",  @"π",  @"ρ",
                             @"ς",  @"τ",  @"υ",  @"φ",  @"χ",  @"ψ",  @"ω", nil];
    
//    greekLetter.titleLabel.text = [greekLetters objectAtIndex: _currentLevel-1];
//    [greekLetter setTitle:[greekLetters objectAtIndex: _currentLevel-1] forState:UIControlStateHighlighted];
//
//    [greekLetter setTitle:[greekLetters objectAtIndex: _currentLevel-1] forState:UIControlStateNormal];
//
//    [greekLetter setTitle:[greekLetters objectAtIndex: _currentLevel-1] forState:UIControlStateSelected];
    
//    greekLetter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    return greekLetter.titleLabel.text;
    return [greekLetters objectAtIndex: _currentLevel-1];
}

- (void)restoreValuesOfStart {
    //NSLog(@"START RestoreValuesOfStar " );
    _currentLevel =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentLevel"];
    ////////NSLog(@"_currentLevel = %i", _currentLevel);
    if ((_currentLevel <= 0)||(_currentLevel >24)) {
        _currentLevel = 1;
    }
    _currentGrade =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentGrade"];
    ////////NSLog(@"_currentGrade = %i", _currentGrade);
    if ((_currentGrade <= 1)||(_currentGrade >31)) {
        _currentGrade = 1;
    }
    
    [self showHideLocks];
    
    _currentScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentScore"];
    if (_currentScore<1) _currentScore=0;
    ////////NSLog(@"_currentScore = %i", _currentScore);
    _currentScoreLabel.text =  [NSString stringWithFormat:@"%d", _currentScore];
    if (_currentScore == 100)  {
        _currentScoreLabel.text =  [NSString stringWithFormat:@"%@", NSLocalizedString(@"Collect one color", nil) ];
    }
    
    if (_currentLevel == 1)   [self  newLevelStart];
    
    if  (color1triangle==0)    [self  setNewLevelColors];
    
    _transitonFinish = YES;
    _hod = 0;
    
    
    //NSLog(@"FINISH RestoreValuesOfStart _hod= %i", _hod);
}

- (void) newLevelStart {
    
    // //////NSLog(@"%@", @"* newLevelStart");
    
    //  webView.hidden = NO;
    
    _star1.text = @"";
    _star2.text = @"";
    _star3.text = @"";
    _star4.text = @"";
    _star5.text = @"";
    
    [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
    [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
    [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
    [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
    [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
    
    
//    [self performSelector:@selector(RedPentacleVisability) withObject:nil afterDelay:1.5];
    [self setNewLevelColors];
    
    _currentTriangle = 0;
    _previousTriangle  = 0;
    
    [self performSelector:@selector(showHideLocks) withObject:nil afterDelay:3.1];
    
//    RedPentacle.hidden=NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self restoreValuesOfStart];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSString *evolutionSwichOnOffKey =  [[NSUserDefaults standardUserDefaults] stringForKey:@"evolutionSwichOnOffKey"];
    
    if (![evolutionSwichOnOffKey isEqualToString: @"NO"]) {
        
        
        UITouch *touch = [touches anyObject];
        
        if([touch view] == _touchView){
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( _transitonFinish ){
        if (touchViewOnOf) {
            UITouch *aTouch = [touches anyObject];
            
            
            CGPoint point = [aTouch locationInView:_touchView];
            _transitonFinish = NO;
            
            [self checkFirstTriangle:point.x :point.y];
            
        }
    }
}

- (void)nextHod {
    //NSLog (@" nextHod _currentTriangle = %i", _currentTriangle );
    //NSLog (@"previousTriangle = %i", _previousTriangle );
    
    /* традиционный код
     if ( _currentTriangle == _previousTriangle ) {
     _hod = _hod+1;
     if ((_hod>4)||(_hod<1)) _hod = 1;
     //NSLog(@"nextHod = %i", _hod);
     } else _hod = 1;
     //NSLog (@"nextHod 2 = %i", _hod );
     // конец традиционный код
     */
    // новый код хода
    _hod = _hod+1;
    if ((_hod>4)||(_hod<1)) _hod = 1;
    //  новый ход
    
    _currentScore=_currentScore-1;
    _currentScoreLabel.text =  [NSString stringWithFormat:@"%d", _currentScore];
    if (_currentScore == 100)  {
        _currentScoreLabel.text =  [NSString stringWithFormat:@"%@", NSLocalizedString(@"Collect one color", nil) ];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:_currentScore forKey:@"CurrentScore"];
    
    
    NSInteger currentRecord = [[NSUserDefaults standardUserDefaults] integerForKey:@"record"];
    if (_currentScore > currentRecord) {
        [[NSUserDefaults standardUserDefaults] setInteger:_currentScore forKey:@"record"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)checkFirstTriangle:(float)px :(float)py {
    ////////NSLog(@"checkFirstTriangle");
    ////////NSLog(@"ПЕРВЫМ ИДЁТ НИЖНИЙ ТРЕУГОЛЬНИК И ДАЛЕЕ ПО ЧАСОВОЙ");
    
    
    ////////NSLog(@"_currentGrade== %i",_currentGrade);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        
        
        
        
        float p1x=161;
        float p1y=221;
        float p2x=74;
        float p2y=340.1;
        float p3x=248;
        float p3y=340.1;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0))
        {
            ////////NSLog(@"Внутри первого");
            
            
            if ((_currentGrade==10)||(_currentGrade==13)||(_currentGrade==17)||(_currentGrade==19)||(_currentGrade==24)||(_currentGrade==25)||(_currentGrade==26)||(_currentGrade==28)||(_currentGrade==30)) {
                ////////NSLog(@"%@",@" playSystemSoundBloked **_currentGrade==5, 6, 7 ********");
                //                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            
            
            
            _star1.text = @"";
            _currentTriangle = 1;
            [self nextHod];
            _previousTriangle = 1;
            
            [_webView evaluateJavaScript:@"document.getElementById('triangle1').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
            //            [self playSystemSound3];
            
            switch (_hod)
            {
                case 1:
                    // $
                    [_webView evaluateJavaScript: @"flipCard1()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard2()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard3()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard4()" completionHandler:nil];
                    break;
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
            
        }
        else {
            ////////NSLog(@"Вне первого");
            [self checkSecondTriangle:px :py];
        }
        
        
        
        
    } else {
        // iPad 1
        float p1x= 321.5;
        float p1y= 446.5;
        float p2x= 151.5;
        float p2y= 680;
        float p3x= 494;
        float p3y= 680;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0))
        {
            ////////NSLog(@"Внутри первого");
            
            if ((_currentGrade==10)||(_currentGrade==13)||(_currentGrade==17)||(_currentGrade==19)||(_currentGrade==24)||(_currentGrade==25)||(_currentGrade==26)||(_currentGrade==28)||(_currentGrade==30)) {
                ////////NSLog(@"%@",@" playSystemSoundBloked **_currentGrade==5, 6, 7 ********");
                //                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            
            
            _star1.text = @"";
            _currentTriangle = 1;
            [self nextHod];
            _previousTriangle = 1;
            
            [_webView evaluateJavaScript:@"document.getElementById('triangle1').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
            //            [self playSystemSound3];
            
            switch (_hod)
            {
                case 1:
                    // $
                    [_webView evaluateJavaScript: @"flipCard1()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard2()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard3()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard4()" completionHandler:nil];
                    break;
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
        }
        else {
            ////////NSLog(@"Вне первого");
            [self checkSecondTriangle:px :py];
        }
    }
}

- (void)checkSecondTriangle:(float)px :(float)py
{
    //  [self playSystemSoundBloked:nil];
    ////////NSLog(@"checkSecondTriangle");
    // 24.000000 181.000000
    // x=20  y=180.4
    //(верхняя точка второго треугольника) point p1(x1, y1);  74+87=  161  ,221
    //(левая точка второго треугольника) point p2(x2, y2);  74 , 221+119.10  (высота треуг.)=  340.10
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        float p1x=20;
        float p1y=180.4;
        float p2x=161;
        float p2y=221;
        float p3x=74;
        float p3y=340.10;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0)) {
            ////////NSLog(@"Внутри второго");
            
            
            if ((_currentGrade==14)||(_currentGrade==16)||(_currentGrade==18)||(_currentGrade==21)||(_currentGrade==22)||(_currentGrade==23)||(_currentGrade==25)||(_currentGrade==27)||(_currentGrade==28)||(_currentGrade==29)||(_currentGrade==30)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@" playSystemSoundBloked **_currentGrade==14 - 31 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            _star2.text = @"";
            
            _currentTriangle = 2;
            [self nextHod];
            _previousTriangle = 2;
            [_webView evaluateJavaScript:@"document.getElementById('triangle2').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
//            [self playSystemSound3];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard5()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard6()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard7()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard8()" completionHandler:nil];
                    break;
                    
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
        }//if
        else {
            ////////NSLog(@"Вне второго");
            [self checkThirdTriangle:px :py];
        }
        
        
    } else {
        // iPad 2
        
        
        float p1x= 46;
        float p1y= 356;
        float p2x= 321.5;
        float p2y= 446.5;
        float p3x= 152.5;
        float p3y= 680;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0)) {
            ////////NSLog(@"Внутри второго");
            
            
            if ((_currentGrade==14)||(_currentGrade==16)||(_currentGrade==18)||(_currentGrade==21)||(_currentGrade==22)||(_currentGrade==23)||(_currentGrade==25)||(_currentGrade==27)||(_currentGrade==28)||(_currentGrade==29)||(_currentGrade==30)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@" playSystemSoundBloked **_currentGrade==5, 6, 7 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            _star2.text = @"";
            _currentTriangle = 2;
            [self nextHod];
            _previousTriangle = 2;
            [_webView evaluateJavaScript:@"document.getElementById('triangle2').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
//            [self playSystemSound3];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard5()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard6()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard7()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard8()" completionHandler:nil];
                    break;
                    
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
        }//if
        else {
            ////////NSLog(@"Вне второго");
            [self checkThirdTriangle:px :py];
        }
        
    }
}
- (void)checkThirdTriangle:(float)px :(float)py
{
    ////////NSLog(@"checkThirdTriangle");
    //161.000000 74.500000
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        float p1x=20;
        float p1y=180.4;
        float p2x=161;
        float p2y=221;
        float p3x= 161;
        float p3y= 74;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0)){
            
            ////////NSLog(@"Внутри третьего по часовой");
            
            if ((_currentGrade==12)||(_currentGrade==27)||(_currentGrade==28)||(_currentGrade==29)||(_currentGrade==30)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@" iPhone playSystemSoundBloked **_currentGrade==8 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            
            _star3.text = @"";
            _currentTriangle = 3;
            [self nextHod];
            _previousTriangle = 3;
            [_webView evaluateJavaScript:@"document.getElementById('triangle3').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
//            [self playSystemSound3];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard9()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard10()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard11()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard12()" completionHandler:nil];
                    break;
                    
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
//
            
        }
        
        
        else {
            ////////NSLog(@"Вне третьего");
            [self checkFourthTriangle:px :py];
        }
        
    } else {
        // iPad 3
        float p1x= 46;
        float p1y= 356;
        float p2x= 321.5;
        float p2y= 446.5;
        float p3x= 322;
        float p3y= 153;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0)){
            
            ////////NSLog(@"Внутри третьего по часовой");
            if ((_currentGrade==12)||(_currentGrade==27)||(_currentGrade==28)||(_currentGrade==29)||(_currentGrade==30)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@"iPad playSystemSoundBloked **_currentGrade==8 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            
            _star3.text = @"";
            _currentTriangle = 3;
            [self nextHod];
            _previousTriangle = 3;
            [_webView evaluateJavaScript:@"document.getElementById('triangle3').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
//            [self playSystemSound3];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard9()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard10()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard11()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard12()" completionHandler:nil];
                    break;
                    
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
//
            
        }
        
        
        else {
            ////////NSLog(@"Вне третьего");
            [self checkFourthTriangle:px :py];
        }
    }
}


- (void)checkFourthTriangle:(float)px :(float)py

{
    ////////NSLog(@"checkFourthTriangle ");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        float p1x=300;
        float p1y=180.4;
        float p2x=161;
        float p2y=221;
        float p3x= 161;
        float p3y= 74;
        
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0))
        {
            ////////NSLog(@" iPhone Внутри четвертого iPhone");
            
            
            if ((_currentGrade==9)||(_currentGrade==11)||(_currentGrade==16)||(_currentGrade==18)||(_currentGrade==20)||(_currentGrade==21)||(_currentGrade==22)||(_currentGrade==23)||(_currentGrade==25)||(_currentGrade==26)||(_currentGrade==27)||(_currentGrade==29)||(_currentGrade==30)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@"iPhone playSystemSoundBloked **_currentGrade==8 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            _star4.text = @"";
//            [self playSystemSound3];
            _currentTriangle = 4;
            [self nextHod];
            _previousTriangle = 4;
            [_webView evaluateJavaScript:@"document.getElementById('triangle4').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard13()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard14()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard15()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard16()" completionHandler:nil];
                    break;
                    
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
        }
        else {
            
            ////////NSLog(@"Вне четвертого");
            
            [self checkFiveTriangle:px :py];
            
        }
        
        
    } else {
        // iPad 4
        
        
        float p1x= 600;
        float p1y=  355.0;
        float p2x= 321.5;
        float p2y= 446.5;
        float p3x= 322;
        float p3y= 153;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0))
        {
            ////////NSLog(@"Внутри четвертого");
            
            
            
            
            if ((_currentGrade==9)||(_currentGrade==11)||(_currentGrade==16)||(_currentGrade==18)||(_currentGrade==20)||(_currentGrade==21)||(_currentGrade==22)||(_currentGrade==23)||(_currentGrade==25)||(_currentGrade==26)||(_currentGrade==27)||(_currentGrade==29)||(_currentGrade==30)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@"iPad playSystemSoundBloked **_currentGrade==8 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            _star4.text = @"";
            
//            [self playSystemSound3];
            _currentTriangle = 4;
            [self nextHod];
            _previousTriangle = 4;
            [_webView evaluateJavaScript:@"document.getElementById('triangle4').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard13()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard14()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard15()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard16()" completionHandler:nil];
                    break;
                    
            }//switch (_hod)
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
        }
        else {
            
            ////////NSLog(@"Вне четвертого");
            
            [self checkFiveTriangle:px :py];
            
        }
        
        
    }
}


- (void)checkFiveTriangle:(float)px :(float)py

{
    ////////NSLog(@"checkFiveTriangle");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        float p1x=248;
        float p1y=340.1;
        float p2x=300;
        float p2y=180.4;
        float p3x=161;
        float p3y=221;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0))
        {
            ////////NSLog(@"Внутри пятого");
            
            
            if ((_currentGrade==15)||(_currentGrade==17)||(_currentGrade==19)||(_currentGrade==20)||(_currentGrade==24)||(_currentGrade==26)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@" iphone playSystemSoundBloked **_currentGrade==8 ********");
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            _star5.text = @"";
            
//            [self playSystemSound3];
            _currentTriangle = 5;
            [self nextHod];
            _previousTriangle = 5;
            [_webView evaluateJavaScript:@"document.getElementById('triangle5').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard17()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard18()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard19()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard20()" completionHandler:nil];
                    break;
            }//switch (_hod)
            
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
        }
        else {
            _transitonFinish = YES;
            ////////NSLog(@"Вне пятого");
            
        }
        
        
        
    } else {
        // iPad 5
        
        float p1x= 600;
        float p1y=  355.0;
        float p2x= 321.5;
        float p2y= 446.5;
        float p3x= 494;
        float p3y= 680;
        
        float alpha = ((p2y - p3y)*(px - p3x) + (p3x - p2x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float beta = ((p3y - p1y)*(px - p3x) + (p1x - p3x)*(py - p3y)) /
        ((p2y - p3y)*(p1x - p3x) + (p3x - p2x)*(p1y - p3y));
        float gamma = 1.0f - alpha - beta;
        if ((alpha>0)&&(beta>0)&&(gamma>0))
        {
            ////////NSLog(@"Внутри пятого");
            
            
            if ((_currentGrade==15)||(_currentGrade==17)||(_currentGrade==19)||(_currentGrade==20)||(_currentGrade==24)||(_currentGrade==26)||(_currentGrade==31)) {
                ////////NSLog(@"%@",@" iPad playSystemSoundBloked  ********");
                ////////NSLog(@"_currentGrade== %i",_currentGrade);
//                [self playSystemSoundBloked:nil];
                _transitonFinish = YES;
                return;
            }
            
            _star5.text = @"";
            
//            [self playSystemSound3];
            _currentTriangle = 5;
            [self nextHod];
            _previousTriangle = 5;
            [_webView evaluateJavaScript:@"document.getElementById('triangle5').style['-webkit-transition-duration'] = '0.55s';" completionHandler:nil];
            
            switch (_hod)
            {
                case 1:
                    [_webView evaluateJavaScript: @"flipCard17()" completionHandler:nil];
                    break;
                case 2:
                    [_webView evaluateJavaScript: @"flipCard18()" completionHandler:nil];
                    break;
                case 3:
                    [_webView evaluateJavaScript:@"flipCard19()" completionHandler:nil];
                    break;
                case 4:
                    [_webView evaluateJavaScript:@"flipCard20()" completionHandler:nil];
                    break;
            }//switch (_hod)
            
            [self performSelector:@selector(ChangeTriangleColors) withObject:nil afterDelay:0.6];
            
        }
        else {
            _transitonFinish = YES;
            ////////NSLog(@"Вне пятого");
            
        }
        
        
    }
}

- (void)ChangeTriangleColors {
    ////////NSLog(@"%@",@" ChangeTriangleColors");
    if (_currentTriangle == 1)
    {
        ////////NSLog(@"%@",@" hodPervogoTreugolnika **********");
        [self hodPervogoTreugolnika];
    }
    else if (_currentTriangle == 2)
    {
        ////////NSLog(@"%@",@" hodVtorogoTreugolnika **********");
        
        [self hodVtorogoTreugolnika];
        
    }
    else if (_currentTriangle == 3)
    {
        ////////NSLog(@"%@",@" hodPTretegoTreugolnika **********");
        [self hodPTretegoTreugolnika];
        
    }
    else if (_currentTriangle == 4)
    {
        ////////NSLog(@"%@",@" hodChetvergoTreugolnika **********");
        [self hodChetvergoTreugolnika];
    }
    else if (_currentTriangle == 5)
    {
        ////////NSLog(@"%@",@" hodPiatigoTreugolnika **********");
        
        [self hodPiatigoTreugolnika];
    }
    
    [self CheckLevelFinish];
}

- (void)hodPervogoTreugolnika {
    // //////NSLog(@"********** hodPervogoTreugolnika");
    
    _star1.text = @"";
    
    NSString *JavaCom = @"document.getElementById('triangle1').style['-webkit-transition-duration'] = '0';";
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    // //////NSLog(@"JavaCom 2= %@" , JavaCom);
    
    
    if (_hod == 1)
    {
        color2triangle = color1triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle1').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        JavaCom = @" document.getElementsByClassName('triangle1')[0].classList.remove('flipCard1');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        color1triangle = color1nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        
        
        
        color1nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1next').style.borderBottom='119.10px solid %@';",  [self ourColors:color1nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle1').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
    }
    else if (_hod == 2)
    {
        // //////NSLog (@"******CurrenTriangle 1 case 2");
        color3triangle = color1triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle1').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 2= %@" , JavaCom);
        color1triangle = color1nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        //  $
        JavaCom = @"document.getElementById('triangle1').style.top='60px';"
        @"document.getElementById('triangle1').style.left='20px';"
        @"document.getElementById('triangle1').style.borderBottom='119.10px solid transparent;'"
        @"document.getElementById('triangle1').style.borderBottom='119.10px solid transparent;'";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        //////NSLog(@"JavaCom 4 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle1')[0].classList.remove('flipCard2');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle1').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 5= %@" , JavaCom);
        color1nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1next').style.borderBottom='119.10px solid %@';",  [self ourColors:color1nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // //////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    else if (_hod == 3)
    {
        color4triangle = color1triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle1').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color1triangle = color1nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle1').style.top='60px';"
        @"document.getElementById('triangle1').style.left='20px';"
        @"document.getElementById('triangle1').style.borderBottom='119.10px solid transparent;'"
        @"document.getElementById('triangle1').style.borderBottom='119.10px solid transparent;'";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 4 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle1')[0].classList.remove('flipCard3');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle1').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color1nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1next').style.borderBottom='119.10px solid %@';",  [self ourColors:color1nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    else if (_hod == 4)
    {
        color5triangle = color1triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle1').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color1triangle = color1nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle1').style.top='60px';"
        @"document.getElementById('triangle1').style.left='20px';"
        @"document.getElementById('triangle1').style.borderBottom='119.10px solid transparent;'"
        @"document.getElementById('triangle1').style.borderBottom='119.10px solid transparent;'";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 4 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle1')[0].classList.remove('flipCard4');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle1').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color1nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1next').style.borderBottom='119.10px solid %@';",  [self ourColors:color1nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    _transitonFinish = YES;
}


- (void)hodVtorogoTreugolnika {
    //////NSLog(@"********** hodVtorogoTreugolnika");
    
    
    _star2.text = @"";
    
    
    NSString *JavaCom = @"document.getElementById('triangle2').style['-webkit-transition-duration'] = '0';";
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    ////////NSLog(@"JavaCom 2= %@" , JavaCom);
    
    
    if (_hod == 1)
    {
        color3triangle = color2triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        
        JavaCom = @"document.getElementById('triangle2').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        
        JavaCom = @" document.getElementsByClassName('triangle2')[0].classList.remove('flipCard5');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        color2triangle = color2nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        color2nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2next').style.borderBottom='119.10px solid %@';",  [self ourColors:color2nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        JavaCom = @"document.getElementById('triangle2').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
    }
    else if (_hod == 2)
    {
        ////////NSLog (@"******CurrenTriangle 2 case 2");
        color4triangle = color2triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle2').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color2triangle = color2nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        JavaCom = @" document.getElementsByClassName('triangle2')[0].classList.remove('flipCard6');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle2').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color2nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2next').style.borderBottom='119.10px solid %@';",  [self ourColors:color2nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    else if (_hod == 3)
    {
        
        ////////NSLog (@"******CurrenTriangle 2 case 3");
        color5triangle = color2triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle2').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color2triangle = color2nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        JavaCom = @" document.getElementsByClassName('triangle2')[0].classList.remove('flipCard7');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle2').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color2nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2next').style.borderBottom='119.10px solid %@';",  [self ourColors:color2nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    else if (_hod == 4)
    {
        
        ////////NSLog (@"******CurrenTriangle 2 case 4");
        
        color1triangle = color2triangle ;
        
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle2').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color2triangle = color2nextTriangle;
        
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle2')[0].classList.remove('flipCard8');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle2').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color2nextTriangle = [self randomColor];
        
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2next').style.borderBottom='119.10px solid %@';",  [self ourColors:color2nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
    }
    
    _transitonFinish = YES;
    
}


- (void)hodPTretegoTreugolnika {
    //////NSLog(@"********** hodPTretegoTreugolnika");
    
    _star3.text = @"";
    
    NSString *JavaCom = @"document.getElementById('triangle3').style['-webkit-transition-duration'] = '0';";
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    ////////NSLog(@"JavaCom 2= %@" , JavaCom);
    
    if (_hod == 1)
    {
        
        ////////NSLog(@"********** hodPTretegoTreugolnika 1" );
        
        color4triangle = color3triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle3').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        
        
        
        JavaCom = @" document.getElementsByClassName('triangle3')[0].classList.remove('flipCard9');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        
        
        
        color3triangle = color3nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        
        
        
        
        
        color3nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3next').style.borderBottom='119.10px solid %@';",  [self ourColors:color3nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle3').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
        
    }
    else if (_hod == 2)
    {
        ////////NSLog(@"********** hodPTretegoTreugolnika 2");
        color5triangle = color3triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle3').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle3')[0].classList.remove('flipCard10');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        color3triangle = color3nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        color3nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3next').style.borderBottom='119.10px solid %@';",  [self ourColors:color3nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle3').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
    }
    
    else if (_hod == 3)
    {
        ////////NSLog(@"********** hodPTretegoTreugolnika 2");
        color1triangle = color3triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle3').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle3')[0].classList.remove('flipCard11');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        color3triangle = color3nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        color3nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3next').style.borderBottom='119.10px solid %@';",  [self ourColors:color3nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle3').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
    }
    else if (_hod == 4)
    {
        
        ////////NSLog(@"********** hodPTretegoTreugolnika 3");
        color2triangle = color3triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle3').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle3')[0].classList.remove('flipCard12');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        color3triangle = color3nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        color3nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3next').style.borderBottom='119.10px solid %@';",  [self ourColors:color3nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle3').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
    }
    _transitonFinish = YES;
    
}


- (void)hodChetvergoTreugolnika {
    // //////NSLog(@"********** hodChetvergoTreugolnika");
    
    
    _star4.text = @"";
    
    NSString *JavaCom = @"document.getElementById('triangle4').style['-webkit-transition-duration'] = '0';";
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    ////////NSLog(@"JavaCom 2= %@" , JavaCom);
    
    if (_hod == 1)
    {
        
        // ////////NSLog(@"********** hodChetvergoTreugolnika 1" );
        
        color5triangle = color4triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle4').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        
        
        
        JavaCom = @" document.getElementsByClassName('triangle4')[0].classList.remove('flipCard13');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        
        
        
        
        color4triangle = color4nextTriangle;
        
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        color4nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4next').style.borderBottom='119.10px solid %@';",  [self ourColors:color4nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle4').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
        
    }
    else if (_hod == 2)
    {
        ////////NSLog(@"********** hodChetvergoTreugolnika 2");
        
        color1triangle = color4triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle4').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        
        
        
        JavaCom = @" document.getElementsByClassName('triangle4')[0].classList.remove('flipCard14');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        
        
        
        color4triangle = color4nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        
        
        
        
        
        color4nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4next').style.borderBottom='119.10px solid %@';",  [self ourColors:color4nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle4').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
        
        
    }
    else if (_hod == 3)
    {
        
        ////////NSLog(@"********** hodChetvergoTreugolnika 3");
        color2triangle = color4triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle4').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        
        
        
        JavaCom = @" document.getElementsByClassName('triangle4')[0].classList.remove('flipCard15');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        
        
        
        color4triangle = color4nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        
        
        
        
        
        color4nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4next').style.borderBottom='119.10px solid %@';",  [self ourColors:color4nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle4').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
        
        
    }
    else if (_hod == 4)
    {
        
        ////////NSLog(@"********** hodChetvergoTreugolnika 3");
        color3triangle = color4triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle4').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        
        
        
        JavaCom = @" document.getElementsByClassName('triangle4')[0].classList.remove('flipCard16');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        
        
        
        color4triangle = color4nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        
        
        
        
        
        color4nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4next').style.borderBottom='119.10px solid %@';",  [self ourColors:color4nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle4').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
        
        
    }
    
    _transitonFinish = YES;
    
}

- (void)hodPiatigoTreugolnika {
    
    ////////NSLog(@"********** hodPiatigoTreugolnika");
    
    _star5.text = @"";
    NSString *JavaCom = @"document.getElementById('triangle5').style['-webkit-transition-duration'] = '0';";
    [_webView evaluateJavaScript:JavaCom completionHandler:nil];
    ////////NSLog(@"JavaCom 2= %@" , JavaCom);
    
    
    if (_hod == 1)
    {
        color1triangle = color5triangle ;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle1').style.borderBottom='119.10px solid %@';",  [self ourColors:color1triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        
        
        // 1 triangle not visible
        JavaCom = @"document.getElementById('triangle5').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        
        JavaCom = @" document.getElementsByClassName('triangle5')[0].classList.remove('flipCard17');";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        
        
        color5triangle = color5nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        
        
        
        
        color5nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5next').style.borderBottom='119.10px solid %@';",  [self ourColors:color5nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
        
        
        
        
        JavaCom = @"document.getElementById('triangle5').visibility='visible';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        
        
        
    }
    else if (_hod == 2)
    {
        ////////NSLog (@"******CurrenTriangle 5 case 2");
        color2triangle = color5triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle2').style.borderBottom='119.10px solid %@';",  [self ourColors:color2triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        // ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle5').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color5triangle = color5nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        //  $
        JavaCom = @"document.getElementById('triangle5').style.top='60px';"
        @"document.getElementById('triangle5').style.left='20px';"
        @"document.getElementById('triangle5').style.borderBottom='119.10px solid transparent;'"
        @"document.getElementById('triangle5').style.borderBottom='119.10px solid transparent;'";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 4 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle5')[0].classList.remove('flipCard18');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle5').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color5nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5next').style.borderBottom='119.10px solid %@';",  [self ourColors:color5nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    else if (_hod == 3)
    {
        color3triangle = color5triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle3').style.borderBottom='119.10px solid %@';",  [self ourColors:color3triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle5').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color5triangle = color5nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle5').style.top='60px';"
        @"document.getElementById('triangle5').style.left='20px';"
        @"document.getElementById('triangle5').style.borderBottom='119.10px solid transparent;'"
        @"document.getElementById('triangle5').style.borderBottom='119.10px solid transparent;'";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 4 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle5')[0].classList.remove('flipCard19');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle5').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color5nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5next').style.borderBottom='119.10px solid %@';",  [self ourColors:color5nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    else if (_hod == 4)
    {
        color4triangle = color5triangle ;
        NSString *JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle4').style.borderBottom='119.10px solid %@';",  [self ourColors:color4triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle5').visibility='hidden';";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2= %@" , JavaCom);
        color5triangle = color5nextTriangle;
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5').style.borderBottom='119.10px solid %@';",  [self ourColors:color5triangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 3 = %@", JavaCom);
        JavaCom = @"document.getElementById('triangle5').style.top='60px';"
        @"document.getElementById('triangle5').style.left='20px';"
        @"document.getElementById('triangle5').style.borderBottom='119.10px solid transparent;'"
        @"document.getElementById('triangle5').style.borderBottom='119.10px solid transparent;'";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 4 = %@", JavaCom);
        JavaCom = @" document.getElementsByClassName('triangle5')[0].classList.remove('flipCard20');";
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 2a= %@" , JavaCom);
        JavaCom = @"document.getElementById('triangle5').visibility='visible';";
        
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 5= %@" , JavaCom);
        color5nextTriangle = [self randomColor];
        JavaCom = [NSString stringWithFormat:@"document.getElementById('triangle5next').style.borderBottom='119.10px solid %@';",  [self ourColors:color5nextTriangle]];
        [_webView evaluateJavaScript:JavaCom completionHandler:nil];
        ////////NSLog(@"JavaCom 6 = %@", JavaCom);
    }
    _transitonFinish = YES;
    
    
    
}

- (void) CheckLevelFinish {
    //NSLog(@"%@", @"* CheckLevelFinish");
    
    [self StarsShow];
    
    if ((color1triangle==color2triangle)&&(color2triangle==color4triangle)&&(color1triangle==color3triangle)&&(color5triangle==color1triangle)){
        [_webView evaluateJavaScript: @"document.getElementById('triangle1hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle2hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle3hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle4hidden').style.visibility = 'hidden';" completionHandler:nil];
        [_webView evaluateJavaScript: @"document.getElementById('triangle5hidden').style.visibility = 'hidden';" completionHandler:nil];
        
        _star1.textColor = [UIColor whiteColor];
        _star2.textColor = [UIColor whiteColor];
        _star3.textColor = [UIColor whiteColor];
        _star4.textColor = [UIColor whiteColor];
        _star5.textColor = [UIColor whiteColor];
        
        _star1.text = @"⚑";
        _star2.text = @"⚑";
        _star3.text = @"⚑";
        _star4.text = @"⚑";
        _star5.text = @"⚑";
        
        
        
        // //////NSLog(@"CheckLevelFinish = %@", @"CheckLevelFinish function LEVEL FINISHED");
        _currentLevel = _currentLevel + 1;
        if (_currentLevel>24)
        {
            _currentLevel=1;
            _currentGrade = _currentGrade+1;
            if (_currentGrade>31)
            {
                _currentGrade=1;
                
                
            }
            [self  showHideLocks];
            
            [[NSUserDefaults standardUserDefaults] setInteger:_currentGrade forKey:@"CurrentGrade"];
        }
        
        
        
        //////NSLog(@"1 _currentScore %d", _currentScore);
        _currentScore = _currentScore+ (_currentGrade * 100);
        
        if ((_currentGrade * 100)>999)  {
            [_webView evaluateJavaScript:@"document.getElementById('scoreText').style.fontSize = '100px';" completionHandler:nil];
        } else
        {[_webView evaluateJavaScript:@"document.getElementById('scoreText').style.fontSize = '130px';" completionHandler:nil];
        }
        _currentScoreLabel.text =  [NSString stringWithFormat:@"%d", _currentScore];
        // //////NSLog(@"2 _currentScore %d", _currentScore);
        if (_currentScore == 100)  {
            _currentScoreLabel.text =  [NSString stringWithFormat:@"%@", NSLocalizedString(@"Collect one color", nil) ];
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:_currentScore forKey:@"CurrentScore"];
        
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"moveScore('+%d')",  (_currentGrade * 100)] completionHandler:nil];
        
        
//        AppDelegate *appDelegate=  (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate myAudioPlayer2];
        
//        [self performSelector:@selector(RedPentacleVisability) withObject:nil afterDelay:0.2];
//
//        [self performSelector:@selector(RedPentacleVisability) withObject:nil afterDelay:0.9];
//
//        [self performSelector:@selector(RedPentacleVisability) withObject:nil afterDelay:1.7];
        [self performSelector:@selector(newLevelStart) withObject:nil afterDelay:2.0];
        //   [self performSelector:@selector(RedPentacleVisability) withObject:nil afterDelay:1.2];
        
        
        [[NSUserDefaults standardUserDefaults] setInteger:_currentLevel forKey:@"CurrentLevel"];
        NSInteger currentRecord = [[NSUserDefaults standardUserDefaults] integerForKey:@"record"];
        if (_currentScore > currentRecord) {
            [[NSUserDefaults standardUserDefaults] setInteger:_currentScore forKey:@"record"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        //////NSLog(@"Current Level = %i", _currentLevel);
        
        // //////NSLog(@"CurrentGrade  = %i", _currentGrade);
        
    }
    //сохранить измененный цвет в NSUserDefaults
    //ресет левел
    //ресет game
    
    else {
        ////////NSLog(@"%@", @"NOT FINISH in _currentLevel");
    }
    
}

- (void) StarsShow {
    // //////NSLog(@"%@", @"* StarsShow проверка одинаковых треугольников и показ");
    _star1.textColor = [UIColor whiteColor];
    _star2.textColor = [UIColor whiteColor];
    _star3.textColor = [UIColor whiteColor];
    _star4.textColor = [UIColor whiteColor];
    _star5.textColor = [UIColor whiteColor];
    _star1.text = @"";
    _star2.text = @"";
    _star3.text = @"";
    _star4.text = @"";
    _star5.text = @"";
    // проверяем блок из двух одинаковых цветов
    if (color1triangle==color2triangle){ _star1.text = @"⚑";   _star2.text = @"⚑"; }
    if (color1triangle==color3triangle){ _star1.text = @"⚑";   _star3.text = @"⚑"; }
    if (color1triangle==color4triangle){ _star1.text = @"⚑";   _star4.text = @"⚑"; }
    if (color1triangle==color5triangle){ _star1.text = @"⚑";   _star5.text = @"⚑"; }
    
    if (color2triangle==color3triangle){ _star2.text = @"⚑";   _star3.text = @"⚑"; }
    if (color2triangle==color4triangle){ _star2.text = @"⚑";   _star4.text = @"⚑"; }
    if (color2triangle==color5triangle){ _star2.text = @"⚑";   _star5.text = @"⚑"; }
    
    if (color3triangle==color4triangle){ _star3.text = @"⚑";   _star4.text = @"⚑"; }
    if (color3triangle==color5triangle){ _star3.text = @"⚑";   _star5.text = @"⚑"; }
    
    if (color4triangle==color5triangle){ _star4.text = @"⚑";   _star5.text = @"⚑"; }
    
    // проверяем блок из трех одинаковых цветов + блок из двух одинаковых цветов
    if (([_star1.text isEqualToString: @"⚑"])&&([_star2.text isEqualToString: @"⚑"])&&
        ([_star3.text isEqualToString: @"⚑"]) && ([_star4.text isEqualToString: @"⚑"]) &&
        ([_star5.text isEqualToString: @"⚑"]) )
    {
        //  //////NSLog(@"%@", @"* проверяем блок из трех одинаковых цветов + блок из двух одинаковых цветов");
        if ((color1triangle==color2triangle)&&(color1triangle==color3triangle))
        {   _star4.textColor = [UIColor lightGrayColor];
            _star5.textColor = [UIColor lightGrayColor]; }
        
        if ((color1triangle==color2triangle)&&(color1triangle==color4triangle))
        {   _star3.textColor = [UIColor lightGrayColor];
            _star5.textColor = [UIColor lightGrayColor]; }
        
        if ((color1triangle==color2triangle)&&(color1triangle==color5triangle))
        {   _star3.textColor = [UIColor lightGrayColor];
            _star4.textColor = [UIColor lightGrayColor]; }
        
        if ((color1triangle==color3triangle)&&(color1triangle==color4triangle))
        {   _star2.textColor = [UIColor lightGrayColor];
            _star5.textColor = [UIColor lightGrayColor]; }
        
        if ((color1triangle==color3triangle)&&(color1triangle==color5triangle))
        {   _star2.textColor = [UIColor lightGrayColor];
            _star4.textColor = [UIColor lightGrayColor]; }
        
        if ((color1triangle==color4triangle)&&(color1triangle==color5triangle))
        {   _star2.textColor = [UIColor lightGrayColor];
            _star3.textColor = [UIColor lightGrayColor]; }
        
        
        
        if ((color2triangle==color3triangle)&&(color2triangle==color4triangle))
        {   _star1.textColor = [UIColor lightGrayColor];
            _star5.textColor = [UIColor lightGrayColor]; }
        
        if ((color2triangle==color3triangle)&&(color2triangle==color5triangle))
        {   _star1.textColor = [UIColor lightGrayColor];
            _star4.textColor = [UIColor lightGrayColor]; }
        
        if ((color2triangle==color4triangle)&&(color2triangle==color5triangle))
        {   _star1.textColor = [UIColor lightGrayColor];
            _star3.textColor = [UIColor lightGrayColor]; }
        
        if ((color3triangle==color4triangle)&&(color3triangle==color5triangle))
        {   _star1.textColor = [UIColor lightGrayColor];
            _star2.textColor = [UIColor lightGrayColor]; }
        
        
        
        
        
    }
    // проверяем блок из трех четырех цветов
    [self    showHideLocks];
    
    // //////NSLog(@"%@", @"* Завершение StarsShow");
}

@end
