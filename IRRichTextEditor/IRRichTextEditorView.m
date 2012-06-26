//
//  IRRichTextEditorView.m
//  IRRichTextEditor
//
//  Created by Evadne Wu on 6/26/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRRichTextEditorView.h"
#import "IRRichTextEditorDocumentView.h"

@interface IRRichTextEditorView ()

@property (nonatomic, readwrite, strong) IRRichTextEditorDocumentView *documentView;

- (void) commonInit;

@end

@implementation IRRichTextEditorView
@synthesize documentView = _documentView;

- (id) initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (!self)
		return nil;
	
	[self commonInit];
	
	return self;
	
}

- (void) awakeFromNib {

	[self commonInit];

}

- (void) commonInit {

	[self addSubview:self.documentView];

}

- (IRRichTextEditorDocumentView *) documentView {

	if (!_documentView) {
	
		_documentView = [[IRRichTextEditorDocumentView alloc] initWithFrame:self.bounds];
		_documentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	}
	
	return _documentView;

}

@end
