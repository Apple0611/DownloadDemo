//
//  MSHelper.m
//  MemSearch
//
//  Created by thilong on 14-2-20.
//  Copyright (c) 2014年 TYC. All rights reserved.
//

#import "MSHelper.h"
#import "TKMicro.h"
#import "UIImage+Color.h"
//#import "Reachability.h"
#import "iToast.h"
#import <mach/mach.h>

#ifdef __cplusplus
extern "C"{
#endif

void ShowMessageLong(NSString *msg)
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:3000] show];
}

void ShowMessageMid(NSString *msg){
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:2000] show];
}

void ShowMessageShort(NSString *msg){
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:1000] show];
}
    
void showMessageBox(NSString *msg, long lastTime)
{
    [[[[iToast makeText:msg] setDuration:lastTime] setGravity:iToastGravityBottom] show:iToastTypeInfo];
}
    
    void showMessageWithPostion(NSString *msg, long lastTime, iToastGravity postion)
    {
        iToast *toast = [[iToast makeText:msg] setDuration:lastTime];
        [toast setGravity:postion];
        [toast show:iToastTypeInfo];
    }
    
    UIButton* CreateButton(id target, id title_OR_Image, NSString *selector)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, 50, 44);
        
        button.titleLabel.font = KDJFont(15);
        
        [button setTitleColor:RGBA(0, 114, 255, 1) forState:UIControlStateNormal];
        
        if ([title_OR_Image isKindOfClass:[NSString class]])
        {
            [button setTitle:title_OR_Image forState:UIControlStateNormal];
        }
        else if ([title_OR_Image isKindOfClass:[UIImage class]])
        {
            [button setImage:title_OR_Image forState:UIControlStateNormal];
        }
        [button addTarget:target action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
        
//        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1]cornerRadius:0] forState:UIControlStateNormal];
        
        return button;
    }
    
    UIBarButtonItem* CreateBarButtonItem(id target, id title_OR_Image, NSString *selector)
    {
        UIButton *button = CreateButton(target, title_OR_Image, selector);
        
        UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        
        return item;
    }
    
    
    
    void ShowMessageWithVersionLimit(NSString *msg)
    {
        ShowMessageLong([NSString stringWithFormat:@"抱歉，此应用仅支持%@以上的系统",msg]);
    }
    
    
    

    CGRect applicationMainViewFrame()
    {
        CGRect  frame;
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
//        {
//            frame = CGRectMake(0, 0, SCREEN_WIDTH- kTabBar_Width, SCREEN_HEIGHT);
//        }
//        else
//        {
//            frame = CGRectMake(0, 0, SCREEN_HEIGHT- kTabBar_Width+20, SCREEN_WIDTH- 20);
//        }
        frame = CGRectMake(0, 0, SCREEN_HEIGHT- kTabBar_Width+20, SCREEN_WIDTH- 20);
        return frame;
    }
    
    UIViewController *viewPresentController(UIView *view)
    {
        for (UIView *next = [view superview]; next; next = next.superview)
        {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]])
            {
                return (UIViewController *) nextResponder;
            }
        }
        return nil;
    }
    
    UIColor *colorWithHexString(NSString *hexColor)
    {
        unsigned int red, green, blue;
        NSRange      range;
        range.length = 2;
        
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        return [UIColor colorWithRed:(float) (red / 255.0f) green:(float) (green / 255.0f) blue:(float) (blue / 255.0f) alpha:1.0f];
    }
    
    static NSString *host = @"api.ios.d.cn";
    static NSString *dir  = @"api";
    //static BOOL _isHD;
    
    NSString *SizeToString(long size)
    {
        NSString *sizeStr = nil;
        SIZE_TO_STR(size, sizeStr);
        return sizeStr;
    }
    NSString *MSizeToString(long size)
    {
        NSString *sizeStr = nil;
        MSIZE_TO_STR(size, sizeStr);
        return sizeStr;
    }
    
    NSString *SpeedToString(unsigned long size)
    {
        NSString *sizeStr = nil;
        SPEED_TO_STR(size, sizeStr);
        return sizeStr;
        
    }
    
    NSString *DeviceUDID()
    {
        static NSString *deviceUUid = nil;
        
//        if(deviceUUid) return deviceUUid;
        
        if (deviceUUid == nil)
        {
            deviceUUid = [keychainValueForKey(@"Device_UUID") retain];
        }
        
        if (deviceUUid == nil)
        {
            CFUUIDRef   uuid       = CFUUIDCreate(nil);
            CFStringRef uuidString = CFUUIDCreateString(nil, uuid);
            
            deviceUUid = (NSString *) CFStringCreateCopy(nil, uuidString);
            
            CFRelease((CFTypeRef) uuid);
            CFRelease((CFTypeRef) uuidString);
            
            setKeychainValueForKey(deviceUUid, @"Device_UUID");
        }
//        NSLog(@"*****UUID:%@  partar:%@", deviceUUid, CLIENT_PARTNERS);
        return deviceUUid;
    }
    

    
    NSString *getServicePath(NSString *api)
    {
        return [NSString stringWithFormat:@"http://%@/%@/%@", host, dir, api];
    }
    
    NSURL *getServiceURL(NSString *api)
    {
        return [NSURL URLWithString:getServicePath(api)];
    }
    
    NSURL *getUtilityServiceURL(NSString *api)
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/%@", host, @"Utility", api]];
    }
    
    NSURL *getNewsServiceURL(NSString *api)
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api-news/%@", host,  api]];
    }
    
    NSURL *urlWithLotteryAPI(NSString *api)
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/Activity_GreedySnake/%@", host, api]];
    }
    
    UIColor *getColor(NSString *hexColor)
    {
        unsigned int red, green, blue;
        NSRange      range;
        range.length = 2;
        
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        return [UIColor colorWithRed:(float) (red / 255.0f) green:(float) (green / 255.0f) blue:(float) (blue / 255.0f) alpha:1.0f];
    }
    
    NSString *compareModifyTimeWithNow(NSString *modifyTime) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *modifyDate = [dateFormat dateFromString:modifyTime];
        
        //获取本地时间
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        
        NSDateComponents *yearComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:modifyDate toDate:localeDate options:0];
        NSDateComponents *monthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:modifyDate toDate:localeDate options:0];
        NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:modifyDate toDate:[NSDate date] options:0];
        NSDateComponents *hourComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:modifyDate toDate:[NSDate date] options:0];
        
        switch (yearComponents.year) {
            case 0:
                switch (monthComponents.month) {
                    case 0:
                        switch (dayComponents.day) {
                            case 0:
                                switch (hourComponents.hour) {
                                    case 0:
                                        return [NSString stringWithFormat:@"1小时前"];
                                        break;
                                        
                                    default:
                                        return [NSString stringWithFormat:@"%d小时前",hourComponents.hour];
                                        break;
                                }
                                break;
                                
                            default:
                                return [NSString stringWithFormat:@"%d天前",dayComponents.day];
                                break;
                        }
                        break;
                        
                    default:
                        return [NSString stringWithFormat:@"%d个月前",monthComponents.month];
                        break;
                }
                break;
                
            default:
                return yearComponents.year > 5 ? [NSString stringWithFormat:@"5年前"] : [NSString stringWithFormat:@"%d年前",yearComponents.year];
                break;
        }
    }
    
    BOOL isEnabled3G()
    {
        return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
    }

    BOOL isEnabledWIFI()
    {
        return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
    }
    
    BOOL isEnabledNetwork()
    {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len    = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        // Recover reachability flags
        SCNetworkReachabilityRef   defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress);
        SCNetworkReachabilityFlags flags;
        
        BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
        CFRelease(defaultRouteReachability);
        
        if (!didRetrieveFlags)
        {
            return NO;
        }
        
        BOOL isReachable     = flags & kSCNetworkFlagsReachable;
        BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
        
        return (isReachable && !needsConnection) ? YES : NO;
    }
        
    UIImage *appStar(int starRate)
    {
        static NSArray *overallAppStars;
        if (overallAppStars == nil)
        {
            NSMutableArray *tempAppStars = [NSMutableArray new];
            for (int i = 0; i < 11; i++)
            {
                [tempAppStars addObject:[UIImage imageNamed:[NSString stringWithFormat:@"cell_star_%d.png", i]]];
            }
            overallAppStars = [[NSArray alloc] initWithArray:tempAppStars];
            [tempAppStars release];
        }
        if (starRate > overallAppStars.count-1)
            return nil;
        return [overallAppStars objectAtIndex:starRate];
    }
    
//    UIBarButtonItem * createBackButton(id owner, NSString *title)
//    {
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0, 0, 50, 30);
//        [backButton setBackgroundImage:PNG_FROM_NAME(@"app_navigation_back_button_bg") forState:UIControlStateNormal];
//        [backButton setTitle:title ? title : @"返回" forState:UIControlStateNormal];
//        [backButton setTitleColor:getColor(@"aaaaaa") forState:UIControlStateHighlighted];
//        [backButton setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
//        backButton.titleLabel.font = FontWithSize(15);
//        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//        [backButton addTarget:owner action:@selector(backButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
//        return backButtonItem;
//    }
    
    
    NSString *stringFormat(NSString *str0, NSString *str1)
    {
        return [NSString stringWithFormat:@"%@%@", str0, str1];
    }
    
    NSInteger lengthOfChineseString(NSString *string)
    {
        NSUInteger length = 0;
        for (NSUInteger i = 0; i < string.length; i++)
        {
            unichar uc = [string characterAtIndex: i];
            length += isascii(uc) ? 1 : 2;
        }
        
        return length;
    }
    
    void logRect(CGRect rect) {
        NSLog(@"%f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }
    
    
    NSString *sizeFormat(NSString *size)
    {
        if ([@"" isEqualToString:size])
        {
            return nil;
        }
        NSString *arrangedSize;
        if (([size floatValue] / 1024.0f) > 1.0f)
        {
            arrangedSize = [NSString stringWithFormat:@"%.2fGB", [size floatValue] / 1024.0f];
        }
        else
        {
            arrangedSize = [NSString stringWithFormat:@"%.1fMB", [size floatValue]];
        }
        return arrangedSize;
    }
    
    NSString *countFormat(long count)
    {
        if (count > 10000)
        {
            return [NSString stringWithFormat:@"%.1f万次下载", count / 10000.0f];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld次下载", count];
        }
    }
    
    NSString* pageWithIndex (NSInteger index, NSInteger maxCount, NSInteger lenght)
    {
        NSInteger total = maxCount / lenght;
        if (maxCount % lenght != 0) {
            total++;
        }
        if (total  > 0) {
            index++;
        }
        
        NSString *currentPage = [NSString stringWithFormat:@"%d/%d", index, total];
        currentPage = [currentPage isEqualToString:@"0/0"] ? @"" : currentPage;
        return currentPage;
    }
    
#pragma mark - keychain read & write
    
//    NSString* keychainValueForKey(const NSString* key)
//    {
//        MCSMGenericKeychainItem *keychainItem =
//        [MCSMGenericKeychainItem genericKeychainItemForService:@"DJGameCenter"
//                                                      username:(NSString*)key];
//        
//        return keychainItem.password;
//        
//    }
//    
//    void setKeychainValueForKey(const NSString *value,const NSString *key)
//    {
//        MCSMGenericKeychainItem *keychainItem =
//        [MCSMGenericKeychainItem genericKeychainItemForService:@"DJGameCenter"
//                                                      username:(NSString*)key];
//        if(keychainItem)
//        {
//            [keychainItem removeFromKeychain];
//        }
//        
//        [MCSMGenericKeychainItem genericKeychainItemWithService:@"DJGameCenter"
//                                                       username:(NSString*)key
//                                                       password:(NSString*)value];
//    }
    
#pragma mark - DES
    
//    NSData *DESEncrypt(NSData *data, NSString *key)
//    {
//        if(nil == data || 0 == data.length || nil == key || 0 == key.length) return nil;
//        
//        char keyPtr[kCCKeySizeAES256+1] = {0};
//        bzero(keyPtr, sizeof(keyPtr));
//        
//        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//        
//        NSUInteger dataLength = [data length];
//        
//        size_t bufferSize = dataLength + kCCBlockSizeAES128;
//        char *buffer = malloc(bufferSize);
//        
//        size_t numBytesEncrypted = 0;
//        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                              kCCAlgorithmDES,
//                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                              keyPtr,
//                                              kCCBlockSizeDES,
//                                              NULL,
//                                              [data bytes],
//                                              dataLength,
//                                              buffer,
//                                              bufferSize,
//                                              &numBytesEncrypted);
//        
//        NSData *encryptData = nil;
//        
//        if (cryptStatus == kCCSuccess)
//        {
//            encryptData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
//        }
//        
//        free(buffer);
//        
//        return encryptData;
//    }
    
//    NSData *DESDecrypt(NSData *data, NSString *key)
//    {
//        if(nil == data || 0 == data.length || nil == key || 0 == key.length) return nil;
//        
//        char keyPtr[kCCKeySizeAES256+1] = {0};
//        bzero(keyPtr, sizeof(keyPtr));
//        
//        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//        
//        NSUInteger dataLength = [data length];
//        
//        size_t bufferSize = dataLength + kCCBlockSizeAES128;
//        void *buffer = malloc(bufferSize);
//        
//        size_t numBytesDecrypted = 0;
//        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                              kCCAlgorithmDES,
//                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                              keyPtr,
//                                              kCCBlockSizeDES,
//                                              NULL,
//                                              [data bytes],
//                                              dataLength,
//                                              buffer,
//                                              bufferSize,
//                                              &numBytesDecrypted);
//        
//        NSData *decryptData = nil;
//        
//        if (cryptStatus == kCCSuccess)
//        {
//            decryptData = [NSData dataWithBytes:buffer length:numBytesDecrypted];
//        }
//        
//        free(buffer);
//        
//        return decryptData;
//    }
    
    //2013-12-16,by xiaojun
    //将所下载的图片保存到本地
    void saveImagewithFileNameofType(UIImage *image ,NSString *imageName ,NSString *extension ,NSString *directoryPath) {
        if ([[extension lowercaseString] isEqualToString:@"png"]) {
            [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        } else {
            //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
            NSLog(@"文件后缀不认识");
        }
    }
    //2013-12-16,by xiaojun
    
    //2013-12-18,by LongMei
    NSString *versionNumConvertToString(int versionNumber) {
        int count = 0;
        int n = versionNumber;
        while (n) {
            n = n / 10;
            count++;
        }
        int first = versionNumber / ((int)pow(10, count - 1));
        int second = (versionNumber / ((int)pow(10, count - 2))) % 10;
        int third = versionNumber % ((int)pow(10, count - 2));
        return [NSString stringWithFormat:@"%d.%d.%d",first,second,third];
    }
    
    int versionStringConvertToNum(NSString *versionString) {
        NSString *firstOfVersion = [versionString substringWithRange:NSMakeRange(0,1)]; //版本号 第一位 和第二位
        NSString *secondOfVersion = [versionString substringWithRange:NSMakeRange(2,1)];
        NSString *thirdOfVersion;
        if (versionString.length < 5) {
            thirdOfVersion = @"0";
        }
        else {
            thirdOfVersion = [versionString substringWithRange:NSMakeRange(4,1)];
        }
        
        int first = [firstOfVersion intValue];
        int second = [secondOfVersion intValue];
        int third = [thirdOfVersion intValue];
        
        return (first * 100 + second * 10 + third);
    }
    
    //2013-12-18,by LongMei,end

    NSArray* getFilesFromDirPath(NSString* _dicPath)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *fileList = nil;
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        fileList = [fileManager contentsOfDirectoryAtPath:_dicPath error:&error];
        
        
        NSMutableArray *arrayRtn= [[NSMutableArray alloc]init];
        for (NSString *str in fileList) {
            BOOL isDir=NO;
            NSString *path = [_dicPath stringByAppendingPathComponent:str];  //递归  搜出文件夹下的文件
            [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
            if (isDir) {
                [arrayRtn addObjectsFromArray:getFilesFromDirPath(path)];
            }
            else{
                [arrayRtn addObject:[ NSString stringWithFormat:@"%@/%@",_dicPath,str]];
            }
            
        }
        //    NSLog(@"Every Thing in the dir:%@",arrayRtn);
        
        return arrayRtn;
    }
    
    UIImage* viewImageWithRect(UIView *view, CGRect rect)
    {
        CALayer *layer = view.layer;
        rect = CGRectMake((layer.frame.size.width-rect.size.width)/2, 0, rect.size.width, rect.size.height);
        CGFloat scale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale
                          , rect.size.width * scale, rect.size.height * scale);
        CGImageRef imageRef = screenshot.CGImage;
        //-------------> myInmageRect想要截取的区域
        CGRect myImageRect=rect;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
        //获取上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, myImageRect, subImageRef);
        //转换img
        UIImage* image = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        return image;
    }
    
    BOOL is64bitHardware()
    {
#if __LP64__
        return YES;
#endif
        static BOOL sHardwareChecked = NO;
        static BOOL sIs64bitHardware = NO;
        
        if(!sHardwareChecked)
        {
            sHardwareChecked = YES;
            
#if TARGET_IPHONE_SIMULATOR
//            sIs64bitHardware = is64bitSimulator();
            
#else
            struct host_basic_info host_basic_info;
            unsigned int count;
            kern_return_t returnValue = host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)(&host_basic_info), &count);
            if(returnValue != KERN_SUCCESS)
            {
                sIs64bitHardware = NO;
            }
            
            sIs64bitHardware = (host_basic_info.cpu_type == CPU_TYPE_ARM64);
#endif
        }
        return sIs64bitHardware;
    }
    
    void logFrame(CGRect frame)
    {
        NSLog(@"%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
    
#ifdef __cplusplus
}
#endif