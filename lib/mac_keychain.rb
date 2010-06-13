require 'osx/cocoa'
OSX.require_framework 'Security'
OSX.load_bridge_support_file(File.join(File.dirname(__FILE__), 'Security.bridgesupport'))

class MacKeychain
  include OSX

  # A Key is an existing item in Keychain, contains item reference and password
  class Key
    def self.create(data)
      password_length = data.shift
      password_data = data.shift #password data
      item = data.shift #SecKeychainItemRef
      password = if password_data
        password_data.bytestr(password_length)
      end
      self.new(item, password)
    end

    attr_reader :item, :password

    # :item     => Keychain item
    # :password => password of item
    def initialize(item, password)
      @item = item
      @password = password
    end
  end

  # :service => Name of keychain item, Application name or service name
  def initialize(service)
    @service = service
  end

  # Find Key by username (Account of Keychain item)
  def find(username)
    status, *data = SecKeychainFindGenericPassword(nil, @service.length, @service, username.length, username)
    case status
    when ErrSecItemNotFound
      nil
    when 0
      Key.create(data)
    else
      raise "Error when accessing Keychain looking for key: #{username} of #{@service}"
    end
  end

  # Create Keychain item with username (Account of Keychain item) and password
  # Returns creation status code, please see Keychain Services Result Codes.
  def create(username, password)
    SecKeychainAddGenericPassword(nil, @service.length, @service, username.length, username, password.length, password, nil)
  end

  # Delete Keychain item by username (Account of Keychain item)
  # Raises error when delete failed
  def delete(username)
    if key = find(username)
      unless SecKeychainItemDelete(key.item) == 0
        raise "Could not delete Keychain item by #{username} of #{@service}"
      end
    end
  end

  # Update Keychain item by username with new password
  # Returns update status code, please see Keychain Services Result Codes.
  def update(username, password)
    key = self.find(username)
    SecKeychainItemModifyContent(key.item, nil, password.length, password)
  end

  # Create Keychain item if it does not exist, otherwise update it.
  # Returns creation/update status code, please see Keychain Services Result Codes.
  def save(username, password)
    code = create(username, password)
    if ErrSecDuplicateItem == code
      update(username, password)
    else
      code
    end
  end
end
