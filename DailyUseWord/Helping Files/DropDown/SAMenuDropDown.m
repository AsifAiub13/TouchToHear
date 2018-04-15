//
//  SAMenuDropDown.m
//  MenuDropDown
//
//  Created by Satish K Azad on 30/10/13.
//  Copyright (c) 2013 SADropDown. All rights reserved.
//

#import "SAMenuDropDown.h"

#define kSAImageFromBundle(imgName)                   [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath]\
stringByAppendingPathComponent:imgName]]

#define kSACellHeight                                44.0


@interface MenuItemData : NSObject

@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *itemNameSubtitle;
@property (nonatomic, retain) NSString *itemImage;
@end

@implementation MenuItemData
@synthesize itemName = _itemName;
@synthesize itemNameSubtitle = _itemNameSubtitle;
@synthesize itemImage = _itemImage;

@end

@interface SAMenuDropDown ()

@property (nonatomic, assign) BOOL isMenuExpanded;

/* TableView */
@property (nonatomic, strong) UITableView *tableMenu;

/* DataSource for Menu Items.
 Contains Menu Item name, Image, subtitle.
 Contains Objects of Type MenuItemData
 */
@property (nonatomic, strong) NSMutableArray *menuDataSource;

/* Menu Height */
@property (nonatomic, assign) CGFloat menuHeight;

//Completion block
@property (nonatomic, copy) void (^completionBlock)(SAMenuDropDown *menu, NSInteger index);

/* calculate frame for Menu */
- (CGRect)calculateMenuViewFrameForAnimationDirection:(SAMenuDropAnimationDirection)animation;

@end

@implementation SAMenuDropDown
@synthesize delegate = _delegate;
@synthesize animationDirection = _animationDirection;
@synthesize tableMenu = _tableMenu;
@synthesize sourceButton = _sourceButton;
@synthesize menuDataSource = _menuDataSource;
@synthesize menuHeight = _menuHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _rowHeight = 0.0;
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

/* Override init */
//Base Init
- (id)initWithSource:(UIButton *)sender menuHeight:(CGFloat)height itemName:(NSArray *)nameArray
{
    self = [self initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y+sender.frame.size.height, sender.frame.size.width, 0)];
    
    if(self) {
        //Custom init
        _animationDirection = kSAMenuDropAnimationDirectionBottom;
        _sourceButton = sender;
        _menuHeight = height;
        _isMenuExpanded = NO;
        [self setUpItemDataSourceWithNames:nameArray subtitles:nil imageNames:nil];
        
        
        [self uiSetUp];
    }
    
    return self;
}

- (id)initWithWithSource:(UIButton *)sender menuHeight:(CGFloat)height itemNames:(NSArray *)nameArray  itemImagesName:(NSArray *)imageArray itemSubtitles:(NSArray *)subtitleArray
{
    self = [self initWithSource:sender menuHeight:height itemName:nameArray];
    
    if(self) {
        //Custom init
        [self setUpItemDataSourceWithNames:nameArray subtitles:subtitleArray imageNames:imageArray];
    }
    
    return self;
}

- (id)initWithSource:(UIButton *)sender itemNames:(NSArray *)nameArray itemImagesName:(NSArray *)imageArray itemSubtitles:(NSArray *)subtitleArray
{
    self = [self initWithWithSource:sender menuHeight:(kSACellHeight*nameArray.count)
                          itemNames:nameArray itemImagesName:imageArray itemSubtitles:subtitleArray];
    if (self) {
        //Custom init
    }
    
    return self;
}

#pragma mark - Setup dataSource
- (void)setUpItemDataSourceWithNames:(NSArray *)nameArr subtitles:(NSArray *)subtitleArr  imageNames:(NSArray *)imageArr
{
    NSInteger n     = nameArr.count;
    NSInteger s     = subtitleArr .count;
    NSInteger img   = imageArr.count;
    
    NSInteger totalCount = MAX(MAX(n, s), img);
    
    if(_menuDataSource != nil) {
        [_menuDataSource removeAllObjects];
        _menuDataSource = nil;
    }
    
    _menuDataSource = [[NSMutableArray alloc] initWithCapacity:totalCount];
    
    @try {
        
        for (int i=0 ; i < totalCount; i++) {
            
            MenuItemData *item = [[MenuItemData alloc] init];
            
            if(i <= n) {
                item.itemName = [nameArr objectAtIndex:i];
            }
            else {
                item.itemName = nil;
            }
            
            if(i <= s) {
                item.itemNameSubtitle = [subtitleArr objectAtIndex:i];
            }
            else {
                item.itemNameSubtitle = nil;
            }
            
            if(i <= img) {
                item.itemImage = [imageArr objectAtIndex:i];
            }
            else {
                item.itemImage = nil;
            }
            
            [_menuDataSource addObject:item];
            
            item = nil;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exceoption Occured...  %@", exception.description);
        
        if([exception.name isEqualToString:NSRangeException]) {
            //handle Range Exception
        }
    }
    @finally {
        //handle it finally
    }
}

- (void)uiSetUp
{
    _tableMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _sourceButton.frame.size.width, 0)];
    _tableMenu.dataSource = self;
    _tableMenu.delegate = self;
    _tableMenu.backgroundColor = [UIColor clearColor];
    _tableMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableMenu.separatorColor = [UIColor clearColor];
    
    _tableMenu.frame = CGRectMake(0, 0, _sourceButton.frame.size.width, 0);
    
    [_sourceButton.superview addSubview:self];
    
    [self addSubview:_tableMenu];
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Show and Hide SAMenuDrop
- (void)showSADropDownMenuWithAnimation:(SAMenuDropAnimationDirection)animation
{
    if (_isMenuExpanded) {
        [self hideSADropDownMenu];
        return;
    }
    self.numberOfRows = _menuDataSource.count;
    [UIView animateWithDuration:0.5
                     animations:^{
                         //Animate
                         CGRect vFrame = [self calculateMenuViewFrameForAnimationDirection:animation];
                         self.frame = vFrame;
                         _tableMenu.frame = CGRectMake(0, 0, _sourceButton.frame.size.width, _menuHeight);
                     } completion:^(BOOL finished) {
                         //Finished
                         [_tableMenu reloadData];
                         
                         _isMenuExpanded = YES;
                     }];
}

- (void)hideSADropDownMenu
{
    [UIView animateWithDuration:0.20
                     animations:^{
                         //Animate
                         CGRect vFrame = self.frame;
                         self.frame = CGRectMake(vFrame.origin.x, vFrame.origin.y, vFrame.size.width, 0);
                         _tableMenu.frame = CGRectMake(0, 0, vFrame.size.width, 0);
                         
                     } completion:^(BOOL finished) {
                         //Finished
                         //  [_tableMenu reloadData];
                         
                         _isMenuExpanded = NO;
                     }];
}

- (CGRect)calculateMenuViewFrameForAnimationDirection:(SAMenuDropAnimationDirection)animation
{
    CGRect menuFrame = CGRectZero;
    
    CGFloat xPos = 0, yPos = 0, width = 0, height = 0;
    
    switch (animation) {
        case kSAMenuDropAnimationDirectionBottom:
        {
            xPos = _sourceButton.frame.origin.x;
            yPos = (_sourceButton.frame.origin.y + _sourceButton.frame.size.height)-4;
            width = _sourceButton.frame.size.width;
            height = _menuHeight;
            
        }
            break;
            
        case kSAMenuDropAnimationDirectionTop:
        {
            xPos = _sourceButton.frame.origin.x;
            yPos = (_sourceButton.frame.origin.y - _menuHeight) - 5;
            width = _sourceButton.frame.size.width;
            height = _menuHeight;
        }
            break;
            
            /*
             case kSAMenuDropAnimationDirectionLeft:
             {
             //not implemented Yet
             }
             break;
             
             case kSAMenuDropAnimationDirectionRight:
             {
             //not implemented yet
             }
             break;
             */
            
        default:
            break;
    }
    menuFrame = CGRectMake(xPos, yPos+5, width, height);
    
    return menuFrame;
}

#pragma mark - Table View DataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (_rowHeight > 0.0) ? _rowHeight : kSACellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableIdentifier = @"dropdown_cell";
    
    DropdownTableViewCell *cell = (DropdownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DropdownTableViewCell" bundle:nil] forCellReuseIdentifier:TableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    }
    
    MenuItemData *itemData = (MenuItemData *)[_menuDataSource objectAtIndex:indexPath.row];
    cell.lblDropdownText.text = itemData.itemName;

    
    if (indexPath.row == 0) {
        cell.lblDropdownText.textColor = [UIColor colorWithRed:54/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    else{
        cell.lblDropdownText.textColor = [UIColor whiteColor];
    }
    
    if(itemData.itemImage != nil)
        cell.imageView.image = [UIImage imageNamed:itemData.itemImage];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TableView delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Call Delegate
    if([_delegate respondsToSelector:@selector(saDropMenu:didClickedAtIndex:)]) {
        MenuItemData *itemData = (MenuItemData *)[_menuDataSource objectAtIndex:indexPath.row];
        self.clickedButtonTitle = itemData.itemName;
        [_delegate saDropMenu:self didClickedAtIndex:indexPath.row];
    }
    
    //Call Block if any
    if (_completionBlock) {
        _completionBlock(self, indexPath.row);
    }
    
    //Hide Menu
    [self hideSADropDownMenu];
    
    //Set New title to Button
    //    MenuItemData *item = _menuDataSource[indexPath.row];
    //    NSString *rowTitle = item.itemName;
    //    [self.sourceButton setTitle:rowTitle forState:UIControlStateNormal];
    
}

- (void)menuItemSelectedBlock:(void (^)(SAMenuDropDown *, NSInteger))completion {
    _completionBlock = completion;
}

#pragma mark - Custom Methods

-(void) changeDataSourceToMutableArray:(NSMutableArray *) newDataSource
{
    
    [self setUpItemDataSourceWithNames:newDataSource subtitles:nil imageNames:nil];
    
    [_tableMenu reloadData];
}

@end


