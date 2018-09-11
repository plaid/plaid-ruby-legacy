require 'test_helper'

# Internal: The test for PlaidHack::Connector.
class PlaidConnectorTest < MiniTest::Test
  include TestHelpers

  def setup
    tartan
  end

  def test_env_not_set
    reset_config

    assert_raises(PlaidHack::NotConfiguredError) do
      PlaidHack::Connector.new(:categories)
    end
  end

  def test_client_id_not_set
    reset_config
    tartan

    PlaidHack.client.secret = 'fun'

    e = assert_raises(PlaidHack::NotConfiguredError) do
      PlaidHack::Connector.new(:connect, auth: true)
    end

    assert_match(/must set PlaidHack::Client\.client_id/, e.message)
  end

  def test_secret_not_set
    reset_config
    tartan

    PlaidHack.client.client_id = 'fun'

    e = assert_raises(PlaidHack::NotConfiguredError) do
      PlaidHack::Connector.new(:connect, auth: true)
    end

    assert_match(/must set PlaidHack::Client\.secret/, e.message)
  end

  def test_200
    stub_test 200, body: '{"test": true}'

    conn = PlaidHack::Connector.new(:test)

    assert_equal({ 'test' => true }, conn.get)
    refute conn.mfa?
  end

  def test_201
    stub_test 201, body: '{"test": true}'

    conn = PlaidHack::Connector.new(:test)

    assert_equal({ 'test' => true }, conn.get)
    assert conn.mfa?
  end

  def test_400
    stub_test 400
    e = assert_raises(PlaidHack::BadRequestError) { make_request }
    check_exception e
  end

  def test_401
    stub_test 401
    e = assert_raises(PlaidHack::UnauthorizedError) { make_request }
    check_exception e
  end

  def test_402
    stub_test 402
    e = assert_raises(PlaidHack::RequestFailedError) { make_request }
    check_exception e
  end

  def test_404
    stub_test 404
    e = assert_raises(PlaidHack::NotFoundError) { make_request }
    check_exception e
  end

  def test_500
    stub_test 500
    e = assert_raises(PlaidHack::ServerError) { make_request }
    check_exception e
  end

  def test_500_without_body
    stub_test 500, body: ''
    e = assert_raises(PlaidHack::ServerError) { make_request }

    assert_equal 0, e.code
    assert_equal 'Try to connect later', e.resolve
    assert_equal 'Code 0: Server error. Try to connect later', e.message
  end

  private

  def make_request
    PlaidHack::Connector.new(:test).get
  end

  def error_body
    %({"code": 999, "message": "boy it's wrong", "resolve": "No way!"})
  end

  def stub_test(status, body: error_body)
    stub_request(:get, 'https://tartan.plaid.com/test')
      .to_return(status: status, body: body)
  end

  def check_exception(e)
    assert_equal 999, e.code
    assert_equal 'No way!', e.resolve
    assert_equal "Code 999: boy it's wrong. No way!", e.message
  end
end
