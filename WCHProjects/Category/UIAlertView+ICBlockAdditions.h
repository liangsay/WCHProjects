//
//  UIAlertView+ICBlockAdditions.h
//  iChanceSample
//
//  Created by Fox on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^VoidBlock)();
typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)();
typedef void (^PhotoPickedBlock)(UIImage *chosenImage);


@interface UIAlertView (ICBlockAdditions) <UIAlertViewDelegate>

+ (UIAlertView*) alertViewWithTitle:(NSString*) title 
                            message:(NSString*) message;

+ (UIAlertView*) alertViewWithTitle:(NSString*) title 
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle;

+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed                   
                           onCancel:(CancelBlock) cancelled;


@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end
