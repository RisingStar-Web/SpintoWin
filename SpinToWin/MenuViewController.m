//
//  MenuViewController.m
//  SpinToWin
//
//  Created by Sergey on 20/01/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation MenuViewController

bool changedLevelOrGrade;
//int CurrentGrade;

- (IBAction) restartGame:(id)sender{
    
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"WARNING", nil) message:NSLocalizedString(@"Do you really want to start this game again?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Restart", nil)   style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // do your action on ok click
        int currentGrade1=1;
        [[NSUserDefaults standardUserDefaults] setInteger:currentGrade1 forKey:@"CurrentGrade"];
        
        int currentScore1 = 100;
        [[NSUserDefaults standardUserDefaults] setInteger:currentScore1 forKey:@"CurrentScore"];
        
        int currentLevel1 = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:currentLevel1 forKey:@"CurrentLevel"];
        
        
        [[self levelPicker] selectRow:0 inComponent:0 animated:true];
        [[self gradePicker] selectRow:0 inComponent:0 animated:true];
        changedLevelOrGrade = TRUE;
        
        [[NSUserDefaults standardUserDefaults] setBool:changedLevelOrGrade forKey:@"changedLevelOrGrade"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // do your action on cancel click
    }]];
    
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
        viewController = viewController.presentedViewController;
    }
    
    [viewController presentViewController:alert animated:YES completion:^{
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _levelPicker.delegate = self;
    _levelPicker.dataSource = self;
    _gradePicker.delegate = self;
    _gradePicker.dataSource = self;
    int currentGrade =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentGrade"];
    if (currentGrade>31) {
        currentGrade=1;
        changedLevelOrGrade = TRUE;
        
        [[NSUserDefaults standardUserDefaults] setBool:changedLevelOrGrade forKey:@"changedLevelOrGrade"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_gradePicker selectRow:currentGrade-1 inComponent:0 animated:false];
    int CurrentLevel =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentLevel"];
    if (CurrentLevel>24) {
        CurrentLevel=1;
        changedLevelOrGrade = TRUE;
        
        [[NSUserDefaults standardUserDefaults] setBool:changedLevelOrGrade forKey:@"changedLevelOrGrade"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_levelPicker selectRow:CurrentLevel-1 inComponent:0 animated:false];
    NSInteger currentRecord = [[NSUserDefaults standardUserDefaults] integerForKey:@"record"];
    _recordLabel.text = [NSString stringWithFormat:@"Record: %ld", (long)currentRecord];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
            return 24;
        case 2:
            return 31;
        default:
            return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    // Fill the label text here
    tView.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)row+1] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : UIColor.blackColor}];
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger curLvl = row+1;
    NSInteger currentGrade = row+1;
    switch (pickerView.tag) {
        case 1:
            //////NSLog(@"CurrentLevel ++ = %i", CurrentLevel);
            [[NSUserDefaults standardUserDefaults] setInteger:curLvl forKey:@"CurrentLevel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self setLevelName];
            changedLevelOrGrade = TRUE;
            
            
            //////NSLog(@"Flip levelName changedLevelOrGrade= %@", changedLevelOrGrade ? @"Yes" : @"No");
            
            [[NSUserDefaults standardUserDefaults] setBool:changedLevelOrGrade forKey:@"changedLevelOrGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 2:
            //////NSLog(@"CurrentGrade ++ = %i", currentGrade);
            [[NSUserDefaults standardUserDefaults] setInteger:currentGrade forKey:@"CurrentGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self setGrade];
            changedLevelOrGrade = TRUE;
            
            //////NSLog(@"Flip gradename changedLevelOrGrade= %@", changedLevelOrGrade ? @"Yes" : @"No");
            
            [[NSUserDefaults standardUserDefaults] setBool:changedLevelOrGrade forKey:@"changedLevelOrGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            return;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 20;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 20;
}

@end
