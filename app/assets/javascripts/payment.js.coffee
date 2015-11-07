# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->

# calendar to pick date
  $('#payment_start_date').datepicker({
    minDate: 0,
    dateFormat: "yy-mm-dd"
  });

  $ ->
  $("#plan1_true").hide();
  $("input:radio[name ='payment[plan1]']").change ->
    if(this.value == "true" && this.checked)
      $("#plan1_true").show();
    else
      $("#plan1_true").hide();

