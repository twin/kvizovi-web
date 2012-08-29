Lektire.Initializers.games = ->

  # new

  $form     = $('form.new_submitted_game')
  $quizzes  = $form.find '.quizzes'
  $players  = $form.find '.players'
  $login    = $form.find '.login'
  $controls = $form.find '.controls'

  $players.hide()
  $login.hide()
  $controls.hide()

  $quizzes.one 'click', ':radio', ->
    $players.show()
    $controls.show()

  $players.on 'click', ':radio', ->
    switch $(@).val()
      when '1' then $login.hide()
      when '2' then $login.show()

  # edit

  conversion = (el) ->
    result = el.clone()
    result.find('input').each -> $(@).replaceWith($(@).val())
    el.after(result)
    el.hide()
    result

  $form             = $('form.game')

  $static           = {}
  $interactive      = {}

  $static.old       = $form.find('.static')
  $static.new       = conversion($static.old)

  $interactive.old  = $form.find('.interactive')
  $interactive.new  = conversion($interactive.old)

  $interactive.new.sortable
    placeholder: 'placeholder'
    forcePlaceholderSize: true
    tolerance: 'pointer'
    update: ->
      $old = $interactive.old.find 'input'
      $new = $interactive.new.find 'li'

      $old.each (i) -> $(@).val $new.eq(i).text()