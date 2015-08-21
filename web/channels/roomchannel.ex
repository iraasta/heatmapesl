defmodule Heatmap.RoomChannel do
	use Phoenix.Channel

	def random_coord(from, to) do
		(:random.uniform() * (to - from)) + from
		|> round()
	end
	
	def fake_dp(socket) do
		:timer.sleep(24)
		push socket, "datapoint", %{x: random_coord(0,800), y: random_coord(0,800), value: 4}
		fake_dp(socket)
	end

	
	def join("rooms:lobby", auth_msg, socket) do
	  {:ok, socket}
	end
	def join("rooms:" <> _private_room_id, _auth_msg, socket) do
	  {:error, %{reason: "unauthorized"}}
	end
	def handle_in("subscribe", _, socket) do
		Task.async fn -> fake_dp(socket) end
		{:noreply, socket}
	end
end
