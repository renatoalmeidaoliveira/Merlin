defmodule Chatbot.Auth do 
	defmodule NotAuthorizedError do
		defexception message: "Acesso proibido" , plug_status: 403
	end
	import Plug.Conn
	require Logger
	def init(options) do
		pwd = Path.join(System.cwd!() , "/config/access.json")
		configFile = File.read!(pwd)
		config = Jason.decode!(configFile)
		config = config["server"]
		server = %{config | "ip" => String.to_charlist(config["ip"])}	
	end

	def call(conn, opts) do
		{:ok , authIp} = :inet.parse_ipv4_address(opts["ip"])
		{ip,_} = conn.peer()
		token = conn.body_params["token"]
		conn = assign(conn, :token , token)
		if (ip != authIp) do
			raise(NotAuthorizedError)
		end
		auth = Enum.any?(opts["groups"] , fn(x) -> x["outgoingToken"] == token end )
		if !auth do 
			raise(NotAuthorizedError)
		end
		conn 
	end
end
