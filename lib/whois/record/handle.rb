module Whois
  class Record
    class Handle
      attr_accessor :handle_type, :domain, :person, :role, :org, :maintainer,
        :descr, :org_name, :org_type, :admin_c, :tech_c, :zone_c, :mnt_by,
        :mnt_ref, :nserver, :ds_rdata, :auth, :name, :address, :phone, :fax_no,
        :nic_hdl, :created, :last_modified, :source, :format, :remarks,
        :abuse_mailbox, :organisation

      HANDLES = [ 'domain', 'person', 'role', 'organisation', 'mntner' ]
      FORMATS = [ 'rpsl' ]

      def initialize(format, handle_type, hash)
        self.handle_type = handle_type.to_s
        self.format      = format.to_s
        raise HandleFormatNotImplemented unless format_implemented?
        raise HandleTypeNotImplemented unless type_implemented?
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
          case k
          when 'mntner'
            k = 'maintainer'
          end
          self.send("#{k.to_s.gsub('-','_')}=", v)
        end
        self
      end

      private
      def format_implemented?
        FORMATS.include?(self.format)
      end

      def type_implemented?
        HANDLES.include?(self.handle_type)
      end
    end
  end
end
