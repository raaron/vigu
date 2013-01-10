
init = ->
  shortcut.add "Ctrl+S", ->
    document.savable_form.save_button.click()

window.onload = init