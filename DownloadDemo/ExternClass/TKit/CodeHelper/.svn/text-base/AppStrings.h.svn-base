//  Created by thilong on 13-8-7.
//  Copyright (c) 2013年 Downjoy. All rights reserved.
//  程序所使用的字符串定义，请使用"import"关键字导入。


#pragma mark tabBar相关

#define IDS_TABBAR_Changed            @"com.d.cn.tabbar.changed"
#define kShowDownloadCydiaHelper @"kShowDownloadCydiaHelper"

//ipad消息

#pragma mark - 消息定义
#define IDN_DOWNLOAD_QUEUE_CHANGED      @"d.cn.download.queueChanged"   //下载队列出现了变化(添加或者移除了下载)
#define IDN_DOWNLOADED_QUEUE_CHANGED    @"d.cn.downloaded.queueChanged" //已经下载的队列发生变化了
#define IDN_UNINSTALL_ENQUEUE           @"d.cn.uninstall.Enqueue"

#define IDN_APP_CATEGORY_Refreshed               @"IDN_APP_CATEGORY_Refreshed" //应用类别有更新
#define IDN_APP_Menu_Changed                         @"IDN_APP_Menu_Changed" //应用菜单改变

#define IDN_APP_Menu_Page_Changed                         @"IDN_APP_Menu_Page_Changed" //应用菜单页码改变

#define MANAGER_CAN_BE_UPDATE_GET_DATA_SUCCESS @"d.cn.app.request.upgrade.success"
#define MANAGER_CAN_BE_UPDATE_GET_DATA_FAILED  @"d.cn.app.request.upgrade.failed"
#define IDN_INSTALLED_APP_UPDATE    @"d.cn.installed.appUpdate" //从后台到前台后 已下载列表 更新完状态后发起

#define IDN_TABBAR_ITEM_Changed          @"IDN_TABBAR_ITEM_Changed"


#define IDS_IPAD_RIGISTER_SUCCESS  @"d.cn.rigister.success"
//iPhone消息
#pragma mark 安装相关协议定义
#define IDS_INSTALL_PROXY_App_Refreshed @"com.d.cn.installProxy.appRefreshCompleted"  //app更新完成
#define IDS_INSTALL_PROXY_Check_Upgrade_Complete  @"com.d.cn.installProxy.checkAppUpgradeCompleted" //可更新列表数据获取完成
#define IDS_INSTALL_PROXY_Check_Upgrade_Failed  @"com.d.cn.installProxy.checkAppUpgradeFailed" //可更新列表数据获取失败
#define IDS_INSTALL_PROXY_Install_Status_Changed @"com.d.cn.installProxy.installStatusChanged" //下载完成的app 安装状态变化 包括正在获取地址 正在安装 安装完成 安装失败
#define IDS_INSTALL_PROXY_Uninstall_Status_Changed @"com.d.cn.installProxy.uninstallStatusChanged" //卸载app状态变化 卸载完成 卸载失败
#define IDS_INSTALL_PROXY_Install_Complete @"com.d.cn.installProxy.installComplete" //安装完成通知
#define IDS_INSTALL_PROXY_Uninstall_Complete @"com.d.cn.installProxy.uninstallComplete"//卸载完成通知


//下载队列相关消息 （由于时间原因 整合版本的 下载状态变化 消息没有整合 ）
#pragma mark 下载相关通知
#define IDS_DOWNLOAD_Queue_Added    @"com.d.cn.download.QueueAdded" //添加一个下载到下载队列
#define IDS_DOWNLOAD_Queue_Removed  @"com.d.cn.Download.QueueRemoved" //从下载队列移除一个下载
#define IDS_DOWNLOAD_Queue_Complete  @"com.d.cn.Download.QueueComplete"//一个下载完成
#define IDS_DOWNLOAD_Queue_Changed  @"com.d.cn.download.QueueChanged" //下载队列发生变化
#define IDS_DOWNLOAD_Status_Changed @"com.d.cn.download.StatusChanged"//下载状态发生变化
#define IDS_DOWNLOAD_update_all             @"com.d.cndownload.Update.all"//全部更新

#define IDS_DOWNLOADED_Queue_Changed  @"com.d.cn.downloaded.QueueChanged" //ipad下载状态发生变化
#define IDS_DOWNLOADED_Queue_Removed  @"com.d.cn.downloaded.QueueRemoved" //ipad下载队列移除操作

#define IDS_DOWNLOAD_Update_ReDownLoad_ipa @"com.d.cn.download.Update.Redownload.ipa" //重新下载消息

#define IDS_CLEAR_Cache_Complete  @"com.d.cn.clear.Cache_Complete" //清理缓存完成

#pragma mark  protectScreen相关通知
#define IDS_PROTECT_show  @"com.d.cn.showProtect" //屏保显示 隐藏
#define IDS_PROTECT_hide  @"com.d.cn.hideProtect"

#pragma mark  标签、合辑相关通知
#define IDS_ATTENTION_Added             @"com.d.cn.attention.added"
#define IDS_ATTENTION_Removed           @"com.d.cn.attention.removed"
#define IDS_ATTENTION_Changed           @"com.d.cn.attention.changed"

#define IDS_ALBUM_Added                 @"com.d.cn.album.added"
#define IDS_ALBUM_Removed               @"com.d.cn.album.removed"
#define IDS_ALBUM_Changed               @"com.d.cn.album.changed"
#define IDS_GAMEOVER                    @"com.d.cn.gameOver"
#define IDS_GAMEPAUSE                   @"com.d.cn.gamePause"
#define IDS_GAMEQUIT                    @"com.d.cn.gameQuit"
#define IDS_GAMESTART                   @"com.d.cn.gameSTART"
#define IDS_GAMESCORE                   @"com.d.cn.gameScore"
#define IDS_GAME_UPDATE_RANK            @"com.d.cn.gameRank"

#define IDS_USER_LOGIN_SUCCESS          @"userLocin_Success"
#define IDS_USER_GET_ICON_SUCCESS          @"userGetIcon_Success"
#define IDS_USER_LOGOUT_SUCCESS          @"userLogout_Success"
#pragma mark 数据库操作相关

// db数据库操作 SQL语句   表的增删改 包括已下载app  正在下载app  字段记录了app的基本信息和当前状态（下载 暂停 已下载 已安装 等）
#define IDS_DATABASE_Drop_AdvertActivity_Cache  @"DROP TABLE IF EXISTS AdvertActivity"
#define IDS_DATABASE_Create_AdvertActivity_Cache  @"CREATE TABLE AdvertActivity(ID integer,title text,shortDesc text,description text,thumb text,url text,joined integer,code text,beginTime text,endTime text,status int, PRIMARY KEY(\"ID\"))"
#define IDS_DATABASE_Create_Downloading_Cache   @"Create Table DownloadingCache (ID integer,size zinteger,newVersionSize integer,status integer,ipaUrl NVARCHAR(200),iconUrl NVARCHAR(200),bundleID NVARCHAR(50),name NVARCHAR(50),englishName NVARCHAR(100),version NVARCHAR(20),versionNew NVARCHAR(20),appPathOnDevice NVARCHAR(100),fileType integer default '0')"
#define IDS_DATABASE_Create_Downloading_Cache_Index @"Create Unique Index IDX_DownloadingCache ON DownloadingCache (bundleID ASC,version ASC,fileType ASC)"
#define IDS_DATABASE_Replace_Downloading_Cache   @"Replace Into DownloadingCache (ID ,size ,newVersionSize ,status ,ipaUrl ,iconUrl ,bundleID ,name ,englishName ,version ,versionNew ,appPathOnDevice ,fileType ) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"
#define IDS_DATABASE_Query_Downloading_Cache   @"select * from DownloadingCache"
#define IDS_DATABASE_Delete_Downloading_Cache  @"delete from DownloadingCache where bundleID=? and version=? and fileType=?"
#define IDS_DATABASE_Drop_Downloading_Cache  @"DROP TABLE IF EXISTS DownloadingCache"
#define IDS_DATABASE_Drop_Downloading_Cache_Index  @"DROP Index IF EXISTS IDX_DownloadingCache"

#define IDS_DATABASE_Create_Downloaded_Cache   @"Create Table DownloadedCache (ID integer,size zinteger,newVersionSize integer,status integer,ipaUrl NVARCHAR(200),iconUrl NVARCHAR(200),bundleID NVARCHAR(50),name NVARCHAR(50),englishName NVARCHAR(100),version NVARCHAR(20),versionNew NVARCHAR(20),appPathOnDevice NVARCHAR(100),fileType integer default '0',versionTmp text)"
#define IDS_DATABASE_Create_Downloaded_Cache_Index @"Create Unique Index IDX_DownloadedCache ON DownloadedCache (bundleID ASC,version ASC,fileType ASC)"
#define IDS_DATABASE_Replace_Downloaded_Cache   @"Replace Into DownloadedCache (ID ,size ,newVersionSize ,status ,ipaUrl ,iconUrl ,bundleID ,name ,englishName ,version ,versionNew ,appPathOnDevice ,fileType ,versionTmp) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
#define IDS_DATABASE_Query_Downloaded_Cache   @"select * from DownloadedCache"
#define IDS_DATABASE_Delete_Downloaded_Cache  @"delete from DownloadedCache where bundleID=? and version=? and fileType=?"
#define IDS_DATABASE_Drop_Downloaded_Cache  @"DROP TABLE IF EXISTS DownloadedCache"
#define IDS_DATABASE_Drop_Downloaded_Cache_Index  @"DROP Index IF EXISTS IDX_DownloadedCache"

#define IDS_DATABASE_Query_Setting @"SELECT Value FROM KeyValue WHERE Key = ?"
#define IDS_DATABASE_CREATE_KeyValue @"create table KeyValue(Key NVARCHAR(200),Value NVARCHAR(200))"
#define IDS_DATABASE_CREATE_KeyValue_Index @"Create Unique Index IDX_KeyValue ON KeyValue(Key ASC)"
#define IDS_DATABASE_Replace_KeyValue @"replace into KeyValue(Key,Value) values(?,?)"

#define IDS_DATABASE_Create_Search_History_Cache @"Create Table SearchHistoryCache(code NVARCHAR(200) ,name NVARCHAR(200),type integer )"
#define IDS_DATABASE_Create_Search_History_Cache_Index @"Create Unique Index IDX_SearchHistoryCache ON SearchHistoryCache (name ASC)"
#define IDS_DATABASE_Replace_Search_History_Cache @" Replace into SearchHistoryCache(code,name,type) values(?,?,?)"
#define SQL_QUERY_SEARCH_HISTORY_CACHE  @"select * from SearchHistoryCache"
#define SQL_CLEAN_SEARCH_HISTORY_CACHE  @"delete from SearchHistoryCache"
#define IDS_DATABASE_Delete_Search_History_Cache  @"delete from SearchHistoryCache where name=?"
#define IDS_DATABASE_Drop_Search_History_Cache  @"DROP TABLE IF EXISTS SearchHistoryCache"
#define IDS_DATABASE_Drop_Search_History_Cache_Index  @"DROP Index IF EXISTS IDX_SearchHistoryCache"



#define IDS_FILES_CACHE_CLEANED @"com.d.cn.files.CacheCleaned"

#pragma mark 接口地址
#define IDS_API_appAchive    @"ArchiveIOSClient.ashx"
#define IDS_API_upgradeApp   @"UpgradeAppList.aspx"
#define IDS_API_upgradeAppByJson   @"UpgradeAppListByJson.ashx"
//应用列表
#define IDS_API_appListByJson   @"applistbyjson.ashx"
#define IDS_API_appDownloadPath @"IphoneDownLoad.ashx"
//排行榜
#define IDS_API_RankListByJson  @"RankListByJson.ashx"
//广告
#define IDS_API_IndexAd            @"IndexAd.ashx"
//应用类别（游戏、软件）
#define IDS_API_CategoryByJson  @"Categorybyjson.ashx"
#define IDS_API_AppInfo         @"AppInfoByJson.ashx"
#define IDS_API_ResultByTagGroupRule @"ResultByTagGroupRule.ashx"
#define IDS_API_AppComment @"Appcommentlistbyjson.ashx"
#define IDS_API_News_NewsListByJson @"NewsListByJson.ashx"
//合辑列表
#define IDS_API_SubjectByJson    @"Subjectbyjson.ashx" 
//合辑详情
#define IDS_API_SubjectDetailbyjson    @"SubjectDetailbyjson.ashx"
//热门关注
#define IDS_API_TagGroupByJson    @"TagGroupByJson.ashx"
#define IDS_API_DownloadAddress  @"Appdownloadlistbyjson.ashx"

#define IDS_API_companyAppsList    @"CompanyAppsByJson.ashx"
#define IDS_API_SendCommentAndRate @"AppGrade.ashx"
#define IDS_API_UserInfo @"UserInfo.ashx"

#define IDS_API_DES_KEY                 @"AA21E22B"

#define IDS_API_LOTTERY_GetStatus       @"GetActStatus.ashx"
#define IDS_API_LOTTERY_AddPlayer       @"PlayerRelate.ashx?type=1"
#define IDS_API_LOTTERY_UploadScore     @"PlayerRelate.ashx?type=2"
#define IDS_API_LOTTERY_GetPlayer       @"PlayerRelate.ashx?type=0"
#define IDS_API_LOTTERY_GetRankList     @"GetRankList.ashx"
#define IDS_API_LOTTERY_DoLottery       @"GetResult.ashx"
#define IDS_API_LOTTERY_GetRankList     @"GetRankList.ashx"
#define IDS_API_LOTTERY_GetPrizeList    @"GetPrizeList.ashx"
#define IDS_API_LOTTERY_PrizeConfirm    @"PrizeComfirm.ashx"
#define IDS_API_LOTTERY_GetInfo         @"GetInfo.ashx"


#define IDS_API_KEY_DeviceGUID          @"DeviceGUID"
#define IDS_API_KEY_Data                @"data"
#define IDS_API_KEY_Status              @"status"
#define IDS_API_KEY_PlayerName          @"PlayerName"
#define IDS_API_KEY_PhoneNo             @"PhoneNo"
#define IDS_API_KEY_QQ                  @"QQ"
#define IDS_API_KEY_Top                 @"top"
#define IDS_API_KEY_Info                @"info"
#define IDS_API_KEY_Score               @"score"
#define IDS_API_KEY_Ranklist            @"ranklist"
#define IDS_API_KEY_Ranno               @"ranno"
#define IDS_API_KEY_Pct                 @"Pct"
#define IDS_API_KEY_LotteryChanceCount  @"LotteryChanceCount"
#define IDS_API_KEY_Prize               @"Prize"
#define IDS_API_KEY_GameScore           @"GameScore"
#define IDS_API_KEY_PlayBeginTime       @"PlayBeginTime"
#define IDS_API_KEY_PlayEndTime         @"PlayEndTime"
#define IDS_API_KEY_PrizeID             @"PrizeID"
#define IDS_API_KEY_PrizeClientID       @"PrizeClientID"
#define IDS_API_KEY_ExchangeCode        @"ExchangeCode"
#define IDS_API_KEY_Partners            @"Partners"
#define IDS_API_KEY_Type                @"type"
#define IDS_API_KEY_GameTime            @"GameTime"


#define IDS_API_STATUS_OK               1


#pragma mark 字符串
#define IDS_xxx                       @""

#define IDS_CATEGORY_QBYY                      @"全部应用"
#define IDS_CATEGORY_SC                           @"收藏"
#define IDS_CATEGORY_HJ                           @"合辑"
#define PROMPT_IS_NOT_NETWORK           @"亲，请检查您的网络～"
#define PROMPT_Loading           @"加载中...."

//用户系统相关接口 登录注册 找回密码 密保等

#define            URL_MEMBER_LOGIN_ASYC        @"open/member/?act=loginv20"

#define            URL_MEMBER_REGISTER_ASYC     @"open/member/?act=register"

#define             URL_FIND_PWD_ONE            @"open/member/?act=quesFindPsw_1"

#define             URL_FIND_PWD_SEND_SMS       @"open/member/?act=sendfindpwdsms"

#define             URL_FIND_PWD_SEND_EMAIL     @"open/member/?act=sendfindpwdemail"

#define             URL_FIND_PWD_TWO            @"open/member/?act=quesFindPsw_2"

#define             URL_RESET_PWD               @"open/member/?act=quesFindPsw_3"


