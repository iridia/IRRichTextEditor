//
//  IRRTEEditorViewController.m
//  IRRichTextEditor
//
//  Created by Evadne Wu on 4/6/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <objc/runtime.h>
#import "IRRTEEditorViewController.h"
#import "IRRTEEditorView.h"


@implementation IRRTEEditorViewController

- (void) loadView {

	self.view = [[IRRTEWebView alloc] initWithFrame:CGRectZero];
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

@end
