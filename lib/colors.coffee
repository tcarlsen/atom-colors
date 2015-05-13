{CompositeDisposable, Range} = require 'atom'
colors = require 'colors.css'

module.exports = Colors =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'colors:replace': => @replace()

  deactivate: ->
    @subscriptions.dispose()

  replace: ->
    editor = atom.workspace.getActiveTextEditor()

    return if !editor.getLastSelection().isEmpty()

    buffer = editor.getBuffer()
    lines = buffer.lines
    range = editor.getSelectedBufferRanges()[0]
    activeLineContent = lines[range.start.row]
    replaceStart = activeLineContent.indexOf('#')
    replaceEnd = range.end.column
    searchSnippet = activeLineContent.substring(replaceStart + 1, replaceEnd)
    changeRange = new Range([range.start.row, replaceStart], [range.start.row, replaceEnd])

    return if replaceStart is -1

    for key, value of colors
      if key is searchSnippet
        editor.setTextInBufferRange(changeRange, value)

        break
