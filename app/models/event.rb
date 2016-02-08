class Event < ActiveRecord::Base
  belongs_to :contrib

  def self.bulk_recreate( contribs )
  	Event.transaction do
	  	Event.delete_all
      if contribs.nil?
      else
  	  	contribs.each do | contrib_data |
  	  		c = Contrib.find(contrib_data[:id].to_i)
  	  		# raise ActiveRecord::RecordNotFound if c.nil?
  	  		c.create_event!( contrib_data[:event] )
  	    end
      end
    end
  end

end

