defmodule Heatmap.DataHandler do
	@usage nil

	use Hedwig.Handler
	def handle_event(%Message{} = msg, opts) do
		case Regex.run ~r/(\d+) ([\d\/]+) ([\d:]+) (\d+)/, msg.body do
			[_msg, distance, date, time, id] ->
				{distance, _} = Integer.parse(distance)
				dp = %{distance: distance, date: date, time: time, id: id}
				IO.puts "Broadcast"
				Heatmap.Endpoint.broadcast! "heatmap:data", "datapoint", dp 
			_ -> IO.puts "No match"
		end
		{:ok, opts}
	end

	def handle_event(_, opts), do: {:ok, opts}
end
