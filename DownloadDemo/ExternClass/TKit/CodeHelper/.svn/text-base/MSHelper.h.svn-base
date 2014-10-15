//
//  MSHelper.h
//  MemSearch
//
//  Created by thilong on 14-2-20.
//  Copyright (c) 2014年 TYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "iToast.h"

#ifndef __H__MSHELPER__
#define __H__MSHELPER__

#ifdef __cplusplus
extern "C"{
#endif
    
    NSString *SizeToString(long size);
    NSString *MSizeToString(long size);
    NSString *SpeedToString(unsigned long size);
        
    NSString *DeviceUDID();
    
    NSString *getStringValue(NSString *value);
    
    
    NSString *getServicePath(NSString *api);
    
    NSURL *getServiceURL(NSString *api);
    
    NSURL *getUtilityServiceURL(NSString *api);
    
    NSURL *getNewsServiceURL(NSString *api);
    
    NSURL *urlWithLotteryAPI(NSString *api);
    
    UIColor *getColor(NSString *hexColor);
    
    NSString *compareModifyTimeWithNow(NSString *modifyTime);
    
    BOOL isEnabled3G();
    
    BOOL isEnabledWIFI();
    
    BOOL isEnabledNetwork();
    
    NSString *sizeFormat(NSString *size);
    NSString *countFormat(long count);
    
    NSString *stringFormat(NSString *str0, NSString *str1);
    NSInteger lengthOfChineseString(NSString *string);
    
    UIImage *appStar(int starRate);
    
    UIBarButtonItem * createBackButton(id owner, NSString *title);
    
    void logRect(CGRect rect);
    
    NSString* keychainValueForKey(const NSString* key);
    void setKeychainValueForKey(const NSString *value,const NSString *key);
    
    NSData *DESEncrypt(NSData *data, NSString *key);
    NSData *DESDecrypt(NSData *data, NSString *key);
    
    //2013-12-18,by LongMei
    /**
     *  将三位数字转换成系统版本的格式字符串
     *
     *  @param versionNumber 要转换的三位数
     *
     *  @return 转换成的格式字符串
     */
    NSString *versionNumConvertToString(int versionNumber);
    
    /**
     *  将系统版本字符串转换成三位数
     *
     *  @param versionString 系统版本字符串
     *
     *  @return 转换成的三位数
     */
    int versionStringConvertToNum(NSString *versionString);
    //2013-12-18,by LongMei,end
    
    //2013-12-16,by xiaojun
    //将所下载的图片保存到本地
    void saveImagewithFileNameofType(UIImage *image ,NSString *imageName ,NSString *extension ,NSString *directoryPath);
    //2013-12-16,by xiaojun
    
    //获取文件夹下所有文件
    NSArray* getFilesFromDirPath(NSString* _dicPath);
void ShowMessageLong(NSString *msg);
    
void ShowMessageMid(NSString *msg);
    
void ShowMessageShort(NSString *msg);
    void showMessageBox(NSString *msg, long lastTime);
    
    void ShowMessageWithVersionLimit(NSString *msg);
    
    void showMessageWithPostion(NSString *msg, long lastTime, iToastGravity postion);
    
    UIButton *CreateButton(id target, id title_OR_Image, NSString *selector);
    
    UIBarButtonItem* CreateBarButtonItem(id target, id title_OR_Image, NSString *selector);
    
    /**
     *  iPad
     *
     *  @return 视图的frame
     */
    //主view的frame
    CGRect applicationMainViewFrame();
    /**
     
     *  view的父viewController控制器
     *
     *  @param view
     *
     *  @return
     */
    UIViewController *viewPresentController(UIView *view);
    
    UIColor *colorWithHexString(NSString *hexColorString);
    
    NSString* pageWithIndex (NSInteger index, NSInteger maxCount, NSInteger lenght);
    
    UIImage* viewImageWithRect(UIView *view, CGRect rect);
    
    BOOL is64bitHardware();
    
    void logFrame(CGRect frame);
    
    
    
#ifdef __cplusplus
}
#endif
#endif