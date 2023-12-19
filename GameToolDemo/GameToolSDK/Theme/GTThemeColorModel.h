//
//  GTThemeColorModel.h
//  GTSDK
//
//  Created by shangmi on 2023/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTThemeColorModel : NSObject

#pragma mark - 按模块区分
#pragma mark - common

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *headingOneColor;
@property (nonatomic, strong) UIColor *headingTwoColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *unselectedTextColor;

@property (nonatomic, strong) UIColor *bgColor;
//公共视图
@property (nonatomic, strong) UIColor *gtswitch_bg_color;
@property (nonatomic, strong) UIColor *gtswitch_is_on_bg_color;
@property (nonatomic, strong) UIColor *gtswitch_bg_gray_color;
@property (nonatomic, strong) UIColor *gtswitch_is_on_bg_gray_color;
@property (nonatomic, strong) UIColor *gtswitch_item_color;
@property (nonatomic, strong) UIColor *gtswitch_is_on_item_color;
@property (nonatomic, strong) UIColor *clicker_rename_text_color;
#pragma mark - floating ball

@property (nonatomic, strong) UIColor *floating_ball_bg;
@property (nonatomic, strong) UIColor *floating_ball_btn_bg;
@property (nonatomic, strong) UIColor *floating_ball_control_mode_btn_title_color;

#pragma mark - ToolBar

@property (nonatomic, strong) UIColor *tool_bar_selected_btn_color;
@property (nonatomic, strong) UIColor *tool_bar_normal_btn_color;

#pragma mark - SpeedUp

@property (nonatomic, strong) UIColor *speed_up_main_box_bg_color;
@property (nonatomic, strong) UIColor *speed_up_main_box_bottom_bg_color;
@property (nonatomic, strong) UIColor *speed_up_main_mode_bg_color;
@property (nonatomic, strong) UIColor *speed_up_main_mode_btn_color;
@property (nonatomic, strong) UIColor *speed_up_main_control_color;

@property (nonatomic, strong) UIColor *speed_up_set_box_bg_color;
@property (nonatomic, strong) UIColor *speed_up_set_mul_bg_color;

@property (nonatomic, strong) UIColor *speed_up_mul_set_unable_selected_item_bg_color;
@property (nonatomic, strong) UIColor *speed_up_mul_set_able_selected_item_bg_color;
@property (nonatomic, strong) UIColor *speed_up_mul_set_unable_selected_sysbol_bg_color;
@property (nonatomic, strong) UIColor *speed_up_mul_set_able_selected_sysbol_bg_color;
@property (nonatomic, strong) UIColor *speed_up_mul_set_add_item_bg_color;

#pragma mark - Clicker
@property (nonatomic, strong) UIColor *clicker_title_color;
@property (nonatomic, strong) UIColor *clicker_createbutton_color;
@property (nonatomic, strong) UIColor *clicker_pointSetView_bg_color;
@property (nonatomic, strong) UIColor *clicker_text_color;
@property (nonatomic, strong) UIColor *clicker_empty_text_color;
@property (nonatomic, strong) UIColor *clicker_create_button_color;
@property (nonatomic, strong) UIColor *clicker_create_createView_color;

@property (nonatomic, strong) UIColor *clicker_tipshadow_color;
@property (nonatomic, strong) UIColor *clicker_savebutton_color;
@property (nonatomic, strong) UIColor *clicker_pointSetplanbutton_color;
@property (nonatomic, strong) UIColor *clicker_SetView_color;
@property (nonatomic, strong) UIColor *clicker_settipView_color;
@property (nonatomic, strong) UIColor *clicker_pointSetquitbutton_color;
@property (nonatomic, strong) UIColor *clicker_savebutton_text_color;
@property (nonatomic, strong) UIColor *clicker_tipborder_gray_color;
@property (nonatomic, strong) UIColor *clicker_cell_text_color;
@property (nonatomic, strong) UIColor *clicker_cell_start_color;
@property (nonatomic, strong) UIColor *clicker_unselectedTextColor;
@property (nonatomic, strong) UIColor *clicker_selectedTextColor;
@property (nonatomic, strong) UIColor *clicker_pointset_cell_color;
@property (nonatomic, strong) UIColor *clicker_pointset_cellSnapshot_color;
@property (nonatomic, strong) UIColor *clicker_pointset_cellSnapshot_border_color;
@property (nonatomic, strong) UIColor *clicker_tipNewLocationView_black_color;
@property (nonatomic, strong) UIColor *clicker_pausetext_color;

@property (nonatomic, strong) UIColor *clicker_future_start_view_line_color;
@property (nonatomic, strong) UIColor *clicker_placeholder_color;

#pragma mark - Set

@property (nonatomic, strong) UIColor *set_main_box_bg_color;

#pragma mark - Dialog

@property (nonatomic, strong) UIColor *dialog_cancel_btn_title_color;
@property (nonatomic, strong) UIColor *dialog_cancel_btn_bg_color;
@property (nonatomic, strong) UIColor *dialog_title_color;


@end

NS_ASSUME_NONNULL_END
