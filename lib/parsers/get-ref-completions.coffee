fs = require 'fs'

module.exports =
get_ref_completions = (rootfile) ->
  aux_ext = ".aux"
  aux_file = rootfile.slice(0, -4) + aux_ext

  try
    aux = fs.readFileSync(aux_file, 'utf-8')
  catch error
    atom.notifications.addError "cannot read #{aux_file}",
      detail: error.toString()
    return

  rx = /\\newlabel{([^}]+)}{{(\d+)}{(\d+)}.*}/g

  labels = []
  while label = rx.exec aux
    labels.push label[1]

  return labels
