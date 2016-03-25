fs = require 'fs'
bib2json = require 'bib2json'

module.exports =
get_bib_completions = (bibfile) ->

  completions = []

  kp_rx = /@[^\{]+\{(.+),/
  multi_rx = /\b(author|title|year|editor|journal|eprint)\s*=\s*(?:\{|"|\b)(.+?)(?:\}+|"|\b)\s*,?\s*$/i    # Python's \Z = JS's $

  try
    bibfile = fs.readFileSync(bibfile, 'utf-8')
    bib = bib2json bibfile
  catch error
    atom.notifications.addError "cannot read #{bibfile}",
      detail: error.toString()
    return

  console.log( "Found #{bib.entries.length} total bib entries with #{bib.errors.length} errors")

  keywords = []
  titles = []
  authors = []
  years = []
  journals = []
  authors_short = []
  titles_short = []

  sep = /:|\.|\?/

  # format author field (short)
  format_author = (authors) ->
    # split authors using ' and ' and get last name for 'last, first' format
    authors = [a.split(", ")[0].trim() for a in authors.split(" and ")]
    # get last name for 'first last' format (preserve {...} text)
    # FIXME: I can't understand what this does!!!!
    ## authors = [if a[-1] != '}' || a.find('{') == -1 then a.split(" ")[-1] else re.sub(r'{|}', '', a[len(a) - a[::-1].index('{'):-1]) for a in authors]
    # truncate and add 'et al.'
    if authors.length > 2
      authors = authors[0] + " et al."
    else
      authors = authors.join(' & ')
    # return formated string
    # print(authors)
    return authors

  keywords = bib.entries.map (e) -> e.EntryKey
  titles = bib.entries.map (e) -> e.Fields.title
  authors = bib.entries.map (e) -> e.Fields.author
  years = bib.entries.map (e) -> e.Fields.year
  journals = bib.entries.map (e) -> e.Fields.journal
    #       titles.push entry.Fields.title

  console.log titles

  # for i in [0...keywords.length]
  #   # Filter out }'s at the end. There should be no commas left
  #   t = titles[i].replace('{\\textquoteright}', '').replace(/\{/g,'').replace(/\}/g,'')
  #   titles[i] = t
  #   authors_short[i] = format_author(authors[i])
  #   t = t.split(sep)[0]
  #   titles_short[i] = if t.length > 40 then t[0...40] + '...' else t

  authors_short = authors
  titles_short = titles


  return [keywords, titles, authors, years, authors_short, titles_short, journals]
