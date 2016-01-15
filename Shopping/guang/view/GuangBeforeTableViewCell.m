//
//  GuangBeforeTableViewCell.m
//  Shopping
//
//  Created by qianfeng on 15/1/14.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "GuangBeforeTableViewCell.h"
#import "GuangAllModle.h"
#import "UIImageView+WebCache.h"

@implementation GuangBeforeTableViewCell

- (void)awakeFromNib {

}


- (IBAction)btnShopping:(UIButton *)sender {
    
    DJLog(@"去购买");
    
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    GuangBeforeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell"];
    if (cell == nil) {
        cell = [[GuangBeforeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    }
        return cell;
}
-(void)setModel:(GuangAllModle *)model
{
    _model = model;
    
    NSString * str = [model.imgs componentsSeparatedByString:@"[\""].lastObject;
    NSString * last = [str componentsSeparatedByString:@"\"]"].firstObject;

    [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic12.secooimg.com/%@",last]] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.labelTitle.text = model.title;
    [self.btnLove setTitle:[NSString stringWithFormat:@"%d",model.praiseCount.intValue] forState:UIControlStateNormal];
    [self.btnLove setTitle:[NSString stringWithFormat:@"%d",model.praiseCount.intValue + 1] forState:UIControlStateDisabled];
    [self.btnLove setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];

    [self.btnCollection setTitle:[NSString stringWithFormat:@"%d",model.favoriteCount.intValue] forState:UIControlStateNormal];
    [self.btnCollection setTitle:[NSString stringWithFormat:@"%d",model.favoriteCount.intValue + 1] forState:UIControlStateDisabled];
    [self.btnCollection setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    
    [self.btnImageAge setTitle:[NSString stringWithFormat:@"%@张",model.isShow] forState:UIControlStateNormal];
}
- (IBAction)LoveBtn:(UIButton *)sender {
    
    DJLog(@"赞一个");
//    self.btnLove.enabled = NO;
    
}
- (IBAction)colltion:(UIButton *)sender {
//    self.btnCollection.enabled = NO;
    DJLog(@"收藏");
}
@end
