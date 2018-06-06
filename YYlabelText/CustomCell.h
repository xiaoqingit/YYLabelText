//
//  CustomCell.h
//  YYlabelText
//
//  Created by oprah on 2018/6/6.
//  Copyright © 2018年 oprah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
#import "ReplaceModel.h"

@interface CustomCell : UITableViewCell

@property(nonatomic,strong)ReplaceModel * model;
@property(nonatomic,strong)YYLabel * showLabel;
@end
