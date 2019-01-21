//
//  MenuViewController.h
//  SpinToWin
//
//  Created by Sergey on 20/01/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *levelPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *gradePicker;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@end

NS_ASSUME_NONNULL_END
