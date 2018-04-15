//
//  SAMenuDropDown.h
//  MenuDropDown
//
//  Created by Satish K Azad on 30/10/13.
//  Copyright (c) 2013 SADropDown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownTableViewCell.h"


typedef enum {
    
    kSAMenuDropAnimationDirectionTop = 0,
    kSAMenuDropAnimationDirectionBottom,
   // kSAMenuDropAnimationDirectionLeft,
   // kSAMenuDropAnimationDirectionRight
    
}SAMenuDropAnimationDirection;





@protocol SAMenuDropDownDelegate;


@interface SAMenuDropDown : UIView <UITableViewDataSource, UITableViewDelegate>
{
   
}
@property (nonatomic, assign) CGFloat rowHeight;


/*
 Delegate
 */
@property (nonatomic, weak) id <SAMenuDropDownDelegate> delegate;


/*
 Animation Directions.
 Animations in a Specific Directions of SADropDownMenu
 */
@property (nonatomic, assign) SAMenuDropAnimationDirection animationDirection;

@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSString *clickedButtonTitle;



/* Button Reference which creats menu */
@property (nonatomic, strong) UIButton *sourceButton;




/* init methods */
- (id)initWithSource:(UIButton *)sender menuHeight:(CGFloat)height itemName:(NSArray *)nameArray;
- (id)initWithWithSource:(UIButton *)sender menuHeight:(CGFloat)height itemNames:(NSArray *)nameArray  itemImagesName:(NSArray *)imageArray itemSubtitles:(NSArray *)subtitleArray;
- (id)initWithSource:(UIButton *)sender itemNames:(NSArray *)nameArray  itemImagesName:(NSArray *)imageArray itemSubtitles:(NSArray *)subtitleArray;



/* Instance Method to show & hide menu */
- (void)showSADropDownMenuWithAnimation:(SAMenuDropAnimationDirection)animation;
- (void)hideSADropDownMenu;



//Call back Blocks
- (void)menuItemSelectedBlock:(void (^)(SAMenuDropDown *menu, NSInteger index))completion;

// Custom Method

-(void) changeDataSourceToMutableArray:(NSMutableArray *) newDataSource;

@end








/*
 Protocols
 */


@protocol SAMenuDropDownDelegate <NSObject>


@required
- (void)saDropMenu:(SAMenuDropDown *)menuSender didClickedAtIndex:(NSInteger)buttonIndex;
//- (void)saDropMenu:(SAMenuDropDown *)menuSender willClickedAtIndex:(NSInteger)buttonIndex;


@optional
//not implemented yet

@end



