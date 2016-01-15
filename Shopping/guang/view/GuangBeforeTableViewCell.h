//
//  GuangBeforeTableViewCell.h
//  Shopping
//
//  Created by qianfeng on 15/1/14.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuangAllModle;

@interface GuangBeforeTableViewCell : UITableViewCell
/**  背景图  */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
/**  标题  */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/**  购买点击事件  */
- (IBAction)btnShopping:(UIButton *)sender;
/**  赞  */
@property (weak, nonatomic) IBOutlet UIButton *btnLove;
/**  收藏  */
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
/**  图片张数  */
@property (weak, nonatomic) IBOutlet UIButton *btnImageAge;

@property(strong , nonatomic) GuangAllModle * model;

@property(nonatomic,assign) BOOL isCollection;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
