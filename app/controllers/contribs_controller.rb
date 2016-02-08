class ContribsController < PartipsController


	def index
		@contribs = Contrib.includes(:event,:user).all
	end

  # GET /contribs/new
  def new
    super
    if params[:in_reply_to]
      @contrib.interest = Interest.find(params[:in_reply_to])
    end
  end


  def bulk_update
    if current_user && current_user.is_admin
    	p = params.permit({:contrib=>[:id, {:event=>[:start, :end]}]})

    	Rails.logger.warn(p[:contrib] )

    	Event.bulk_recreate( p[:contrib] )
    else
      Rails.logger.warn("user #{current_user} cannot update the schedule")
    end

  	render(:text => 'true', :status => 200)
  end
end
