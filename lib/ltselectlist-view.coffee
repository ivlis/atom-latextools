{SelectListView} = require 'atom-space-pen-views'

module.exports =
class LTSelectListView extends SelectListView
  callback: null

  initialize: ->
    super
    @addClass('overlay from-top')
    @panel = atom.workspace.addModalPanel(item: this)
    @panel.hide()

  viewForItem: (item) ->
    "<li>#{item.id} #{item.tag} page #{item.page}</li>"

  getFilterKey: ->
    'id'

  confirmed: (item) ->
    @selected_item = item
    @restoreFocus()
    @panel.hide()
    @callback(item.id)

  # API unclear: cancel or cancelled?
  cancel: ->
    super
    @restoreFocus()
    @panel.hide()

  start: (@callback) ->
    @selected_item = null
    @panel.show()
    @storeFocusedElement()
    @focusFilterEditor()

  getPanel: ->
    return @panel

  destroy: ->
    @panel.remove()
    @panel.destroy()
