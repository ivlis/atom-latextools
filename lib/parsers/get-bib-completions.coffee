fs = require 'fs'
bib2json = require 'bib2json'

module.exports =
get_bib_completions = (bibfile) ->

  try
    bibfile = fs.readFileSync(bibfile, 'utf-8')
    bib = bib2json bibfile
  catch error
    atom.notifications.addError "cannot read #{bibfile}",
      detail: error.toString()
    return

  console.log "Found #{bib.entries.length} total bib entries
               with #{bib.errors.length} errors"

  # format author field (short)
  format_author = (authors) ->
    # split authors using ' and ' and get last name for 'last, first' format
    authors = (a.split(", ")[0].trim() for a in authors.split(" and "))
    # get last name for 'first last' format (preserve {...} text)
    # FIXME: Handle First Last format
    ## authors = [if a[-1] != '}' || a.find('{') == -1 then a.split(" ")[-1] else re.sub(r'{|}', '', a[len(a) - a[::-1].index('{'):-1]) for a in authors]
    # truncate and add 'et al.'
    if authors.length > 2
      authors = authors[0] + " et al."
    else
      authors = authors.join(' & ')
    return authors

  keywords = bib.entries.map (e) -> e.EntryKey
  titles = bib.entries.map (e) -> e.Fields.title
  authors = bib.entries.map(
    (e) ->
      e.Fields.author ? e.Fields.editor
    )
  years = bib.entries.map (e) -> e.Fields.year
  journals = bib.entries.map (e) -> e.Fields.journal

  authors_short = authors.map (a) -> format_author a
  titles_short = titles.map(
    (t) ->
      if t?.length && t.length > 40 then t[0...40] + '...' else t
  )

  return [keywords, titles, authors, years,
          authors_short, titles_short, journals]
