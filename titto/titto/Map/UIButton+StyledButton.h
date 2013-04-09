//
//  UIButton+StyledButton.h
//  titto
//
//  Created by Paolo Ladisa on 4/9/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (StyledButton)

+ (UIButton *)styledButtonWithBackgroundImage:(UIImage *)image font:(UIFont *)font title:(NSString *)title target:(id)target selector:(SEL)selector;

@end
