//
//  MSHelper.m
//  MemSearch
//
//  Created by thilong on 14-2-20.
//  Copyright (c) 2014年 TYC. All rights reserved.
//

#import "TKCodeHelper.h"

#ifdef __cplusplus
extern "C"{
#endif

    bool _device_jailbreaked = false;
    
    void _check_jailbreak(){
        FILE *f = fopen("/bin/bash","r");
        if(f){
            _device_jailbreaked = true;
            fclose(f);
        }
        else
            _device_jailbreaked = false;
    };

     
    NSString *encodeToPercentEscapeString(NSString *input)
    {
        NSString *outputStr = (NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (CFStringRef) input,
                                                NULL,
                                                (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                kCFStringEncodingUTF8);
        return outputStr;
    }
    
    
#ifdef __cplusplus
}
#endif