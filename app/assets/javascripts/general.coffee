$ = jQuery

App.general = ->

  # closing flash messages

  $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')

  # bootstrap tooltips

  $('.item_controls a, button').tooltip()
  $('a.tour').tooltip
    placement: 'left'

  # delete confirmation

  $('.item_controls').find('.delete').fancybox
    wrapCSS:  'confirm'
    width:    250
    type:     'ajax'
