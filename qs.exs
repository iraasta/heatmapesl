defmodule Qs do
	def sort([], _), do: []
	def sort([pivot | tail], predicate) do	
		{small, r} = Enum.partition tail, &predicate.(pivot, &1)
		sort(small, predicate) ++ [pivot] ++ sort(r, predicate) 
	end
end
