(function($){
 
    $.fn.extend({ 
         
        leanModal: function(options) {
 
          var defaults = {
              overlay: 0.7,
              top: 5,
              closeButton: '.close'
          };

          //var overlay = $('<div id="lean_overlay"></div>');
          var overlay = $('#leanOverlayBg');
          var overlayContent = $('#leanOverlayContent');
          
          var leftMargin = $(window).width()/2;

          //$("body").append(overlay);

          options =  $.extend(defaults, options);

          var o = options, modal_id = $(this);

          overlayContent.click(function() {
               close_modal(modal_id);
          });
          
          $(modal_id).click(function(event){
              event.stopPropagation();
          });

          $(o.closeButton).click(function() {
               close_modal(modal_id);
          });

          var modal_height = $(modal_id).outerHeight(),
              modal_width = $(modal_id).outerWidth();

          $('body, html').css('overflow', 'hidden');
          overlay.fadeTo(300,o.overlay);
          overlayContent.show();

          $(modal_id).css({
              'position' : 'static',
              'z-index': 1001,
              //'left' : 50 + '%',
              //'margin-left' : - (modal_width / 2),
              'margin-left' : (leftMargin - (modal_width / 2)),
              'margin-top' : o.top + '%',
              'margin-bottom' : '30px',
          });
          
          window.scrollTo(0, 0);
          $(modal_id).fadeTo(200,1);
          
          $(window).resize(function() {
              if($(modal_id).is(':visible')){
                  var newTopMargin = $(window).height()/10;
                  var newLeftMargin = $(window).width()/2;
                 
                  $(modal_id).css({
                      'margin-top' : newTopMargin + 'px',
                      'margin-left' : (newLeftMargin - (modal_width / 2)),
                  });   
              }       
          });
          
          function close_modal(modal_id){
              overlay.fadeOut(400);
              overlayContent.fadeOut(200);
              $(modal_id).fadeOut(200);
              $('body, html').css('overflow', 'auto');
          }
    
        }
    });
     
})(jQuery);



