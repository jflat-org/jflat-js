class JFlat
  dump: (node)->
    type = @type node

    throw "JFlat dump failed. Data has circular references." \
      if type == 'circular'
    throw "JFlat dump failed. Data must be acceptable to JSON.stringify." \
      if type == 'error'
    throw "JFlat dump failed. Data type is unknown at '/'." \
      if type == 'unknown'

    return '' if type == 'undefined'

    @out = []

    @dumpNode '/', node, type

    return @out.join ''

  dumpNode: (path, node, type)->
    type ||= @type(node)

    if type == 'unknown'
      throw "JFlat dump failed. Data type is unknown at '/#{path.join '/'}'."

    if type in ['null', 'undefined']
      @add path, 'null'
    else if type in ['string', 'number', 'boolean', 'null']
      @add path, JSON.stringify node
    else if type == 'array'
      len = node.length
      @add path, "[#{len}]"
      path = '' if path == '/'
      if len > 0
        last = path.len
        d = Math.ceil Math.log10 len - .5
        z = '0'.repeat(d)
        d = 0 - d
        for elem, i in node
          @dumpNode "#{path}/#{(z + i)[d..]}", elem
    else if type == 'object'
      @add path, "{#{Object.keys(node).length}}"
      path = '' if path == '/'
      last = path.len
      for key, value of node
        if key.match /^[\-\+\:\.\_0-9a-zA-Z]+$/
          @dumpNode "#{path}/#{key}", value
        else
          @dumpNode "#{path}/#{JSON.stringify key}", value

  type: (node)->
    type = typeof node
    return type if type in ['string', 'number', 'boolean', 'undefined']
    return 'array' if Array.isArray node
    return 'null' if node == null
    try
      string = JSON.stringify node
    catch e
      msg = e.toString()
      return 'circular' \
        if msg == 'TypeError: Converting circular structure to JSON'
      return 'error'

    return 'object' if string[0] == '{'
    return 'array' if string[0] == '['
    return 'string' if string[0] == '"'
    return 'number' if string.match /^-?[0-9]/
    return 'bool' if string in ['true', 'false']
    return 'null' if string == 'null'
    return 'unknown'

  add: (path, data)->
    @out.push "#{path}\t#{data}\n"

module.exports = {JFlat}
