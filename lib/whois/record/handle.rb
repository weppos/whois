require 'whois/record/super_struct'
module Whois
  class Record
    class Handle < SuperStruct.new( :type, :domain, :person, :role, :org, :maintainer,
                                    :descr, :'org-name', :'org-type',
                                    :'admin-c', :'tech-c', :'zone-c', :'mnt-by', :'mnt-ref',
                                    :nserver, :'ds-rdata', :auth,
                                    :name, :address,
                                    :phone, :'fax-no',
                                    :'nic-hdl', :created, :'last-modified',
                                    :source )

      HANDLES = [ 'domain', 'person', 'role', 'organisation', 'maintainer' ]
      HANDLES.each_with_index { |type, index| const_set("TYPE_#{type.upcase}", index + 1) }
    end
  end
end
