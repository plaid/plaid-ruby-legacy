require 'test_helper'

# Internal: The test for PlaidHack::Client
class PlaidClientTest < MiniTest::Test
  def test_symbol_environments
    client = PlaidHack::Client.new
    client.env = :tartan

    assert_equal 'https://tartan.plaid.com/', client.env

    client2 = PlaidHack::Client.new
    client2.env = :production

    assert_equal 'https://api.plaid.com/', client2.env
  end

  def test_string_url
    client = PlaidHack::Client.new
    client.env = 'https://www.example.com/'

    assert_equal 'https://www.example.com/', client.env
  end

  def test_wrong_values_for_env
    assert_raises ArgumentError do
      PlaidHack::Client.new(env: 123)
    end

    assert_raises ArgumentError do
      PlaidHack.config do |p|
        PlaidHack::Client.new(env: :unknown)
      end
    end
  end
end
