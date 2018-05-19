defmodule Chatbot do
	use Application
	require Logger

	def start(_type, _args) do
		children = [
			Plug.Adapters.Cowboy.child_spec(:http, Chatbot.Router, [] , port: 8080)
		]
		Logger.info("Started Application")
		Supervisor.start_link(children, strategy: :one_for_one)
	end

end
