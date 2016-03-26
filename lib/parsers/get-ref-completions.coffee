{find_in_files} = require '../ltutils'
fs = require 'fs'
path = require 'path'

module.exports =
get_ref_completions = (rootfile) ->

  get_refs_from_aux = (aux) ->
    rx = /\\newlabel{([^}]+)}{{([^}]+)}{(\d+)}.*}/g

    labels = []
    while label = rx.exec aux
      labels.push {id: label[1], tag: label[2], page: label[3]}
    return labels

  get_refs_from_tex = () ->
    parsed_fname = path.parse(rootfile)

    filedir = parsed_fname.dir
    filebase = parsed_fname.base  # name only includes the name (no dir, no ext)

    labels = find_in_files(filedir, filebase, /\\label\{([^\}]+)\}/g)
    labels = labels.map (e)-> {id: e, tag: "??", page: "??"}
    return labels

  aux_ext = ".aux"
  aux_file = rootfile.slice(0, -4) + aux_ext

  try
    aux = fs.readFileSync(aux_file, 'utf-8')
    labels = get_refs_from_aux(aux)
  catch error
    labels = get_refs_from_tex()

  return labels
