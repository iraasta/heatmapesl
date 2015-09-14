defmodule Heatmap.DataHandler do
	@usage nil

	use Hedwig.Handler

	def init(opts) do
		Kernel.send self(), :subscribe
		{:ok, opts}
	end
	def handle_info(:subscribe, opts) do
		#Subscribe
		#[_, server] = opts.client.jid |> String.split("@")
		#jit = "pubsub.#{server}"
		#Process.whereis(String.to_existing_atom(opts.client.jid)) 
		#|> Hedwig.Client.reply(Hedwig.Stanza.subscribe(jit,jit, opts.client.jid))
    {:ok, opts}
	end

  def nested_payload(obj, 0), do: obj
  def nested_payload(obj, times) do
    nested_payload(obj.payload |> hd(), times-1)
  end

  @doc """
  Changes xml with list of children to xml with dictionary of children
  ## Examples

      iex> Heatmap.DataHandler.xml_to_map(%{name: "a", payload: [%{name: "b", payload: [%{name: "c", payload: []}]}]})
      %{name: "a", payload: [{"b", %{name: "b", payload: [{"c", %{name: "c", payload: []}}]}}]}

  """
  def xml_to_map(xml) do
    case xml.payload do
      nil -> xml
      pl  -> Map.update! xml, :payload, fn m -> Enum.map(m, fn a -> {a.name, xml_to_map(a)} end) end   
    end
  end

  @doc """
  Find nested xml child
  """
  def find(obj, pred) when is_function(pred) do
    obj.payload |> Enum.filter(pred) |> hd()
  end
  def find(obj, [_|_] = list) do
    list |> Enum.reduce obj, fn a, b -> find(b, a) end
  end
  def find(obj, name) do
    find(obj, fn a -> a.name == name end)
  end
  
	def handle_event(%Message{} = msg, opts) do
    #data = xml_to_map(msg) |> find(["event","items","item","entry", "data"])
    
		case Regex.run ~r/(\d+) ([\d\/]+) ([\d:]+) (\d+),(\d+)/, msg.body do
			[_msg, distance, date, time, x, y] ->
				{distance, _} = Integer.parse(distance)
				dp = %{distance: distance, date: date, time: time, x: x, y: y}
				Heatmap.Endpoint.broadcast! "heatmap:data", "datapoint", dp 
			_ ->  IO.puts "No match"
		end
		{:ok, opts}
	end

	def handle_event(_, opts), do: {:ok, opts}
end
