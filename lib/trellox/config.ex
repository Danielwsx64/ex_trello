defmodule Trellox.Config do
  @moduledoc """
  Trellox client configurations

  To use `Trellox` you must add into your config file `config.exs` the
  required config:

      config :trellox, key: "your-trello-api-key"

  Allowed configuration:

  - key(required): The API key provide for Trello Dashboard.
  - host: A string containing the API host. (default is `"api.trello.com"`)
  """

  defmodule Adapter do
    @moduledoc false
    defstruct([:module, :configs])

    @type t() :: %__MODULE__{
            module: atom(),
            configs: Keyword.t()
          }
  end

  defstruct [:host, :key, :adapter]

  @type t :: %__MODULE__{
          host: URI.t(),
          key: String.t(),
          adapter: Adapter.t()
        }

  @type config_overrides :: [{:key, binary()} | {:host, binary()}]

  @default_host "api.trello.com"

  @doc false
  @spec build(config_overrides()) :: t()
  def build(overrides) do
    :trellox
    |> Application.get_all_env()
    |> Keyword.merge(overrides)
    |> build_struct()
  end

  defp build_struct(configs) do
    %__MODULE__{
      key: get(configs, :key),
      host: host_uri(configs),
      adapter: %Adapter{
        module: Trellox.Adapter.Tesla,
        configs: [adapter: Tesla.Adapter.Hackney]
      }
    }
  end

  defp host_uri(configs) do
    ~r"(?<scheme>http[s]?)?(:[\/]{2})?(?<host>[\w\.-]+)(:?(?<port>\d+))?(\/(?<path>.*))?"
    |> Regex.named_captures(get(configs, :host, @default_host))
    |> to_uri()
  end

  defp to_uri(captures) do
    %URI{
      scheme: get_captured(captures, "scheme", "https"),
      host: get_captured(captures, "host"),
      port: port_to_integer(get_captured(captures, "port")),
      path: get_captured(captures, "path")
    }
  end

  defp port_to_integer(port) when is_binary(port), do: String.to_integer(port)
  defp port_to_integer(port), do: port

  defp get_captured(captures, key, default \\ nil) do
    case Map.get(captures, key, default) do
      "" -> default
      value -> value
    end
  end

  defp get(keyword, key, default \\ nil),
    do: Keyword.get(keyword, key, default)
end
