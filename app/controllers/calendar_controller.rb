class CalendarController < ApplicationController
	def index
		@title = 'Session Planning'
	end

	def reset
		Event.delete_all
		redirect_to calendar_path
	end
end
