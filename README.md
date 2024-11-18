

Energy Calculator - README
==========================

This project was created as a gift for my friend Fernanda to assist her in her graduation and inspire her to learn Elixir. The goal is to calculate energy differences between morning and afternoon readings, represent them using binary or two's complement, and save the results in a CSV file. By working on this project, Fernanda will gain hands-on experience with Elixir and functional programming concepts.

To get started, clone the repository and run `mix new` only within the repository folder. Follow the instructions below to set up the project and run the script.

1\. Installing Elixir
---------------------

Follow these steps to install Elixir and its dependencies:

*   **Step 1:** Update your system packages.
    ```bash
    sudo apt update && sudo apt upgrade
    ```
*   **Step 2:** Install Erlang and Elixir.

    ```bash
    sudo apt install -y erlang elixir
    ``` 

*   **Step 3:** Verify the installation.
    ```bash
    elixir -v
    ```
You should see the Elixir version and its corresponding Erlang/OTP version.

2\. Setting Up the Project
--------------------------

Once Elixir is installed, set up the project:

*   **Step 1:** Clone the repository:
    ```bash
    git clone https://github.com/your-repository/energy_calculator_fefa.git
    ```
*   **Step 2:** Navigate to the project directory:
    ```bash
    cd energy_calculator_fefa
    ```
*   **Step 3:** Run `mix new` to initialize the Elixir project:
    ```bash
    mix new .
    ```
Note: The `.` ensures the project is created within the current directory.

*   **Step 4:** Install the `CSV` library by editing the `mix.exs` file. Add the following dependency:

    ```bash
    defp deps do
      [
        {:csv, "~> 2.4"}
      ]
    end
    ```        

*   **Step 5:** Install dependencies:
    ```bash
    mix deps.get
    ```
3\. Understanding the Script
----------------------------

The script is divided into logical sections. Below is the code along with explanations for each part:

### 3.1. Define the Energy Data

    ```bash
    @stations [
      %{station: "Station 1", morning: 120, afternoon: 130},
      %{station: "Station 2", morning: 75, afternoon: 111},
      %{station: "Station 3", morning: 223, afternoon: 310},
      %{station: "Station 4", morning: 15, afternoon: 38},
      %{station: "Station 5", morning: 94, afternoon: 197}
    ]
    ```

This section defines a list of maps representing the energy readings for each station during the morning and afternoon.

### 3.2. Calculate Energy Differences

    ```bash
    results =
      Enum.map(@stations, fn %{station: station, morning: morning, afternoon: afternoon} ->
        difference = morning - afternoon
        binary = convert_to_binary(difference)
        {station, morning, afternoon, difference, binary}
      end)
    ```

For each station, the script calculates the energy difference and converts it to binary or two's complement if negative.

### 3.3. Convert to Binary or Two's Complement

    ```bash
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
    ```

This section handles binary conversion. Positive numbers are straightforward, while negative numbers use two's complement.

### 3.4. Save Results to CSV

    ```bash
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
    ```

This section writes the calculated data to a CSV file named `results.csv`.

4\. Running the Script
----------------------

To execute the script:

*   **Step 1:** Open the Elixir interactive shell (IEx):
    ```bash
    iex -S mix
    ```
*   **Step 2:** Run the function to calculate and save the results:
    ```bash
    EnergyCalculator.calculate_energy()
    ```
5\. Viewing the Results
-----------------------

The script will generate a file named `results.csv` in the project directory. Open it with a text editor or CSV viewer to see the results:

6\. Troubleshooting
-------------------

If you encounter any issues, ensure you:

*   Have the correct versions of Elixir and Erlang installed.
*   Installed the CSV dependency correctly using `mix deps.get`.
*   Followed the steps to replace the script in `lib/energy_calculator.ex`.

If problems persist, feel free to reach out for assistance.