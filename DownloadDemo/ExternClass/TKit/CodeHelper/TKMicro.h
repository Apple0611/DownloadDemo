//
//  TKMicro.h
//
//  Created by Thilong on 13-11-1.
//  Copyright (c) 2013年 Thilong. All rights reserved.
//

#ifndef __H__TKMICRO__
#define __H__TKMICRO__


/***************渠道号*****************/
#ifdef OFFICAL_VERSION
//免越狱版
#define CLIENT_PARTNERS (IS_PHONE ? @"DJ_IPHONE_FREE_000" : @"DJ_IPAD_FREE_000")
#else
#ifdef _DEB_
//Deb版本
#define CLIENT_PARTNERS (IS_PHONE ? @"DJ_IPHONE_DEB_000" : @"DJ_IPAD_DEB_000")
#else
//越狱版
#define CLIENT_PARTNERS (IS_PHONE ? @"DJ_IPHONE_000" : @"DJ_IPAD_000")
#endif
#endif

/***************越狱、免越狱*****************/
#ifdef OFFICAL_VERSION
#define CLIENT_PLATFORM (IS_PHONE ? @"iphonefree" : @"ipadfree")
#else
#define CLIENT_PLATFORM (IS_PHONE ? @"iphone" : @"ipad")
#endif

/***************客户端版本*****************/
#define   CLIENT_TAG (IS_PHONE ? @"DJ_IPHONE %@"  : @"DJ_IPAD %@" )

#define CLIENT_VERSION @"500"
#define CLIENT_VERSION_NUM @"500"

#define BAD_REQUEST -999
#define AUTHORISED_FLAG (IS_JAILBREAKED ? @"0" : @"1")
#define HTTP_SERVER_ADDRESS                         @"http://127.0.0.1:8999/"
#define HTTPS_SERVER_ADDRESS                    @"https://api.ios.d.cn/api/"
#define RETINA ([[UIScreen mainScreen] scale]==2.0)   //[[[UIDevice currentDevice]systemVersion]intValue]>4 &&



#define PNG_FROM_NAME(_PNGFILE)  ([UIImage imageNamed:_PNGFILE])

#define PNG_FROM_FILE_WITH_STRETCH (_PNGFILE,_LEFT,_TOP) ([PNG_FROM_FILE(_PNGFILE) stretchableImageWithLeftCapWidth:_LEFT topCapHeight:_TOP])
#define PNG_FROM_NAME_WITH_STRETCH (_PNGFILE,_LEFT,_TOP) ([PNG_FROM_NAME(_PNGFILE) stretchableImageWithLeftCapWidth:_LEFT topCapHeight:_TOP])

#define DISPATCH_GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#define ZERO_FRAME      CGRectMake(0.0f,0.0f,0.0f,0.0f)


#define SCREEN_REAL_HEIGHT [UIScreen mainScreen].bounds.size.height

#define MSIZE_TO_STR(SIZE_TM,TARGET_STR)         \
double SIZE_T = SIZE_TM * 1.0f;         \
if (SIZE_T  > 1024 )      \
{                                       \
TARGET_STR = [NSString stringWithFormat:@"%.2f GB", SIZE_T  / 1024 ]; \
}                                          \
else                                                            \
{                                                               \
TARGET_STR = [NSString stringWithFormat:@"%.0f MB", SIZE_T]; \
}
#define SIZE_TO_STR(SIZE_TM,TARGET_STR)         \
if(true){                      \
double SIZE_T = SIZE_TM * 1.0f;         \
if (SIZE_T / 1024 > (1024 * 1024))      \
{                                       \
TARGET_STR = [NSString stringWithFormat:@"%.2f GB", SIZE_T / 1024 / 1024 / 1024]; \
}                                          \
else if(SIZE_T / 1024 > 1024 )      \
{                                   \
TARGET_STR = [NSString stringWithFormat:@"%.1f MB", SIZE_T / 1024 / 1024]; \
}                                   \
else if(SIZE_T  > 1024)             \
{                                   \
TARGET_STR = [NSString stringWithFormat:@"%.1f KB", SIZE_T / 1024];    \
}                                                               \
else                                                            \
{                                                               \
TARGET_STR = @"0 KB"; \
}                     \
}

#define     FontWithSize(size)                         [UIFont systemFontOfSize:size]
#define SPEED_TO_STR(SIZE_TM,TARGET_STR)         \
double SIZE_T = SIZE_TM * 1.0f;         \
if (SIZE_T / 1024 > (1024 * 1024))      \
{                                       \
TARGET_STR = [NSString stringWithFormat:@"%.2f GB/s", SIZE_T / 1024 / 1024 / 1024]; \
}                                          \
else if(SIZE_T / 1024 > 1024 )      \
{                                   \
TARGET_STR = [NSString stringWithFormat:@"%.1f MB/s", SIZE_T / 1024 / 1024]; \
}                                   \
else            \
{                                   \
TARGET_STR = [NSString stringWithFormat:@"%.1f KB/s", SIZE_T / 1024];    \
}                                                               \

#define RUNNING_ON_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


#define POST_NOTIFICATION(NAME,OBJ) [[NSNotificationCenter defaultCenter] postNotificationName:NAME object:OBJ];
#define DEFAULT_NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

#define ADD_NOTIFICATION(NAME, SEL__, OBJ)  [[NSNotificationCenter defaultCenter] addObserver:self selector:SEL__ name:NAME object:OBJ];
#define DELETE_NOTIFICATION(NAME, OBJ)  [[NSNotificationCenter defaultCenter] removeObserver:self name:NAME object:OBJ];

#define DEFAULT_FILE_MANAGER        [NSFileManager defaultManager]
#define STATUS_BAR_HIDDEN           ([[UIApplication sharedApplication] isStatusBarHidden])
#define STATUS_BAR_HEIGHT      ([[UIApplication sharedApplication] isStatusBarHidden] ? 0 : [[UIApplication sharedApplication] statusBarFrame].size.height)

#define getServiceAddress getServicePath

//********************************************************
typedef NS_ENUM(NSInteger, NSFontType)
{
    NSFontWithTypeNavigation = 20,
    NSFontWithTypeText       = 10,
    NSFontWithTypeSegment    = 16,
    NSFontWithTypeTitle      = 14
} ;

typedef NS_ENUM(NSInteger, EntryDetailType) {
    EntryDetailTypeAppList,//应用列表
    EntryDetailTypeNewsList,//资讯列表
    EntryDetailTypeTaggroup,//订阅标签
    EntryDetailTypeAlbum,//合辑详情
    EntryDetailTypeSearchAppList,//搜索结果应用列表
};

typedef NS_ENUM(NSInteger, DetailViewType) {
    NonDetail,//无详情页面
    AppDetail,//应用详情
    EntryDetail,//快捷入口子页面
    RelateDetail,//相关详情页
    SearchDetail,//搜索页面弹出界面
    AppDetailAlbumList,//应用详情页合辑列表
    NewsDetail//宝典详情界面
};

typedef NS_ENUM(NSInteger, GameCategory) {
//    GameCategoryClosen = 0,
    GameCategorySingle = 0,
    GameCategoryNetGame,
    GameCategorySoftware,
    GameCategoryRank,
    GameCategoryAlbum,
    GameCategoryDeault = 100
};

typedef NS_ENUM(NSInteger, RemoteNotification)
{
    RemoteNotificationDefault = 0,
    RemoteNotificationAppDetail,
    RemoteNotificationNewsDetail,
};

typedef NS_ENUM(NSInteger, TabBar)
{
    TabBarHome = 0,
    TabBarDownload,
    TabBarNews,
    TabBarMemberCenter
};


typedef void (^BGRmoveBlock)(void);
typedef void (^SingleAppTapBlock)(void);
typedef void (^AchievingConformBlock)(void);
typedef void (^AchievingHideFinishedBlock)(void);

#define     HomeAdTimerPauseNotificationName   @"HomeAdTimerPauseNotificationName"
#define     HomeAdTimerStartNotificationName   @"HomeAdTimerStartNotificationName"
#define     HomeIphoneAdTimerPauseNotificationName   @"HomeIphoneAdTimerPauseNotificationName"
#define     HomeIphoneAdTimerStartNotificationName   @"HomeIphoneAdTimerStartNotificationName"

#define     KNotificationOrientationChanged   @"KNotificationOrientationChanged"

#define     KTEXT_Selected_Color              colorWithHexString(@"0072FF")
#define     KTEXT_Normal_Color              colorWithHexString(@"5C5C5C")
#define     KVIEW_Background_Color              colorWithHexString(@"F4F3F3")

#define     IPHONE_APP_CELLHEIGHT            68
#define     IPAD_APP_CELLHEIGHT              116

#define     KTabBar_Height_iPhone         49.0f
#define     KNavBar_Height_iPhone         44.0f
#define     LOAD_NIB(_NAME) ([[[NSBundle mainBundle] loadNibNamed:_NAME owner:self options:nil]objectAtIndex:0])
#define     TABLE_UPDATE_EDGEINSET            UIEdgeInsetsMake(40, 0, 0, 0)

#define     REQUEST_COUNT                            @"20"

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define     IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)
#define     IS_PHONE  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//#define     IS_JAILBREAKED (_device_jailbreaked)
#define     IS_JAILBREAKED (YES)
#define     IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

#define     IS_IOS7_1 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.1f)

#define     KSafe_Realse_nil(obj)   if((obj) != nil) {[obj release]; obj = nil;}

//screen width  height
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height - 20.0f)

#define FH(_FRAME_) (_FRAME_.size.height)
#define FW(_FRAME_) (_FRAME_.size.width)
#define FX(_FRAME_) (_FRAME_.origin.x)
#define FY(_FRAME_) (_FRAME_.origin.y)


#define VH(_VIEW_) FH(_VIEW_.frame)
#define VW(_VIEW_) FW(_VIEW_.frame)
#define VX(_VIEW_) FX(_VIEW_.frame)
#define VY(_VIEW_) FY(_VIEW_.frame)


#define POST_NOTIF(NAME, OBJ) [[NSNotificationCenter defaultCenter] postNotificationName : NAME object : OBJ];
#define CACHE_FOLDER (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])
#define DOCUMENT_FOLDER (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])
#define RGBA(_R, _G, _B, _A) ([UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A])
#define LOAD_XIB(_NAME,_TYPE) ((_TYPE *)[[[NSBundle mainBundle] loadNibNamed:_NAME owner:self options:nil] objectAtIndex:0])

#define XIB_PORT @property (nonatomic,assign) IBOutlet

#define PNG_FROM_FILE(_PNGFILE)  ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(IS_RETINA?([NSString stringWithFormat:@"%@@2x",_PNGFILE]): _PNGFILE) ofType:@"png"]])
#define PNG_FROM_NAME(_PNGFILE)  ([UIImage imageNamed:_PNGFILE])


#define CELL_DECLARE \
+ (float)cellHeight; \
+ (NSString *)cellReuseIdentifier;

#define CELL_DECLARE_DETAIL(_CLASS_, _HEIGHT_, _IDENTIFER_) \
+ (float)cellHeight \
{ \
return _HEIGHT_; \
} \
\
+ (NSString *)cellReuseIdentifier \
{ \
static NSString *cell_Identifer = _IDENTIFER_; \
return cell_Identifer; \
} \
\
- (NSString *)reuseIdentifier \
{ \
return [_CLASS_ cellReuseIdentifier]; \
}



#define DEALLOC_START \
- (void)dealloc \
{
#define DEALLOC_END \
[super dealloc]; \
}

#define KDJFont(_SIZE_)     ([UIFont systemFontOfSize:_SIZE_])
#define KDJBoldFont(_SIZE_)     ([UIFont boldSystemFontOfSize:_SIZE_])

#define BUILD_TEXT_BAR_BUTTON(_TARGET_, _TEXT_, _SIDE_, _SELECTOR_) \
if(1){ \
    UIButton *customButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 38)] autorelease];\
    [customButton setTitle:_TEXT_ forState:UIControlStateNormal];\
    [customButton.titleLabel setFont:KDJFont(14)];\
    [customButton addTarget:_TARGET_ action:@selector(_SELECTOR_) forControlEvents:UIControlEventTouchUpInside];\
    _TARGET_.navigationItem._SIDE_##BarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:customButton] autorelease];\
}

#define BUILD_ICON_BAR_BUTTON(_TARGET_, _NORMAL_IMG_,_HIGH_LIGHT_IMG_, _SIDE_, _SELECTOR_)\
if(1){ \
    CGRect frame={{0,0},{0,0}}; \
    frame.size = _NORMAL_IMG_.size; \
    UIButton *customButton = [[[UIButton alloc] initWithFrame:frame] autorelease];\
    [customButton setImage:_NORMAL_IMG_ forState:UIControlStateNormal];\
    [customButton setImage:_HIGH_LIGHT_IMG_ forState:UIControlStateHighlighted];\
    [customButton addTarget:_TARGET_ action:@selector(_SELECTOR_) forControlEvents:UIControlEventTouchUpInside];\
    _TARGET_.navigationItem._SIDE_##BarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:customButton] autorelease];\
}

#define LStr(_KEY_) NSLocalizedString(_KEY_,nil)



/**
 *  iPad
 */
//TK Tab bar///////////////////////////////
#define     kTabBar_Top            100.0f
#define     kEachItem_Width        80.0f
#define     kEachItem_Height       74.0f
#define     kPadding_Y             0.0f
#define     kPadding_X             0.0f
#define     kEachView_Width        (kEachItem_Width + kPadding_X*2.0f)
#define     kEachView_Height       (kEachItem_Height + kPadding_Y)
#define     kTabBar_Width          kEachView_Width
#define     kTabBar_Height         SCREEN_HEIGHT

#define     KNavBar_Height_iPad        44.0f

#define LOCAL_APP_MANAGER           [TLocalAppManager sharedManager]

#define RGBColor(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
#endif //__H__TKMICRO__












