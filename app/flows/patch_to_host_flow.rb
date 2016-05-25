class PatchToHostFlow < ActiveFlow::Base
  def self.create(destination_mac_address:, out_port:)
    send_flow_mod_add(0xabc,
                      match: Match.new(in_port: Host.all.size + 1,
                                       destination_mac_address: destination_mac_address),
                      actions: SendOutPort.new(out_port))
  end
end