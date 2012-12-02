jQuery.noConflict();

//Window onload
window.onload = function () {
	//Dragabble Effects
	new Draggable('submitReport', { revert: true });
	new Draggable('title', { revert: true });
	new Draggable('login', { revert: true });
	jQuery('#submitReport').hover(function(){ jQuery(this).fadeTo(100, 0.5); },function(){ jQuery(this).fadeTo(200, 1.0); });
	jQuery('#login').hover(function(){ jQuery(this).fadeTo(100, 0.5); },function(){ jQuery(this).fadeTo(200, 1.0); });
	jQuery('#title').hover(function(){ jQuery(this).fadeTo(60, 0.9); },function(){ jQuery(this).fadeTo(100, 1.0); });
}