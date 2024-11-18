defmodule EnergyCalculator do
  @stations [
    %{station: "Station 1", morning: 120, afternoon: 130},
    %{station: "Station 2", morning: 75, afternoon: 111},
    %{station: "Station 3", morning: 223, afternoon: 310},
    %{station: "Station 4", morning: 15, afternoon: 38},
    %{station: "Station 5", morning: 94, afternoon: 197}
  ]

  def calculate_energy do
    results =
      Enum.map(@stations, fn %{station: station, morning: morning, afternoon: afternoon} ->
        difference = morning - afternoon
        binary = convert_to_binary(difference)
        {station, morning, afternoon, difference, binary}
      end)

    save_to_csv(results)
  end

  defp convert_to_binary(value) when value >= 0 do
    Integer.to_string(value, 2) |> String.pad_leading(8, "0")
  end

  defp convert_to_binary(value) do
    value
    |> Kernel.abs()
    |> Integer.to_string(2)
    |> String.pad_leading(8, "0")
    |> String.graphemes()
    |> Enum.map(fn
      "0" -> "1"
      "1" -> "0"
    end)
    |> Enum.join()
    |> (&Integer.parse(&1, 2)).()
    |> elem(0)
    |> Kernel.+(1)
    |> Integer.to_string(2)
    |> String.pad_leading(8, "0")
  end

  defp save_to_csv(results) do
    headers = ["Estação", "Manhã (W)", "Tarde (W)", "Diferença (W)", "Binário/Complemento de 2"]

    csv_content =
      [headers] ++
        Enum.map(results, fn {station, morning, afternoon, difference, binary} ->
          [station, Integer.to_string(morning), Integer.to_string(afternoon), Integer.to_string(difference), binary]
        end)

    {:ok, file} = File.open("resultado.csv", [:write])

    csv_content
    |> CSV.encode()
    |> Enum.each(&IO.write(file, &1))

    File.close(file)
    IO.puts("Tabela de resultados salva como 'resultado.csv'")
  end
end
