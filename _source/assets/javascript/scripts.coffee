---
---

#####################################
#
# Base Functions
#
#####################################

parallax = (element, direction, start, stop, rate) ->
  $(window).scroll ->
    position = document.body.scrollTop

    if position >= start and position <= stop
      element.css direction, ($(window).scrollTop() * rate)


escapable = -> $('[data-escapable]').fadeOut()


presentation = (toggle) ->
  $toggle = $(toggle)
  $show   = $toggle.data("toggle-presentation")
  $presentation = $("[data-presentation='#{$show}']")

  $toggle.click -> $presentation.fadeIn()
  $presentation.click -> $(this).fadeOut()


Retina = ->
  pixelRatio = (if !!window.devicePixelRatio then window.devicePixelRatio else 1)

  if pixelRatio > 1
    $images = $('[data-retina]')
    $images.each ->
      $image = $(@)
      $image.attr 'src', $image.data 'retina'



#####################################
#
# Global Function Executions
#
#####################################

$ ->
  # Navigation
  $nav     = $(".nav-links")
  $links   = $(".nav-links-list li")
  $trigger = $(".nav-links-trigger")

  $trigger.click ->
    $this   = $(@)
    $status = $this.data "menu"
    $delay  = 0

    switch $status
      when "closed"
        $this.data "menu", "open"
        $nav.addClass "nav-links-expanded"
        $links.each ->
          $(@).css opacity: 0
          $(@).delay($delay).fadeTo 300, 1
          $delay += 25
      when "open"
        $this.data "menu", "closed"
        $nav.removeClass "nav-links-expanded"

  # Escape
  $(window).keydown (event) ->
    switch event.keyCode
      when 27 then escapable()


  # Parallax
  $parallaxable = $('[data-parallax]')
  if $parallaxable.length
    $parallaxable.each ->
      $this = $(this)
      $direction = $this.data('parallax-direction')
      $start = $this.data('parallax-start')
      $stop = $this.data('parallax-stop')
      $rate = $this.data('parallax-rate')
      parallax $this, $direction, $start, $stop, $rate


  # Presentations
  $presentationToggles = $("[data-toggle-presentation]")
  if $presentationToggles.length
    $presentationToggles.each ->
      presentation this

  # Swap retina-ready images
  Retina()

  # Wanker
  $('[data-wanker]').wanker()



#####################################
#
# Page: /is
#
#####################################

toggleBiography = (bio) ->
  swap = (bio) ->
    $bio = $('.about-biography')
    $bio.find('article').fadeOut ->
      $bio.find(bio).fadeIn()

  position = document.body.scrollTop

  if position > 200
    $('body').animate scrollTop: 0,
      duration: 500
      complete: -> swap bio
  else
    swap bio

$ ->
  # Biography Toggle
  $('[data-toggle-bio]').click -> toggleBiography $(this).data('toggle-bio')



#####################################
#
# Page: /writes
#
#####################################

$ ->
  filterEssays = (essayType) ->
    $essays = $('.writes-essays-list')
    $essaysList = $essays.find('li')
    $nonfavorites = $essays.find('li:not([data-favorite])')
    $favoriteToggle = $('[data-essay-filter~="favorites"]')

    switch essayType
      when 'favorites'
        if $favoriteToggle.hasClass 'selected' then $nonfavorites.show() else $nonfavorites.hide()
        $favoriteToggle.toggleClass 'selected'
      when 'recent'
        $essaysList.sort(newestFirst).appendTo $essays
      when 'shortest'
        $essaysList.sort(shortestFirst).appendTo $essays

  shortestFirst = (a, b) ->
    if ($(b).data('words')) < ($(a).data('words')) then 1 else -1

  longestFirst = (a, b) ->
    if ($(b).data('words')) > ($(a).data('words')) then 1 else -1

  newestFirst = (a, b) ->
    if ($(b).data('date')) < ($(a).data('date')) then 1 else -1

  oldestFirst = (a, b) ->
    if ($(b).data('date')) > ($(a).data('date')) then 1 else -1


  if $(".writes-essays").length
    $essays = $('[data-essays]')
    $essaysList = $essays.find('li')

    # Estimated reading time
    $essaysList.each ->
      $words = $(this).data('words')
      $readingTime = Math.floor($words / 3)

      if $readingTime < 60
        $(this).find('[data-reading-time]').text $readingTime + ' second read'
      else
        $readingTime = Math.floor($readingTime / 60)
        $(this).find('[data-reading-time]').text $readingTime + ' minute read'


    # Fade each essay in
    $delay = 0
    $essaysList.each ->
      $delay += 50
      $(this).css opacity: 0
      $(this).delay($delay).fadeTo 500, 1


    # Essay filtering
    $('[data-essay-filter]').click ->
      filterEssays $(this).data('essay-filter')

      if $(this).find('span').hasClass 'essay-ui-radio'
        $(this).addClass 'selected'
        $(this).siblings().removeClass 'selected'


    # Relative essay time
    $essayDates = $("[data-essay-date]")
    $essayDates.each ->
      $(this).text relativeTime $(this).data("essay-date")


  # Fade each thought in
  $thoughtList = $('[data-thought]')
  $thoughtList.each ->
    $delay += 50
    $(this).css opacity: 0
    $(this).delay($delay).fadeTo 500, 1



#####################################
#
# Page: /shares
#
#####################################

relativeTime = (->
  ints =
    second: 1
    minute: 60
    hour: 3600
    day: 86400
    week: 604800
    month: 2592000
    year: 31536000

  (time) ->
    time = +new Date(time)
    gap = ((+new Date()) - time) / 1000
    amount = undefined
    measure = undefined
    for i of ints
      measure = i  if gap > ints[i]
    amount = gap / ints[measure]
    amount = (if gap > ints.day then (Math.round(amount)) else Math.round(amount))
    amount += " " + measure + ((if amount > 1 then "s" else "")) + " ago"
    amount
)()

$ ->
  if $(".shares-content").length
    # Delicious
    $.getJSON "http://feeds.delicious.com/v2/json/migreyes?callback=?",
      count: "5", (data) ->
        $.each data, (i, item) ->
          title = item.d
          url = item.u
          date = relativeTime item.dt
          comment = item.n
          html = """
                 <li class="shares-delicious-link">
                   <span><a href='#{url}'>#{title}</a></span>
                   <em>#{comment} <time>#{date}</time></em>
                 </li>
                 """
          $(".shares-delicious-links").append html


    # GitHub
    $.getJSON "https://api.github.com/users/migreyes/events/public?per_page=3",
      (response) ->
        activities = 0
        template = (action, date) ->
          return """
                 <div class="shares-github-activity">
                   <span><a href="http://github.com/migreyes">Mig</a> #{action}</span>
                   <time>#{date}</time>
                 </div>
                 """

        for activity in response
          do (activity) ->
            date       = relativeTime activity.created_at
            type       = activity.type
            html       = null
            action     = null

            if activities < 9
              switch type
                when "GollumEvent"
                  activities++
                  action = "#{activity.payload.pages[0].action} the <a href='#{activity.payload.pages[0].html_url}' target='_blank'>#{activity.payload.pages[0].page_name}</a> wiki."
                  html   = template action, date
                when "IssuesEvent"
                  activities++
                  action = "created the issue <a href='#{activity.payload.issue.html_url}' target='_blank'>#{activity.payload.issue.title}</a> at <a href='http://github.com/#{activity.repo.name}' target='_blank'>#{activity.repo.name}</a>."
                  html   = template action, date
                when "IssueCommentEvent"
                  activities++
                  action = "commented on <a href='#{activity.payload.issue.html_url}' target='_blank'>#{activity.payload.issue.title}</a> at <a href='http://github.com/#{activity.repo.name}' target='_blank'>#{activity.repo.name}</a>."
                  html   = template action, date
                when "PushEvent"
                  activities++
                  html = """
                           <div class="shares-github-activity">
                             <span><a href="http://github.com/migreyes">Mig</a> pushed to <a href="http://github.com/#{activity.repo.name} target="_blank">#{activity.repo.name}</a></span>
                             <em>#{activity.payload.commits[0].message}</em>
                             <time>#{date}</time>
                           </div>
                           """
                else
                  html = ""

            $(".shares-github").append html


    # Instagram Profile
    $.getJSON "https://api.instagram.com/v1/users/4706860/?client_id=66dc56b3318e4c9c8c4ce5283507b947&callback=?",
      (response) ->
        followers = response.data.counts.followed_by
        $("[data-instagram-followers]").text ", #{followers} followers"

    # Instagram Photos
    $.getJSON "https://api.instagram.com/v1/users/4706860/media/recent/?client_id=66dc56b3318e4c9c8c4ce5283507b947&callback=?",
      (response) ->
        photos = response.data
        for photo in photos
          do (photo) ->
            date     = relativeTime new Date parseInt(photo.created_time) * 1000
            link     = photo.link
            likes    = photo.likes.count
            source   = photo.images.standard_resolution.url
            caption  = photo.caption.text
            location = photo.location.name
            html     = """
                       <div class="shares-instagram-photo" style="background-image: url('#{source}');">
                         <img src="/assets/images/shares/instagram.gif">
                         <a href="#{link}" target="_blank">
                           <div class="shares-instagram-photo-info">
                             <p>#{caption}</p>
                             <em>#{date} at #{location}</em>
                             <span>&hearts; #{likes}</span>
                           </div>
                         </a>
                       </div>
                       """
            $(".shares-instagram").append html


    # Relative blog post time
    $blogPostTimes = $("[data-post-date]")
    $blogPostTimes.each ->
      $(this).text relativeTime $(this).data("post-date")


  if $(".blog").length
    # Relative blog post time
    $blogPostTimes = $("[data-post-date]")
    $blogPostTimes.each ->
      $(this).text relativeTime $(this).data("post-date")



#####################################
#
# Wanker 1.0.0
# http://mig.io/makes/wanker
#
# The web was meant to be read, not squished.
# Display a message on excessive browser resizing.
#
# MIT License
#
# by Mig Reyes, Designer at Basecamp
# http://twitter.com/migreyes
#
#####################################

(($) ->
  $.fn.wanker = (options) ->

    settings = $.extend(
      delay: 500
      duration: 1200
    , options)

    return @each ()->
      $message = $(@)
      mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)

      unless mobile
        start = null
        fired = 0
        elapsed = null
        timer = undefined

        reset = ->
          fired = 0
          elapsed = null

        $(window).resize ->
          if fired < 1
            start = new Date()
            fired++
          else
            elapsed = Math.abs(new Date() - start)
            fired++

          # Reveal the message after the delay is surpassed.
          if elapsed > settings.delay then $message.fadeIn()

          # Countdown timer before closing and resetting.
          clearTimeout timer if timer
          timer = setTimeout(->
            $message.fadeOut()
            reset()
          , settings.duration)
) jQuery
