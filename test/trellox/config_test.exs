defmodule Trellox.ConfigTest do
  use ExUnit.Case, async: true

  alias Trellox.Config

  describe "build/1" do
    test "build config struct with config file configurations" do
      config = Config.build([])

      assert config == %Config{
               adapter: %Trellox.Config.Adapter{
                 configs: [adapter: Tesla.Adapter.Hackney],
                 module: Trellox.Adapter.Tesla
               },
               host: %URI{host: "api.trello.com", scheme: "https"},
               key: "fake-api-key-test-1234"
             }
    end

    test "build config struct overlapping config file confiturations" do
      config = Config.build(key: "some-custom-key", host: "http://custom-host.com:1234/api")

      assert config == %Config{
               adapter: %Trellox.Config.Adapter{
                 configs: [adapter: Tesla.Adapter.Hackney],
                 module: Trellox.Adapter.Tesla
               },
               host: %URI{host: "custom-host.com", path: "api", port: 1234, scheme: "http"},
               key: "some-custom-key"
             }
    end
  end
end
