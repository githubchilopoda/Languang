//
//  NewEmpCell.h
//  DTNavigationController
//
//  Created by Pain on 14-11-4.
//  Copyright (c) 2014年 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInterfaceUtil.h"

//每行的高度
#define row_height (51.0)

//头像的高度
#define logo_height (36.0)


#define emp_logo_tag (100)
#define emp_name_tag (101)
#define emp_detail_tag (102)
#define emp_select_tag (103)

//add by shisp 在头像中增加一个子View，保存empId，方便点击头像的时候，可以获取用户的资料
#define emp_id_tag (105)

@class LGOrgCell;

@protocol LGOrgCellProtocol <NSObject>

@optional

/** 点击选择按钮 */
- (void)clickSelectButton:(LGOrgCell *)cell;

@end

@class Emp;
@interface LGOrgCell : UITableViewCell{
    
}

@property (nonatomic,retain) id dataObject;
@property (nonatomic,assign) id<LGOrgCellProtocol> delegate;

/** 根据不同的对象 配置cell */
-(void)configureCellWithObject:(id)_id;



/**
 根据Emp初始化用户头像、名字、职位

 @param emp 包含员工所有信息的对象
 */
-(void)configureCell:(Emp*)emp;

/**
 是否需要显示状态

 @param emp 包含员工所有信息的对象
 @param displayStatus 是否显示
 */
-(void)configureCell:(Emp*)emp andDisplayStatus:(BOOL)displayStatus;

/**
 这是用来显示 通讯录 人员搜索结果的cell

 @param emp 包含员工所有信息的对象
 */
-(void)configureWithDeptCell:(Emp*)emp;

@end