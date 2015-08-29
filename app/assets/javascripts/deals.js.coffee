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
    if(this.value == "false" && this.checked)
      $("#multiple_use_false").show();
    else
      $("#multiple_use_false").hide();

$ ->
  $("#monday_true").hide();
  $("input:checkbox[name ='deal[monday]']").change ->
    if(this.value == "1" && this.checked)
      $("#monday_true").show();
    else
      $("#monday_true").hide();
$ ->
  $("#tuesday_true").hide();
  $("input:checkbox[name ='deal[tuesday]']").change ->
    if(this.value == "1" && this.checked)
      $("#tuesday_true").show();
    else
      $("#tuesday_true").hide();

$ ->
  $("#wednesday_true").hide();
  $("input:checkbox[name ='deal[wednesday]']").change ->
    if(this.value == "1" && this.checked)
      $("#wednesday_true").show();
    else
      $("#wednesday_true").hide();

$ ->
  $("#thursday_true").hide();
  $("input:checkbox[name ='deal[thursday]']").change ->
    if(this.value == "1" && this.checked)
      $("#thursday_true").show();
    else
      $("#thursday_true").hide();

$ ->
  $("#friday_true").hide();
  $("input:checkbox[name ='deal[friday]']").change ->
    if(this.value == "1" && this.checked)
      $("#friday_true").show();
    else
      $("#friday_true").hide();

$ ->
  $("#saturday_true").hide();
  $("input:checkbox[name ='deal[saturday]']").change ->
    if(this.value == "1" && this.checked)
      $("#saturday_true").show();
    else
      $("#saturday_true").hide();

$ ->
  $("#sunday_true").hide();
  $("input:checkbox[name ='deal[sunday]']").change ->
    if(this.value == "1" && this.checked)
      $("#sunday_true").show();
    else
      $("#sunday_true").hide();
$ ->
  $('.btn').button('reset');