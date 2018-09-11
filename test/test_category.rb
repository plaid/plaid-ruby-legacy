require 'test_helper'

# The test for PlaidHack::Category.
class PlaidCategoryTest < MiniTest::Test
  include TestHelpers

  def setup
    tartan
  end

  def test_string_representation
    c = PlaidHack::Category.new('type' => 'place',
                            'hierarchy' => ['Travel'],
                            'id' => '22000000')

    str = %(#<PlaidHack::Category id="22000000", type=:place, hierarchy=["Travel"]>)

    assert_equal str, c.to_s
    assert_equal str, c.inspect
  end

  def test_all_categories
    stub_request(:get, 'https://tartan.plaid.com/categories')
      .to_return(status: 200, body: fixture(:categories))

    cats = PlaidHack::Category.all

    assert_equal 602, cats.size

    cat = cats.select { |c| c.id == '22012003' }.first
    refute_nil cat

    assert_equal :place, cat.type
    assert_equal ['Travel', 'Lodging', 'Hotels and Motels'], cat.hierarchy
  end

  def test_all_categories_with_custom_client
    client = PlaidHack::Client.new(env: 'https://example.com')

    stub_request(:get, 'https://example.com/categories')
      .to_return(status: 200, body: fixture(:categories))

    PlaidHack::Category.all(client: client)
  end

  def test_get_single_category
    stub_request(:get, 'https://tartan.plaid.com/categories/19012002')
      .to_return(status: 200, body: fixture('category_19012002'))

    cat = PlaidHack::Category.get '19012002'
    refute_nil cat

    assert_equal '19012002', cat.id
    assert_equal :place, cat.type
    assert_equal ['Shops', 'Clothing and Accessories', 'Swimwear'],
                 cat.hierarchy
  end

  def test_get_single_category_with_custom_client
    client = PlaidHack::Client.new(env: 'https://example.com')

    stub_request(:get, 'https://example.com/categories/19012002')
      .to_return(status: 200, body: fixture('category_19012002'))

    PlaidHack::Category.get '19012002', client: client
  end

  def test_get_nonexistent_category
    stub_request(:get, 'https://tartan.plaid.com/categories/0')
      .to_return(status: 404, body: fixture(:category_not_found))

    e = assert_raises(PlaidHack::NotFoundError) do
      PlaidHack::Category.get '0'
    end

    assert_equal 'Code 1501: unable to find category. ' \
                 'Double-check the provided category ID.', e.message
  end
end
