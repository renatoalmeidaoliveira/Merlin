defmodule Chatbot.Router do
	use Plug.Router
	use Plug.ErrorHandler

	plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
			   pass: ["application/json"],
			   json_decoder: Jason
)
	plug(Chatbot.Auth)
	plug(Chatbot.Parser)
	plug(:match)
	plug(:dispatch)

	post "/" do
		command = conn.assigns[:command]
		args = conn.assigns[:args]
		{resposta , _} = System.cmd command , args
		output = %Chatbot.Resposta{text: resposta} 
		IO.inspect conn
		send_resp(conn,200,Jason.encode!(output))
	end

	match _ do
		send_resp(conn, 404, "oops")
	end

	def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
		send_resp(conn , conn.status, reason.message)	
		IO.inspect conn
		IO.inspect stack
		IO.inspect reason
		IO.inspect kind
	end

end
