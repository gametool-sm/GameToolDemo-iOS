//
//  GTThemeTypeDark.m
//  GTSDK
//
//  Created by shangmi on 2023/8/2.
//

#import "GTThemeTypeDark.h"

@implementation GTThemeTypeDark

//获取颜色
- (void)colorWithType {
    GTThemeManager *manager = [GTThemeManager share];
    /**
     common
     */
    manager.colorModel.titleColor = [UIColor hexColor:@"#FFFFFF"];
    manager.colorModel.headingOneColor = [UIColor hexColor:@"#FFFFFF"];
    manager.colorModel.headingTwoColor = [UIColor hexColor:@"#112640"];
    manager.colorModel.textColor = [UIColor hexColor:@"#FFFFFF"];
    manager.colorModel.unselectedTextColor = [UIColor hexColor:@"#FFFFFF" withAlpha:0.4];
    
    manager.colorModel.bgColor = [UIColor hexColor:@"#1C2531"];
    //公共视图
    manager.colorModel.gtswitch_bg_color = [UIColor hexColor:@"#333D48"];
    manager.colorModel.gtswitch_is_on_bg_color = [UIColor hexColor:@"#2E82E5"];
    manager.colorModel.gtswitch_bg_gray_color = [UIColor hexColor:@"#36404D"];
    manager.colorModel.gtswitch_is_on_bg_gray_color = [UIColor hexColor:@"#2E82E5"];
    manager.colorModel.gtswitch_item_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.2];
    manager.colorModel.gtswitch_is_on_item_color = [UIColor hexColor:@"#FFFFFF" withAlpha:1];
    manager.colorModel.clicker_rename_text_color = [UIColor hexColor:@"#FFFFFF"];
    /**
     floating ball
     */
    manager.colorModel.floating_ball_bg = [UIColor hexColor:@"#18212B" withAlpha:1];
    manager.colorModel.floating_ball_btn_bg = [UIColor hexColor:@"#3391FF" withAlpha:0.15];
    manager.colorModel.floating_ball_control_mode_btn_title_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.4];
    /**
     ToolBar
     */
    manager.colorModel.tool_bar_normal_btn_color = [UIColor hexColor:@"#28323E"];
    manager.colorModel.tool_bar_selected_btn_color = [UIColor hexColor:@"#2E82E5"];
    manager.colorModel.floating_ball_control_mode_btn_title_color = [UIColor hexColor:@"#112640" withAlpha:1];
    /**
     SpeedUp
     */
    manager.colorModel.speed_up_main_box_bg_color = [UIColor hexColor:@"#28323E"];
    manager.colorModel.speed_up_main_box_bottom_bg_color = [UIColor hexColor:@"#36404D"];
    manager.colorModel.speed_up_main_mode_bg_color = [UIColor hexColor:@"#28323E"];
    manager.colorModel.speed_up_main_mode_btn_color = [UIColor hexColor:@"#475361"];
    manager.colorModel.speed_up_main_control_color = [UIColor hexColor:@"#475361"];
    
    manager.colorModel.speed_up_set_box_bg_color = [UIColor hexColor:@"#36404D"];
    manager.colorModel.speed_up_set_mul_bg_color = [UIColor hexColor:@"#475361"];
    
    manager.colorModel.speed_up_mul_set_unable_selected_item_bg_color = [UIColor hexColor:@"#28323E"];
    manager.colorModel.speed_up_mul_set_able_selected_item_bg_color = [UIColor hexColor:@"#36404D"];
    manager.colorModel.speed_up_mul_set_unable_selected_sysbol_bg_color = [UIColor hexColor:@"#475361" withAlpha:0.5];
    manager.colorModel.speed_up_mul_set_able_selected_sysbol_bg_color = [UIColor hexColor:@"#475361"];
    manager.colorModel.speed_up_mul_set_add_item_bg_color = [UIColor hexColor:@"#3391FF" withAlpha:0.2];
    /**
     Clicker
     */
    manager.colorModel.clicker_title_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.9];
    manager.colorModel.clicker_createbutton_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.9];
    manager.colorModel.clicker_pointSetView_bg_color = [UIColor hexColor:@"#1C2531"];
    manager.colorModel.clicker_text_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    manager.colorModel.clicker_empty_text_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    manager.colorModel.clicker_create_button_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.1];
    manager.colorModel.clicker_create_createView_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.1];
    manager.colorModel.clicker_pausetext_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    manager.colorModel.clicker_savebutton_color = [UIColor hexColor:@"FFFFFF" withAlpha:0.4];
    manager.colorModel.clicker_pointSetplanbutton_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    manager.colorModel.clicker_selectedTextColor = [UIColor hexColor:@"#3391FF"];
    manager.colorModel.clicker_SetView_color = [UIColor hexColor:@"#28323E"];
    manager.colorModel.clicker_settipView_color = [UIColor hexColor:@"#4B535D"];
    manager.colorModel.clicker_tipshadow_color = [UIColor hexColor:@"#1C2531"];
    manager.colorModel.clicker_tipborder_gray_color = [UIColor hexColor:@"#4B535D"];
    manager.colorModel.clicker_pointSetquitbutton_color = [UIColor hexColor:@"FFFFFF" withAlpha:0.1];
    manager.colorModel.clicker_savebutton_text_color = [UIColor hexColor:@"#FFFFFF" withAlpha: 0.5];
    manager.colorModel.clicker_unselectedTextColor = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    manager.colorModel.clicker_cell_text_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.8];
    manager.colorModel.clicker_cell_start_color = [UIColor hexColor:@"#2E82E5"];
    manager.colorModel.clicker_pointset_cell_color = [UIColor hexColor:@"#28323E"];
    manager.colorModel.clicker_pointset_cellSnapshot_color = [UIColor hexColor:@"#36404D"];
    manager.colorModel.clicker_pointset_cellSnapshot_border_color = [UIColor hexColor:@"#36404D"];
    
    manager.colorModel.clicker_future_start_view_line_color = [UIColor hexColor:@"#F0F0F0" withAlpha:0.1];
    manager.colorModel.clicker_placeholder_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    /**
     Set
     */
    manager.colorModel.set_main_box_bg_color = [UIColor hexColor:@"#28323E"];
    /**
     Dialog
     */
    manager.colorModel.dialog_cancel_btn_title_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.5];
    manager.colorModel.dialog_cancel_btn_bg_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.1];
    manager.colorModel.dialog_title_color = [UIColor hexColor:@"#FFFFFF" withAlpha:0.9];
}

//获取图片
- (UIImage *)imageWithName:(NSString *)imageName {
    return [self imageWithName:imageName themeType:@"Dark"];
}

//获取json文件
- (NSString *)jsonWithName:(NSString *)jsonName {
    NSString *jsonPath = nil;
    
    switch ([GTOperationControl shareInstance].gtSDKStyle)
        case GTSDKStyleDefault: {
            jsonPath = [self.bundle pathForResource:jsonName ofType:@"json" inDirectory:@"json/Dark/Default"];
            break;
        case GTSDKStyleCustomFloatingBall:
            jsonPath = [self.bundle pathForResource:jsonName ofType:@"json" inDirectory:@"json/Dark/CustomFloatingBall"];
            break;
        default:
            break;
        }
    if(!jsonPath){
        jsonPath = [self.bundle pathForResource:jsonName ofType:@"json" inDirectory:@"json/Dark"];
    }
    return jsonPath;
    //    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //    if (jsonData == nil) {
    //        jsonString = [NSString stringWithFormat:@"json/Dark/%@", jsonName];
    //    }
    //    return jsonString;
}

@end
