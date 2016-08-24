/* start custom scripts */


jQuery(document).ready(function($) {

// ADD SLIDEDOWN ANIMATION TO DROPDOWN //
  $('.dropdown').on('show.bs.dropdown', function(e){
  $(this).find('.dropdown-menu').first().stop(true, true).fadeIn();
   });

   // ADD SLIDEUP ANIMATION TO DROPDOWN //
   $('.dropdown').on('hide.bs.dropdown', function(e){
    $(this).find('.dropdown-menu').first().stop(true, true).fadeOut();
     });

});

$(function(){

    
});

function messages()
{
  
    $.ajax({
    url: "/messages/popup_messages",
    cache: false,
    success: function(data) {
      $('#message_popover').html(data)
      $.ajax({
      url: "/messages/total_messages",
      cache: false,
      success: function(data) {
        if(data > 0) {
          $("#message_popover_title").html("Inbox <b>("+data+")</b><a class=\"pull-right\" href=\"\/messages\/new\" id=\"new_message_link\">New Message<\/a>")  
        }else {
          $("#message_popover_title").html("Inbox <a class=\"pull-right\" href=\"\/messages\/new\" id=\"new_message_link\">New Message<\/a>")
        }
      }
    });   
      return data
    }
  }); 
     
  return $('.messagesnotif2').html();
}

function notifications()
{
  return $('.messagesnotif2').html();
}

var tmp = $.fn.popover.Constructor.prototype.show;
$.fn.popover.Constructor.prototype.show = function () {
  tmp.call(this);
  if (this.options.callback) {
    this.options.callback();
  }
}

function slimmer()
{
    $('.popover-content').slimScroll({
        height: '250px'
    });
    $('.popover-content').css('padding-bottom',0);
}

$(function(){
    $('[class^=messagenotif]').slimScroll({
        height: '250px'
    });
    $("[rel=popovermsg]").popover({ callback: slimmer ,animation:true,
         placement: 'bottom', title: 'Inbox <b>()</b>', content: messages, html: true,
    template: '<div class="popover"><div class="arrow"></div><h3 class="popover-title" id="message_popover_title"></h3><div class="popover-content" id="message_popover"></div><div class="popover-footer text-center"><a href="/messages" data-remote = "true">See All</a></div></div>' });

    $("[rel=popovernotif]").popover({ callback: slimmer ,animation:true,
     placement: 'bottom', title: 'Notifications <b>()</b>', content: notifications, html: true,
    template: '<div class="popover"><div class="arrow"></div><h3 class="popover-title" id="notification_popover_title"></h3><div class="popover-content" id="notificationpopover"></div><div class="popover-footer text-center"><a href="/kaenko_notifications/delete_notification" data-remote="true" data-confirm="Are you sure you want to clear all your old notifications?">Clear All</a></div></div>' })
 //Allow only one popover to be opened at the time
    messages()
   $('[rel^=popover]').click(function(){
      $('[rel^=popover]').not(this).popover('hide');
      get_notifications()
    });
});

$('.dropdown-menu').on('click', function(e) {
    if($(this).hasClass('dropdown-menu-form')) {
        e.stopPropagation();
    }
});

function get_notifications()
{  
  $.ajax({
    url: "/kaenko_notifications/",
    cache: false,
    success: function(data) {
      $('#notificationpopover').html(data)
      $.ajax({
        url: " /kaenko_notifications/notification_check",
        cache: false,
        success: function(data) {
          $("#notify_circle_size").hide();
          $.ajax({
            url: "/kaenko_notifications/total_notification",
            cache: false,
            success: function(data) {
              if(data > 0) {
                $("#notification_popover_title").html("Notifications <b>("+data+")</b>")  
              }else {
                $("#notification_popover_title").html("Notifications")
              }
            }
          
        })
      }
    });
  
  }
})
}
/* end custom scripts */
