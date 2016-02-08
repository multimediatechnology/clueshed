#= require moment
#= require jquery-ui
#= require fullcalendar

to_rails_params = (events) ->
  # beware!  we are creating params with repeated keys
  # therefore we cannot simply do a $.param( object ), 
  # bcause object cannot contain repeated keys!
  res = $.map events, (e) ->
    $.param(
      "contrib[][id]"           : e.contrib_id,    
      "contrib[][event][start]" : e.start.format(),
      "contrib[][event][end]"   : e.end.format()
    )
  .join("&")

addToSidebar = ($list, contrib_data) ->
  $d = $('<div>')
  if window.is_admin
    $d.draggable(revert: true)
  $list.append(
    $d.data('event', contrib_data)
      .addClass('list-group-item')
      .attr('id', "event-#{contrib_data.contrib_id}")
      .text(contrib_data.contrib_title)
    .append(
      $('<small>')
        .text(" by #{contrib_data.username}")
    )
    .append(
      $('<span>')
        .addClass('badge')
        .text(contrib_data.votes)
    )
  )

expandCal = ($cal, $items) ->
  return if $items.children().length
  $items.parent().hide()
  $cal.parent().addClass('col-md-12').removeClass('col-md-6')

persistCal = ($cal) ->
  all_ev = $cal.data('fullCalendar').clientEvents()
  $.post('/contribs/bulk_update', to_rails_params( all_ev ) )  # fire and forget!

$ ->
  $items = $ '#items'
  $cal = $ '#calendar'

  expandCal = expandCal.bind null, $cal, $items
  persistCal = persistCal.bind null, $cal, $items

  $.get '/contribs.json'
  .then (res) ->
    $list = $('#items').empty()
    scheduled_events = []
    res.sort (contrib) -> -contrib.votes
    res.forEach (contrib) ->
      if contrib.start
        contrib.contrib_title = contrib.title 
        contrib.title = "#{contrib.title} by #{contrib.username} (#{contrib.votes})"
        scheduled_events.push( contrib )
      else
        contrib_data = {
          title: "#{contrib.title} by #{contrib.username} (#{contrib.votes})",
          contrib_title: contrib.title,
          username: contrib.username,
          contrib_id: contrib.contrib_id,   
          duration: '00:30',
          votes: contrib.votes
        }
        addToSidebar( $list, contrib_data )
    $cal.fullCalendar
      events: scheduled_events
      drop: (data, event) ->
        $(event.target).remove()
        expandCal()
        persistCal()
      header: left: '', center: '', right: ''
      minTime: '09:00:00'
      firstDay: 5
      maxTime: '19:00:00'
      editable: window.is_admin
      defaultView: 'agendaWeek'
      hiddenDays: [ 1, 2, 3, 4 ] 
      allDaySlot: no
      defaultDate: '2016-04-08'
      dayNames: do -> [0...7].map -> 'Event Day'
      businessHours:
        start: '09:00'
        end: '18:00'
      droppable: yes
      eventDrop: persistCal
      eventResize: persistCal
      eventOverlap: (stillEvent, movingEvent) ->
        !(stillEvent.username == movingEvent.username)
        
    expandCal $cal, $items


    unless res.length
      $list.append('<div>').addClass('list-group-item').text('No Contribs yet.')


