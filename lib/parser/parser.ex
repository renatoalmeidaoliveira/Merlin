defmodule Chatbot.Parser do
	import Plug.Conn
	require Logger

	def init(options) do
	end

	def call(conn , opts) do
		message = conn.body_params["text"]
		fields = String.split(message , " ")
		[_ | fields ] = fields
		[command | args ] = fields
		conn = assign( conn , :command , command)
		conn = assign( conn , :args , args)
		conn	
	end
end
