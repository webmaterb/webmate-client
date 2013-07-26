class Webmate.Client
  constructor: (channel_name) ->
    @bindings = {}
    @channel_name = channel_name || 'http_over_websocket'

    if @useWebsockets()
      @websocket = @createConnection( (message) ->
        console.log(message)
        metadata = message.request.metadata
        eventBindings = @bindings["#{metadata.collection_url}/#{metadata.method}"]

        _.each eventBindings, (eventBinding) ->
          eventBinding(message.response.body, message.request.metadata)
      )

  useWebsockets: ->
    window.Webmate.websocketsEnabled isnt false && io && io.Socket

  createConnection: (onMessageHandler) ->
    # pass callback func, if needed be sure what callback exists
    # token = Webmate.Auth.getToken()
    # return false unless token?
    token = false
    socket = new io.Socket
      resource: @channel_name
      host: location.hostname
      port: Webmate.websocketsPort or location.port
      query: if token then $.param(token: token) else ''

    socket.on "connect", () ->
      console.log("connection established")

    socket.onPacket = (packet) =>
      return unless packet.type is 'message'
      response = JSON.parse(packet.data)
      onMessageHandler.call(@, response)

    socket.connect()
    socket

  on: (action, callback) ->
    @bindings[action] = [] if !@bindings[action]
    @bindings[action].push(callback)
    @

  send: (path, params, method) ->
    data = {}
    data.path = path
    data.method = method
    data.params = params
    data.metadata = {
      request_id: Math.random().toString(36).substr(2);
    }
    packet = {
      type: 'message',
      data: JSON.stringify(data)
    }
    @websocket.packet(packet)

Webmate.connect = (channel, callback)->
  client = new Webmate.Client(channel, callback)
  Webmate.channels[channel] = client
  client
