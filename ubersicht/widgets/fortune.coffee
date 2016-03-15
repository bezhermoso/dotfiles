# This is a simple example Widget, written in CoffeeScript, to get you started
# with Übersicht. For the full documentation please visit:
#
# https://github.com/felixhageloh/uebersicht
#
# You can modify this widget as you see fit, or simply delete this file to
# remove it.

# this is the shell command that gets executed every time this widget refreshes
command: "/usr/local/bin/fortune"

# the refresh frequency in milliseconds
refreshFrequency: 1000 * 60 * 5

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
render: (quote) ->

  console.log("Quote: " + quote)
  newline = /(?:\r\n|\r|\n)/g
  output = ""
  parts = quote.split newline
  parts = parts.filter (str) ->
    str.length > 0
  attribution = ''
  if parts.length > 1
    idx = parts.reverse().findIndex (ln) ->
      /^\s+--\s[A-Z]+/.test ln
    parts.reverse()

    console.log "index", idx

    if idx > -1
      idx = parts.length - idx - 1
      console.log idx
      attribution = parts.splice(idx, parts.length).join "\n"

    if this.isAttribution(attribution)
      console.log "is an attribution!"
    else
      parts.push(attribution)
      attribution = ''
    quote = parts.join "\n"
  quote = quote.replace(/(?:\r\n|\r|\n)/g, '<br>')
  output = output + "<div id=\"quote\">#{quote}</div>"
  output = (output + '<div id="attribution">' + attribution + '</div>') if attribution
  '<div id="quote-block">' + output + '</div>'

isAttribution: (attribution) ->
  attribution = attribution.trim()
  console.log "Attribution: " + JSON.stringify(attribution)
  if /^--\s+[A-Z]+/.test attribution
    return true
  false


style: """
#quote-block {
 font-family: "Fira Mono Medium";
 color: white;
 max-width: 800px;
 text-shadow: 1px 1px 10px black;
 margin: 50px;
 margin-left: 80px;
}

#quote-block #attribution {
  float: right;
  margin-top: 1rem;
}
"""
