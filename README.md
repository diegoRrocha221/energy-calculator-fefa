<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Energy Calculator - README</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
        }
        h1, h2 {
            color: #2c3e50;
        }
        code {
            background-color: #f4f4f4;
            padding: 2px 5px;
            border-radius: 3px;
        }
        pre {
            background-color: #f4f4f4;
            padding: 10px;
            border-left: 3px solid #2c3e50;
            overflow-x: auto;
        }
        ul {
            margin: 10px 0;
        }
        a {
            color: #3498db;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Energy Calculator - README</h1>
    <p>
        This project was created as a gift for my friend Fernanda to assist her in her graduation 
        and inspire her to learn Elixir. The goal is to calculate energy differences between morning 
        and afternoon readings, represent them using binary or two's complement, and save the results 
        in a CSV file. By working on this project, Fernanda will gain hands-on experience with Elixir and functional programming concepts.
    </p>
    <p>
        To get started, clone the repository and run <code>mix new</code> only within the repository folder. 
        Follow the instructions below to set up the project and run the script.
    </p>

    <h2>1. Installing Elixir</h2>
    <p>Follow these steps to install Elixir and its dependencies:</p>
    <ul>
        <li><strong>Step 1:</strong> Update your system packages.</li>
        <pre><code>sudo apt update && sudo apt upgrade</code></pre>

        <li><strong>Step 2:</strong> Install Erlang and Elixir.</li>
        <pre><code>
sudo apt install -y erlang elixir
        </code></pre>

        <li><strong>Step 3:</strong> Verify the installation.</li>
        <pre><code>elixir -v</code></pre>
        <p>You should see the Elixir version and its corresponding Erlang/OTP version.</p>
    </ul>

    <h2>2. Setting Up the Project</h2>
    <p>Once Elixir is installed, set up the project:</p>
    <ul>
        <li><strong>Step 1:</strong> Clone the repository:</li>
        <pre><code>git clone https://github.com/your-repository/energy_calculator_fefa.git</code></pre>

        <li><strong>Step 2:</strong> Navigate to the project directory:</li>
        <pre><code>cd energy_calculator_fefa</code></pre>

        <li><strong>Step 3:</strong> Run <code>mix new</code> to initialize the Elixir project:</li>
        <pre><code>mix new .</code></pre>
        <p>Note: The <code>.</code> ensures the project is created within the current directory.</p>

        <li><strong>Step 4:</strong> Install the <code>CSV</code> library by editing the <code>mix.exs</code> file. Add the following dependency:</li>
        <pre><code>
defp deps do
  [
    {:csv, "~> 2.4"}
  ]
end
        </code></pre>

        <li><strong>Step 5:</strong> Install dependencies:</li>
        <pre><code>mix deps.get</code></pre>
    </ul>

    <h2>3. Understanding the Script</h2>
    <p>The script is divided into logical sections. Below is the code along with explanations for each part:</p>

    <h3>3.1. Define the Energy Data</h3>
    <pre><code>
@stations [
  %{station: "Station 1", morning: 120, afternoon: 130},
  %{station: "Station 2", morning: 75, afternoon: 111},
  %{station: "Station 3", morning: 223, afternoon: 310},
  %{station: "Station 4", morning: 15, afternoon: 38},
  %{station: "Station 5", morning: 94, afternoon: 197}
]
    </code></pre>
    <p>This section defines a list of maps representing the energy readings for each station during the morning and afternoon.</p>

    <h3>3.2. Calculate Energy Differences</h3>
    <pre><code>
results =
  Enum.map(@stations, fn %{station: station, morning: morning, afternoon: afternoon} ->
    difference = morning - afternoon
    binary = convert_to_binary(difference)
    {station, morning, afternoon, difference, binary}
  end)
    </code></pre>
    <p>For each station, the script calculates the energy difference and converts it to binary or two's complement if negative.</p>

    <h3>3.3. Convert to Binary or Two's Complement</h3>
    <pre><code>
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
    </code></pre>
    <p>This section handles binary conversion. Positive numbers are straightforward, while negative numbers use two's complement.</p>

    <h3>3.4. Save Results to CSV</h3>
    <pre><code>
defp save_to_csv(results) do
  headers = ["Station", "Morning (W)", "Afternoon (W)", "Difference (W)", "Binary/Two's Complement"]

  csv_content =
    [headers] ++
    Enum.map(results, fn {station, morning, afternoon, difference, binary} ->
      [station, Integer.to_string(morning), Integer.to_string(afternoon), Integer.to_string(difference), binary]
    end)

  {:ok, file} = File.open("results.csv", [:write])

  csv_content
  |> CSV.encode()
  |> Enum.each(&IO.write(file, &1))

  File.close(file)
  IO.puts("Results saved as 'results.csv'")
end
    </code></pre>
    <p>This section writes the calculated data to a CSV file named <code>results.csv</code>.</p>

    <h2>4. Running the Script</h2>
    <p>To execute the script:</p>
    <ul>
        <li><strong>Step 1:</strong> Open the Elixir interactive shell (IEx):</li>
        <pre><code>iex -S mix</code></pre>

        <li><strong>Step 2:</strong> Run the function to calculate and save the results:</li>
        <pre><code>EnergyCalculator.calculate_energy()</code></pre>
    </ul>

    <h2>5. Viewing the Results</h2>
    <p>The script will generate a file named <code>results.csv</code> in the project directory. Open it with a text editor or CSV viewer to see the results:</p>

    <h2>6. Troubleshooting</h2>
    <p>If you encounter any issues, ensure you:</p>
    <ul>
        <li>Have the correct versions of Elixir and Erlang installed.</li>
        <li>Installed the CSV dependency correctly using <code>mix deps.get</code>.</li>
        <li>Followed the steps to replace the script in <code>lib/energy_calculator.ex</code>.</li>
    </ul>

    <p>If problems persist, feel free to reach out for assistance.</p>
</body>
</html>
