//
//  CarRecruitPhotoViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/14.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "CarRecruitPhotoViewController.h"
#import "UIButton+AFNetworking.h"
@interface CarRecruitPhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActionSheet * actionSheet;
    UIButton *_currentBtn;
}
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation CarRecruitPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"上传证件照";
    [self setupViewStyle];
}

- (void)setupViewStyle {
    UIButton *typeBtn1 = kViewWithTag(self.containView, 100);
    UIButton *typeBtn2 = kViewWithTag(self.containView, 101);
    UIButton *typeBtn3 = kViewWithTag(self.containView, 102);
    UIButton *typeBtn4 = kViewWithTag(self.containView, 103);
    NSString *photo1 = [NSString stringWithFormat:@"%@upimages/%@",apiBaseURLString,_orderObj.routeCarImage];
    NSString *photo2 = [NSString stringWithFormat:@"%@upimages/%@",apiBaseURLString,_orderObj.driverCarImage];
    NSString *photo3 = [NSString stringWithFormat:@"%@upimages/%@",apiBaseURLString,_orderObj.idImage];
    NSString *photo4 = [NSString stringWithFormat:@"%@upimages/%@",apiBaseURLString,_orderObj.carImage];
    [typeBtn1 setImageForState:UIControlStateNormal withURL:kURLFromString(photo1)];
    [typeBtn2 setImageForState:UIControlStateNormal withURL:kURLFromString(photo2)];
    [typeBtn3 setImageForState:UIControlStateNormal withURL:kURLFromString(photo3)];
    [typeBtn4 setImageForState:UIControlStateNormal withURL:kURLFromString(photo4)];
}


#pragma mark --选择照片类型
- (IBAction)typeBtnAction:(UIButton *)sender {
    _currentBtn = sender;
    NSInteger tag = sender.tag;
    [self getUserphoto:sender];
}

///////////////////取照片的方法///////////////////////
#pragma mark actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self shootPiicturePrVideo];
    }
    else if (buttonIndex == 1) {
        
        [self selectExistingPictureOrVideo];
    }
}
#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
        chosenImage = [chosenImage getLimitImage:CGSizeMake(168, 168)];
        [_currentBtn setImage:chosenImage forState:UIControlStateNormal];
        [self sendDriverinfotoUploadWithImage:chosenImage];
        //        self.userHeadImgV.image = [publicClass scaleToSize:chosenImage size:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
//        NSData *imgData = UIImagePNGRepresentation(chosenImage);
//        kWEAKSELF
//        [[UploadServer model] uploadObjectAsyncWithData:imgData continueBlock:^id(OSSTask *task){
//            [weakSelf saveImage:chosenImage];
//            return nil;
//        }];
        
        //        [self performSelector:@selector(saveImage:) withObject:headImgV.image];
    }
    
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    
    
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:picker animated:TRUE completion:^{
            NSLog(@"调用相机");
            
        }];
    }
    else{
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
        
    }
}

#pragma mark -设置用户头像
- (void)getUserphoto:(UIButton *)sender {
    //    if (![MyLoginID_GET_Long longValue]) {
    //        return;
    //    }
    NSLog(@"SingleTap_UpdateHeadPic");
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:kAppDelegate.window];
    
    
}

- (IBAction)submitBtnAction:(UIButton *)sender {
    [NSString toast:@"您的信息已提交待审核"];
}


#pragma mark --图片上传接口
- (void)sendDriverinfotoUploadWithImage:(UIImage *)picImg{
    
    UIImage *image=picImg;//[UIImage imageWithContentsOfFile:picFilePath];
    NSData *data = nil;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"mobile"];
    [params addUnEmptyString:kIntegerToString(_currentBtn.tag-100+1) forKey:@"type"];
    [params addUnEmptyString:data forKey:@"tempFile"];
    
    [OrderInfoObj sendDriverinfotoUploadWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
