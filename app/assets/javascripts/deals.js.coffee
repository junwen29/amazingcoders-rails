# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# The following jQuery helps delete and add forms
$ ->
  # This section register the section to be deleted on click and hides the field.
  # Once user clicks submit the hidden section will be deleted
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    # .closest('p') stands for closest paragraph. p can be swap for div, fieldset depending of needs
    # in this case it will hide the closest paragraph
    $(this).closest('fieldset').hide()
    event.preventDefault()

  # This section add new fields based on the previous set chosen. It sets the time created etc and makes a unique key
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'),'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()


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
  $('.btn').button('reset');