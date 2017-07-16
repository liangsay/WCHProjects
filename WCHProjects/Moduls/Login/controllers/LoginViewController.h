//
//  LoginViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModel.h"

@interface LoginModel : BaseModel
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@end

@interface LoginViewController : BaseViewController
@property (nonatomic, copy) LoginVCAction loginAction;
@end
