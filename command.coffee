dashdash      = require 'dashdash'
MeshbluConfig = require 'meshblu-config'
MeshbluHttp   = require 'meshblu-http'

packageJSON = require './package.json'

OPTIONS = [{
  names: ['help', 'h']
  type: 'bool'
  help: 'Print this help and exit.'
}, {
  names: ['version', 'v']
  type: 'bool'
  help: 'Print the version and exit.'
}]

class Command
  constructor: ->
    process.on 'uncaughtException', @die
    @parseOptions()
    meshbluConfig = new MeshbluConfig()
    @meshblu = new MeshbluHttp meshbluConfig.toJSON()

  parseOptions: =>
    parser = dashdash.createParser({options: OPTIONS})
    options = parser.parse(process.argv)

    if options.help
      console.log @usage parser.help({includeEnv: true})
      process.exit 0

    if options.version
      console.log packageJSON.version
      process.exit 0

    return options

  run: =>
    @meshblu.whoami (error, me) =>
      return @die error if error?
      console.log JSON.stringify(me, null, 2)
      @die()

  die: (error) =>
    return process.exit(0) unless error?
    console.error 'ERROR'
    console.error error.stack
    process.exit 1

  usage: (optionsStr) =>
    """
    usage: node-meshblu-http-srv-failover-test [OPTIONS]
    options:
    #{optionsStr}
    """

module.exports = Command
