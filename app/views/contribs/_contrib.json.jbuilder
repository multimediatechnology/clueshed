json.(contrib, :title)
json.contrib_id contrib.id
json.description markdown(contrib.description)
json.username contrib.user.username
if contrib.event
  json.start contrib.event.start
	json.end   contrib.event.end
end
json.votes contrib.votes.length
json.url polymorphic_url contrib
