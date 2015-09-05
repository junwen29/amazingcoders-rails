function validate()
{       
    //businessName = $('#temp_venue_name').val();

    //if(businessName != ""){

        // retrieve from list and join cuisine, great for, ambience into category_list
        
        // var formCategoryArray = [];
        // $categoryItem = $('.form-category ul li.item');

        // $categoryItem.each(function(i, obj){
        //     currentItem = $(obj).children('div').children('span').text();
        //     formCategoryArray.push(currentItem);
        // });

        // var formCategoryString = formCategoryArray.join();        

        // if ($('#venue_category_list').length > 0)
        //     $('#venue_category_list').val(formCategoryString);
        // else
        //     $('#temp_venue_category_list').val(formCategoryString);


        // venue_hours
        $select_day_time = $('.select-day-time');
        $select_day = $('.select-day');
        $select_time = $('.select-time');
        $form = $('.venueForm');
        var index = 0;
        var text = "";
        

        $select_day_time.each(function(i, select_day_time_obj){
            var started_at = $(select_day_time_obj).children($select_time).children("[name='started']").val();
            var ended_at = $(select_day_time_obj).children($select_time).children("[name='ended']").val();
            
            $(select_day_time_obj).children($select_day).children("li").each(function(i, select_day_item_obj){
                var selected = $(select_day_item_obj).data("selected");
                
                 if(selected == "true"){

                    day = $(select_day_item_obj).data('day');

                    text = "<input type='hidden' data_id='" + index + "' id='venue_hour_day' name='venue_hour[" + index + "][day]' size='30' value='" + day + "' />"
                    $(text).appendTo($form);
                    text = "<input type='hidden' data_id='" + index + "' id='venue_hour_started_at' name='venue_hour[" + index + "][started_at]' size='30' value='" + started_at + "' />"
                    $(text).appendTo($form);
                    text = "<input type='hidden' data_id='" + index + "' id='venue_hour_ended_at' name='venue_hour[" + index + "][ended_at]' size='30' value='" + ended_at + "' />"
                    $(text).appendTo($form);

                    index++;      
                    
                }

            });
        });       

        return true;

    // }
    // else{
    //     $formErrors = $("#flashMessages-js");
    //     $oldAlerts = $(".alert");
        
    //     $oldAlerts.remove();
    //     $formErrors.append( "<div class='alert alert--error'><strong>Error!</strong> Business Name can't be blank</div>" );
    //     $(window).scrollTop(0);
    //     return false;
    // }
}