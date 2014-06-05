//
//  MMXNavigationController.h
//  MathMatch
//
//  Created by Kyle O'Brien on 2014.1.21.
//  Copyright (c) 2014 Computer Lab. All rights reserved.
//

@interface MMXNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
