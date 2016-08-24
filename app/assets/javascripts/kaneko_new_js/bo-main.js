//@codekit-prepend "bootstrap.min.js";
//@codekit-prepend "bootstrap-select.min.js";
//@codekit-prepend "slidebars.js";
//@codekit-prepend "freewall.js";
//@codekit-prepend "jquery.cycle2.min.js";
//@codekit-prepend "jquery.slimscroll.min.js";


//@codekit-prepend "idangerous.swiper.js";
var $siteWarper,$menuLeft,$mail,$mailList,$mailRead;
var $notificationSwiper;

jQuery(document).ready(function($) {

	$siteWarper = $('.site-warper');
	$menuLeft = $('.nav-fixed-left');
	// BOOSTRAP INITS 
	$('[data-toggle=tooltip]').tooltip({
		delay : 500,
	});

	$('[data-toggle=popover]').popover({
		delay : { show: 500, hide: 100 }
	});
	$('.selectpicker').selectpicker();
	// END BOOSTRAP INITS
	//CUSTOM RADIO BUTTON INIT
	//$('input[type="radio"]').iCheck({
	//	 radioClass: 'iradio_minimal-grey-white',
	//});
	//ENDCUSTOM RADIO BUTTON INIT


	//MENUS HANDLERS
	$('a.open-menu').on('click',function(e){
		e.preventDefault();
		$('body').toggleClass('menu-left-open');
	})
	// needs work -----------------------\
	$('.close-alerts').on('click',function(e){
		setTimeout(function(){
			viewportAjusts();
		},250);

	});

	$('a.toggle-company').on('click',function(e){
		e.preventDefault();
		$('body').toggleClass('toggle-company-open');
		$(this).next('ul').toggleClass('toggle-company-open');
	})
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		
		$('a.toggle-company span').html($(e.target).text());
		$('.toggle-company-open').toggleClass('toggle-company-open');
	})
	//END MENUS HANDLERS

	/*
	$notificationSwiper = $('.swiper-container').swiper({
		//Your options here:
		mode:'vertical',
		loop: false,
		cssWidthAndHeight:true;
		//etc..
	});
	*/


	//TOP UP
	$stepsDisplay = $('.step-by-step li');

	$('a.next-step').on('click',function(){
		$next = $stepsDisplay.filter('.active').next('li');
		$stepsDisplay.filter('.active').removeClass('active');
		$next.addClass('active');
	})
	$('a.prev-step').on('click',function(){
		$prev = $stepsDisplay.filter('.active').prev('li');
		$stepsDisplay.filter('.active').removeClass('active');
		$prev.addClass('active');
	})
	//END TOP UP


	///MAIL HANDLERS
	$mail = $('section.mail');
	$mailList = $(".mail-list");
	$mailRead = $(".mail-box");
	$goMailList = $('.go-mail-list');

	$(".read-mail").on('click',function(e){
		e.preventDefault();
		
		$elem = $(this);
		$currentMail = $mailList.find('.ticket-active');
		$currentMail.removeClass('ticket-active');
		$elem.find('.ticket').addClass('ticket-active');
		$mail.addClass('reading-mail');

		$mailRead.find('.mail-entry').removeClass('in').css('display','none');
		
		$mailBody = $("#"+$elem.attr('data-id'));
		$mailBody.css('display','block')
		setTimeout(function(){
			$mailBody.addClass('in');
		},350);
		
	})

	$goMailList.on('click',function(e){
		e.preventDefault();

		$mailList.find('.ticket-active').removeClass('ticket-active');
		//$mailRead.find('.mail-entry').removeClass('in').css('display','none');
		$mailBody.removeClass('in');
		setTimeout(function(){
			$mail.removeClass('reading-mail');
		},350);

	})

	var wall = new freewall("#freewall");
    wall.reset({
        selector: '.social-card-disable',
        animate: false,
        cellW: 318,
        cellH: 'auto',
        onResize: function() {
            wall.fitWidth();
        }
    });
    wall.fitWidth();
   
	viewportAjusts();
	
	//$menuLeft.height($siteWarper.height()-10);
	//var mySlidebars = new $.slidebars();



});


$( window ).resize(function() {
	viewportAjusts();
});

function viewportAjusts(){
	
	$menuLeft.height($siteWarper.height()-5);
}

