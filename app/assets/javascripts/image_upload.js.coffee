#= require bootstrap/tooltip

jQuery ->

  new App.ImageUpload(".image_upload").enhance()

class App.ImageUpload

  constructor: (wrapper) ->
    @wrapper = $(wrapper)

    $elements = @wrapper.children()
    @file = new @FileUpload($elements.slice(0, 2))
    @url  = new @UrlUpload($elements.slice(2, 4))

  enhance: ->
    @preview = new @ImagePreview(@wrapper.find(".image-preview"))

    if @url.isActive() then @file.toggle() else @url.toggle()

    $(".toggle-type")
      .tooltip()
      .on "click", (event) =>
        event.preventDefault()
        @switchType()

    @file.onUpdate (input) => @preview.update(input)
    @url.onUpdate  (input) => @preview.update(input)

  switchType: ->
    @file.toggle()
    @url.toggle()
    @preview.reset()

  FileUpload: class

    constructor: (@fields) ->
      @fields.filter("label").before @toggleButton()
      @fields = @fields.add @fields.filter("label").prev()

    toggle: ->
      @fields.toggle()
        .filter("input").val("")

    onUpdate: (callback) ->
      @fields.filter("input").on "change", (event) =>
        callback(event.target)

    toggleButton: ->
      $ "<a>",
        href: "#"
        class: "btn btn-default toggle-type"
        title: "Na računalu"
        html: $.icon("storage")

  UrlUpload: class

    constructor: (@fields) ->
      @fields.filter("label").before @toggleButton()
      @fields = @fields.add @fields.filter("label").prev()

    toggle: ->
      @fields.toggle()
        .filter("input").val("")

    onUpdate: (callback) ->
      @fields.filter("input").on "keyup change", (event) =>
        callback(event.target)

    isActive: ->
      @fields.filter("input").val() != ""

    toggleButton: ->
      $ "<a>",
        href: "#"
        class: "btn btn-default toggle-type"
        title: "Na internetu"
        html: $.icon("link")

  ImagePreview: class

    constructor: (value) ->
      @value = $(value)
      @originalUrl = @value.attr("src")
      @value.hide() unless @originalUrl

    update: (input) ->
      @reset() if not input.value

      switch input.type
        when "file" then @updateFromFile(input)
        when "url"  then @updateFromUrl(input)

    updateFromFile: (input) ->
      reader = new FileReader
      reader.onload = (event) =>
        url = event.target.result
        @set url
      reader.readAsDataURL input.files[0]

    updateFromUrl: (input) ->
      url = input.value
      @set url

    reset: ->
      @set @originalUrl

    set: (url) ->
      @value.attr("src", url)
      if url then @value.show() else @value.hide()
