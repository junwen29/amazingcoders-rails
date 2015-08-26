# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#deal_start_date').datepicker({
	dateFormat: "yy-mm-dd"
	});
	$('#deal_expiry_date').datepicker({
	dateFormat: "yy-mm-dd"
	});

$ ->
  $("#redeemable_true").hide();
  $("input:radio[name ='deal[redeemable]']").change ->
    if(this.value == "true" && this.checked)
      $("#redeemable_true").show();
    else
      $("#redeemable_true").hide();

$ ->
  $("#multiple_use_false").hide();
  $("input:radio[name ='deal[multiple_use]']").change ->
    if(this.value == "once" && this.checked)
      $("#multiple_use_false").show();
    else
      $("#multiple_use_false").hide();

$ ->
  $("#num_of_redeems_others").hide();
  $("input:radio[name ='deal[num_of_redeems]']").change ->
    if(this.value == "others" && this.checked)
      $("#num_of_redeems_others").show();
    else
      $("#num_of_redeems_others").hide();

$ ->
  $('.btn').button('reset');