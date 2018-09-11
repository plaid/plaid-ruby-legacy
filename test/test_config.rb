require 'test_helper'

# Internal: The test for PlaidHack.config.
class PlaidConfigTest < MiniTest::Test
  def test_symbol_environments
    PlaidHack.config do |p|
      p.env = :tartan
    end

    assert_equal 'https://tartan.plaid.com/', PlaidHack.client.env

    PlaidHack.config do |p|
      p.env = :production
    end

    assert_equal 'https://api.plaid.com/', PlaidHack.client.env
  end

  def test_string_url
    PlaidHack.config do |p|
      p.env = 'https://www.example.com/'
    end

    assert_equal 'https://www.example.com/', PlaidHack.client.env
  end

  def test_wrong_values_for_env
    assert_raises ArgumentError do
      PlaidHack.config do |p|
        p.env = 123
      end
    end

    assert_raises ArgumentError do
      PlaidHack.config do |p|
        p.env = :unknown
      end
    end
  end
end
