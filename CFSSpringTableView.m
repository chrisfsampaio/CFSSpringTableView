//
//  SpringTableView.m
//  SpringTableView
//
//  Created by Christian Sampaio on 8/26/13.
//  Copyright (c) 2013 Christian Sampaio. All rights reserved.
//

#import "CFSSpringTableView.h"

@interface CFSSpringTableView()

@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableDictionary *behaviors;
@property (nonatomic, assign) BOOL hasAssignedDamping;
@property (nonatomic, assign) BOOL hasAssignedFrequency;
@property (nonatomic, assign) BOOL hasAssignedResistance;

@end

static CGFloat const kSpringTableViewDefaultDamping = 0.7f;
static CGFloat const kSpringTableViewDefaultFrequency = 0.7f;
static CGFloat const kSpringTableViewDefaultResistance = 0.001f;

@implementation CFSSpringTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    [self.panGestureRecognizer addTarget:self action:@selector(onPan:)];
}

- (void)onPan:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state != UIGestureRecognizerStateBegan)
    {
        CGFloat scrollDelta = self.contentOffset.y - self.lastContentOffset.y;
        CGPoint touchLocation = [panGesture locationInView:self];
        
        for (UIAttachmentBehavior *spring in self.dynamicAnimator.behaviors)
        {
            UIView *currentItem = [spring.items firstObject];
            if ([self.visibleCells containsObject:currentItem])
            {
                CGPoint anchorPoint = spring.anchorPoint;
                CGFloat touchDistance = fabsf(touchLocation.y - anchorPoint.y);
                CGFloat resistanceFactor = self.hasAssignedResistance ? self.springResistance : kSpringTableViewDefaultResistance;
                
                CGPoint center = currentItem.center;
                float resistedScroll = scrollDelta * touchDistance * resistanceFactor;
                float simpleScroll = scrollDelta;
                
                float actualScroll = MIN(abs(simpleScroll), abs(resistedScroll));
                if (simpleScroll < 0)
                {
                    actualScroll = abs(actualScroll);
                }
                
                center.y += actualScroll;
                currentItem.center = center;
                [self.dynamicAnimator updateItemUsingCurrentState:currentItem];
            }
        }
        
        self.lastContentOffset = (CGPoint){self.contentOffset.x, self.contentOffset.y};
    }
}

- (void)prepareCellForShow:(UITableViewCell *)cell
{
    NSNumber *key = @([cell hash]);
    UIAttachmentBehavior *springBehavior = self.behaviors[key];
    if (springBehavior)
    {
        [self.dynamicAnimator removeBehavior:springBehavior];
    }
    springBehavior = [[UIAttachmentBehavior alloc] initWithItem:cell attachedToAnchor:cell.center];
    
    springBehavior.length = 0;
    springBehavior.damping = self.hasAssignedDamping ? self.springDamping : kSpringTableViewDefaultDamping;
    springBehavior.frequency = self.hasAssignedFrequency ? self.springFrequency : kSpringTableViewDefaultFrequency;
    [self.dynamicAnimator addBehavior:springBehavior];
    self.behaviors[key] = springBehavior;
    
    self.lastContentOffset = self.contentOffset;
}

- (void)reloadData
{
    [self.dynamicAnimator removeAllBehaviors];
    [super reloadData];
}

#pragma mark Getters/Setters

- (NSMutableDictionary *)behaviors
{
    if (!_behaviors)
    {
        _behaviors = [NSMutableDictionary dictionary];
    }
    return _behaviors;
}

- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator)
    {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _dynamicAnimator;
}

- (void)setSpringDamping:(CGFloat)springDamping
{
    self.hasAssignedDamping = YES;
    _springDamping = springDamping;
}

- (void)setSpringFrequency:(CGFloat)springFrequency
{
    self.hasAssignedFrequency = YES;
    _springFrequency = springFrequency;
}

- (void)setSpringResistance:(CGFloat)springResistance
{
    self.hasAssignedResistance = YES;
    _springResistance = springResistance;
}

@end
