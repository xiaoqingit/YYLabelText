//
//  ReplaceModel.h
//  YYlabelText
//
//  Created by oprah on 2018/6/6.
//  Copyright © 2018年 oprah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTextLayout.h"

@interface ReplaceModel : NSObject
@property(nonatomic,strong)NSString * showString;
@property(nonatomic,strong)NSMutableAttributedString * contentString;
@property(nonatomic,strong)YYTextLayout * contentLayout;
@end
