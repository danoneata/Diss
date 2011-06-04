/* generated javascript */
var skin = 'monobook';
var stylepath = '/wiki/skins';

/* MediaWiki:Common.js */
/* Any JavaScript here will be loaded for all users on every page load. */
var button = {
	"imageFile": "/wiki/skins/common/images/button_ref.png", // image to be shown on the button (may be a full URL too), 22x22 pixels
	"speedTip": "reference to a labeled equation or figure", // text shown in a tooltip when hovering the mouse over the button
	"tagOpen": "<ref>", // the text to use to mark the beginning of the block
	"tagClose": "</ref>",      // the text to use to mark the end of the block (if any)
	"sampleText": "label"  // the sample text to place inside the block
};				
mwCustomEditButtons.push(button);

var button = {
	"imageFile": "/wiki/skins/common/images/button_review.png",
	"speedTip": "comments and suggestions to curators",
	"tagOpen": "<review>",
	"tagClose": "</review>",
	"sampleText": "message to curators"
};				
mwCustomEditButtons.push(button);

/* MediaWiki:Monobook.js */
/* Any JavaScript here will be loaded for users using the MonoBook skin */