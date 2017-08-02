# frozen_string_literal: true

module NetTester
  class TestNode
    # rubocop:disable ParameterLists
    def initialize(name:,
                   mac_address:,
                   ip_address:,
                   netmask:,
                   gateway:,
                   virtual_port_number:,
                   physical_port_number:,
                   vlan_id: nil)
    end
    # rubocop:enable ParameterLists

    def method_missing(method, *args, &block)
      __send__ method, *args, &block
    end
  end
end
