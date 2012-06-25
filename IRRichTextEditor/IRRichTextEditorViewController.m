//
//  IRRichTextEditorViewController.m
//  IRRichTextEditor
//
//  Created by Evadne Wu on 4/6/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <objc/runtime.h>
#import "IRRichTextEditorViewController.h"
#import "IRRichTextEditorView.h"


@implementation IRRichTextEditorViewController

- (void) loadView {

	if (self.nibName) {
		
		[super loadView];
		
	} else {
		
		self.view = [[IRRichTextEditorView alloc] initWithFrame:CGRectZero];
		
	}
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

@end
