require 'whois/record/super_struct'
module Whois
  class Record
    class Handle
      attr_accessor :handle_type, :domain, :person, :role, :org, :maintainer,
        :descr, :org_name, :org_type, :admin_c, :tech_c, :zone_c, :mnt_by,
        :mnt_ref, :nserver, :ds_rdata, :auth, :name, :address, :phone, :fax_no,
        :nic_hdl, :created, :last_modified, :source, :format


      HANDLES = [ 'domain', 'person', 'role', 'organisation', 'maintainer' ]
      HANDLES.each_with_index { |type, index| const_set("TYPE_#{type.upcase}", index + 1) }

      def initialize(format, handle_type, hash)
        self.handle_type = handle_type
        self.format      = format
        build_with_mapper(hash)
      end

      def build_with_mapper(hash)
        case @format
        when 'rpsl'
          rpsl_mapper(hash)
        end
      end

      def rpsl_mapper(hash)
        hash.each do |k,v|
          self.send("#{k.to_s.gsub('-','_')}=", v)
        end
        self
      end
    end
  end
end
