ready = ->
  $('a#add-property').click ->
    clone = $('.property').last().clone()

    $('.properties').append(clone)

    clone.find('input').val('')

  $('.property .close').click ->
    $(this).parent('.property').remove()

$(document).ready ready
$(document).on 'page:load', ready
