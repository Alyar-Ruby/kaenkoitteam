// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require private_pub
//= require jquery.remotipart
//= require browser_timezone_rails/application
//= require websocket_rails/main

//= require jquery-custom-ui
//= require ckeditor/ckeditor
//= require_tree ./ckeditor
//= require jquery.tagsinput.min
//= require jquery.tokeninput
//= require swfobject
//= require chat
//= require chat_demo
//= require kaneko_new_js/modernizr-2.6.2.min
//= require kaneko_new_js/bo-main-min
//= require kaneko_new_js/custom
//= require kaneko_new_js/jquery.creditCardValidator
//= require kaneko_new_js/bootstrap-slider
//= require jquery.ui.chatbox
//= require autocomplete-rails
//= require intlTelInput 



$(function() {

	$('a[data-remote=true]').bind('ajax:before', function () {
	   $(".ajax-loading").show();
	  
	   $('[rel^=popover]').popover('hide');
	})
	$('form[data-remote=true]').bind('ajax:before', function () {
	   $(".ajax-loading").show()
	})  
});

$(document).ready(function() {
	ahref = ""
	chk_remote = ""
	$.rails.allowAction = function(link) {
		message = link.data("confirm")
		ahref = link.attr('href')
		method = link.data('method')
		method = (method == undefined) ? "GET" : method
		chk_remote = link.data('remote')
		if (!message) {
			return true
		}
		link.attr('data-confirm')
  	$.rails.showConfirmDialog(link)
	}	
	$.rails.confirmed = function(link) {
	  link.trigger('click') 
	}
	$.rails.showConfirmDialog = function(link) {
  message = link.data('confirm')
  html = "" 
  html = '<div id="myModal" class="modal"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h3>Confirm</h3></div><div class="modal-body"><p>'+message+'</p></div><div class="modal-footer"><a href="'+ahref+'" data-remote='+chk_remote+' id="btnYes" data-method="'+method+'" class="btn btn-default-border confirm">Yes</a><a href="#" data-dismiss="modal" aria-hidden="true" class="btn secondary">Cancel</a></div></div></div></div>'
  	$(html).modal('show');
   	$('.confirm').on ('click', function(){
   		$(".modal").modal('hide')
   	})
	}
});

