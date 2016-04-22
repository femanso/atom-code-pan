PanningElement = require './panning-element.js'
{CompositeDisposable} = require 'atom'

module.exports = Panning =
  #panningView: null
  enabled: false
  mouseIsDown: false
  keysAreDown: false
  subscriptions: null
  pane: null

  activate: (state) ->

    if @enabled
      return

    console.log @PanningElement

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'panning:toggle': => @toggle()
    #@subscriptions.add atom.commands.add 'atom-workspace', 'panning:go': => @go()


  deactivate: ->
    @subscriptions.dispose()

  setMouseCursor: ->
    @pane = atom.workspace.getActiveTextEditor()
    el = @pane.getElement()
    view = el.getElementsByClassName('scroll-view')
    view[0].style.cursor = 'all-scroll'

  unsetMouseCursor: ->
    @pane = atom.workspace.getActiveTextEditor()
    el = @pane.getElement()
    view = el.getElementsByClassName('scroll-view')
    view[0].style.cursor = null

  toggle: ->
    console.log 'Enabled ' + @enabled

    if @enabled == true
      @enabled = false
      @unsetMouseCursor()
      atom.workspace.notificationManager.addError("Panning Disabled")
      parent.removeEventListener 'mousemove', @move
      parent.removeEventListener 'mousedown', @mouseDown
      parent.removeEventListener 'mouseup', @mouseUp

    else
      @enabled = true
      @setMouseCursor()
      atom.workspace.notificationManager.addSuccess("Panning Enabled")
      parent.addEventListener 'mousemove', @move
      parent.addEventListener 'mousedown', @mouseDown
      parent.addEventListener 'mouseup', @mouseUp

  mouseDown: ->
    console.log 'apertou'
    @mouseIsDown = true;

  mouseUp: ->
    console.log 'soltou' + @pane + 'teste'
    @mouseIsDown = false;

  keyDown: (e) ->
    switch e.keyCode
      when 37 then console.log 'left'
      when 38 then console.log 'up'
      when 39 then console.log 'right'
      when 40 then console.log 'down'

  move: (e) ->
    e.stopPropagation();
    e.preventDefault();
    e.stopImmediatePropagation();

    if @mouseIsDown
      pane = atom.workspace.getActiveTextEditor()

      smooth = 1
      xmove = e.pageX - @lastLeft
      pane.setScrollLeft(pane.getScrollLeft()-xmove) #if xmove > smooth
      #pane.setScrollLeft(pane.getScrollLeft()-xmove) if xmove < -smooth
      @lastLeft = e.pageX

      ymove = e.pageY - @lastTop
      pane.setScrollTop(pane.getScrollTop()-ymove)# if ymove > smooth
      #pane.setScrollTop(pane.getScrollTop()-ymove) if ymove < -smooth
      @lastTop = e.pageY

      console.log 'y scroll:'+pane.getScrollTop()# - pane.getElement().left
      console.log 'y local:'+parent.pane# - pane.getElement().left
      console.log 'y:'+@pane# - pane.getElement().top
      #setScrollBottom(teste.getScrollBottom()+1)
      #console.log pane.getScrollBottom()
    else
      @lastLeft = e.pageX
      @lastTop = e.pageY
