//
//  SpringTableView.h
//  SpringTableView
//
//  Created by Christian Sampaio on 8/26/13.
//  Copyright (c) 2013 Christian Sampaio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This UITableView Subclass makes your table view 
 *  looks like its cells are connected to each other by springs
 *  It uses UIDynamics classes, so you can use only if your project
 *  does NOT support iOS version < 7.0
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface CFSSpringTableView : UITableView

/**
 *  The damping factor to the spring effect on the cells.
 *  From 0 to 1.
 *  Default value is 0.7f.
 */
@property (nonatomic, assign) CGFloat springDamping;

/**
 *  The frequency, in hertz, for the spring effect on the cells.
 *  Default value is 0.7f.
 */
@property (nonatomic, assign) CGFloat springFrequency;

/**
 *  The resistance factor for the spring effect on the cells.
 *  Lower resistance means less flexible springs.
 *  From 0 to 1.
 *  Default value is 0.001f
 */
@property (nonatomic, assign) CGFloat springResistance;

/**
 *  This method must be called when you call 
 *  tableView:willDisplayCell:forRowAtIndexPath: on your table view delegate
 *  It is necessary in order to prepare the cell to behave with the spring effect
 *  and you can still use your delegate as usual
 */
- (void)prepareCellForShow:(UITableViewCell *)cell;

@end
