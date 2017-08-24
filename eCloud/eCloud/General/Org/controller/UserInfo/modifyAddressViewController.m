//
//  modifyAddressViewController.m
//  eCloud
//
//  Created by yanlei on 2017/2/16.
//  Copyright © 2017年  lyong. All rights reserved.
//

#import "modifyAddressViewController.h"

#import "conn.h"
#import "LCLLoadingView.h"
#import "eCloudDAO.h"
#import "UIAdapterUtil.h"


@interface modifyAddressViewController ()

@end

@implementation modifyAddressViewController
{
    
}
@synthesize emp_id = _emp_id;
@synthesize oldAddress = _oldAddress;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIAdapterUtil setBackGroundColorOfController:self];
    
    self.title = [StringUtil getLocalizableString:@"address_title"];
    
    [UIAdapterUtil processController:self];
    
    [UIAdapterUtil setLeftButtonItemWithTitle:[StringUtil getLocalizableString:@"cancel"] andTarget:self andSelector:@selector(backButtonPressed:)];
    
    [UIAdapterUtil setRightButtonItemWithTitle:[StringUtil getLocalizableString:@"save"]andTarget:self andSelector:@selector(addButtonPressed:)];
    
    inputField=[[UITextField alloc]initWithFrame:CGRectMake(20, 63-44,SCREEN_WIDTH-40, 40)];
    inputField.borderStyle=UITextBorderStyleRoundedRect;
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputField.keyboardType=UIKeyboardTypeDefault;
    inputField.delegate=self;
    inputField.placeholder=@"请输入地址";
    [inputField becomeFirstResponder];
    [self.view addSubview:inputField];
    inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    else{
        
        if ([UIAdapterUtil isTAIHEApp]) {
            
            if (inputField.text.length >40) {
                
                return NO;
            }else{
                
                return YES;
            }
            
        }else{
            if ([StringUtil lenghtWithString:inputField.text ] > EMAIL_MAXLEN)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    //    NSInteger strLength = textField.text.length - range.length + string.length;
    //
    //    return (strLength <= 32);
    
}
//返回 按钮
-(void) backButtonPressed:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissModalViewControllerAnimated:YES];
    //[( (mainViewController*)self.delegete).navigationController.view removeFromSuperview];
    //[self.view removeFromSuperview];
}

#pragma mark 修改备注或群组名
-(void) addButtonPressed:(id) sender{
    
    if (![UIAdapterUtil isTAIHEApp]) {
        
        if ([inputField.text length]==0) {
            
            UIAlertView *tempAlert=[[UIAlertView alloc]initWithTitle:@"不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [tempAlert show];
            [tempAlert release];
            
            return;
        }
    }
    if ([UIAdapterUtil isTAIHEApp]) {
        
        if (inputField.text.length >40) {
            
            [self showAlertIfEmailAddressTooLong];
            return;
        }
        
    }else{
        
        if ([StringUtil lenghtWithString:inputField.text] > EMAIL_MAXLEN ) {
            
            [self showAlertIfEmailAddressTooLong];
            return;
            
        }
    }
    
    //        if ([inputField.text length]>11) {
    //
    //            UIAlertView *tempAlert=[[UIAlertView alloc]initWithTitle:@"长度超出范围" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //            [tempAlert show];
    //            [tempAlert release];
    //
    //            return;
    //        }
    
    if([inputField.text compare:self.oldAddress] == NSOrderedSame)
    {
        [self.navigationController popViewControllerAnimated:YES];
        //            [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [inputField resignFirstResponder];
        [[LCLLoadingView currentIndicator]setCenterMessage:[StringUtil getLocalizableString:@"please_wait"]];
        [[LCLLoadingView currentIndicator]showSpinner];
        [[LCLLoadingView currentIndicator]show];
        
        if(![[conn getConn]modifyUserInfo:3 andNewValue:inputField.text]) //修改地址
        {
            [[LCLLoadingView currentIndicator]hiddenForcibly:true];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[StringUtil getAlertTitle] message:@"请求失败，请稍候再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
//            [alert release];
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    inputField.text = self.oldAddress;
    [inputField becomeFirstResponder];
    //监听输入框消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleCmd:) name:MODIFYUSER_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleCmd:) name:TIMEOUT_NOTIFICATION object:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MODIFYUSER_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TIMEOUT_NOTIFICATION object:nil];
    
}
#pragma mark 接收消息处理
- (void)handleCmd:(NSNotification *)notification
{
    [[LCLLoadingView currentIndicator]hiddenForcibly:true];
    eCloudNotification	*cmd					=	(eCloudNotification *)[notification object];
    switch (cmd.cmdId)
    {
            
        case modify_userinfo_success:
        {
            /*		NSDictionary *dic = cmd.info;
             NSString *msgId = [dic objectForKey:@"msg_id"];*/
            
            
            conn* _conn = [conn getConn];
            NSString* userid=_conn.userId;
            
            [[eCloudDAO getDatabase] updateUserAddress:inputField.text :[userid intValue]];
            // [[eCloudUser getDatabase] updateUserMobile:inputField.text :[userid intValue]];
            [self.navigationController popViewControllerAnimated:YES];
            //            [self dismissModalViewControllerAnimated:YES];
            
        }break;
        case modify_userinfo_failure:
        {
            UIAlertView *alertView	=	[[UIAlertView alloc]initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
//            [alertView release];
        }break;
        case cmd_timeout:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[StringUtil getAlertTitle] message:@"通讯超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
//            [alert release];
        }
            break;
        default:
            break;
    }
    
}

-(void)showAlertIfEmailAddressTooLong
{
    UIAlertView *tempAlert=[[UIAlertView alloc]initWithTitle:[StringUtil getAlertTitle] message:[StringUtil getLocalizableString:@"address_too_long"] delegate:nil cancelButtonTitle:[StringUtil getLocalizableString:@"confirm"] otherButtonTitles: nil];
    [tempAlert show];
//    [tempAlert release];
}

@end