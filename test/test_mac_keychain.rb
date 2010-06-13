require "test/unit"

require "mac_keychain"

class TestMacKeychain < Test::Unit::TestCase
  def setup
    @keychain = MacKeychain.new('TestKeychain')
    @username = 'username'
  end

  def teardown
    @keychain.delete(@username)
  end

  def test_delete
    @keychain.create(@username, 'password')
    @keychain.delete(@username)
    assert_nil @keychain.find(@username)
  end

  def test_store
    @keychain.create(@username, 'password')
    assert_equal 'password', @keychain.find(@username).password
  end

  def test_find
    assert_nil @keychain.find(@username)
    @keychain.create(@username, 'password')
    assert @keychain.find(@username)
  end

  def test_should_update_password_when_save_new_password
    @keychain.save(@username, 'password')
    @keychain.save(@username, 'new password')
    assert_equal 'new password', @keychain.find(@username).password
  end
end