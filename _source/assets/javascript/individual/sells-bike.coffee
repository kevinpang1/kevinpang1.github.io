---
---

BikeGallery =
  install: (gallery) ->
    $gallery = $(gallery)
    $photos = $gallery.find('[data-photo]')
    $stage = $gallery.find('[data-photo-stage]')
    $height = Math.floor($(window).width() * 0.535)
    $photoPosition = 0

    setHeight = (el, height) ->
      $el = $(el)
      $el.height height

    alignPhotos = ->
      $photos.each ->
        $(this).css
          left: $photoPosition
          width: $(window).width()
        $photoPosition += $(window).width()

    setStage = ->
      setHeight $gallery, $height
      setHeight $photos, $height
      alignPhotos()

    setStage()


currentBikePhoto = 1


nextPhoto = ->
  $stage = $('[data-photo-stage]')
  distance = $(window).width() * currentBikePhoto
  currentBikePhoto += 1

  if $(window).width() >= 768
    if currentBikePhoto > $stage.find('figure').length
      $stage.animate
        left: "0"
      , 500
      currentBikePhoto = 1
    else
      $stage.animate
        left: -distance
      , 500


previousPhoto = ->
  $stage = $('[data-photo-stage]')
  $lastPhoto = $stage.find('figure').length
  currentBikePhoto -= 1

  if currentBikePhoto < 1
    distance = $(window).width() * ($lastPhoto - 1)
    $stage.animate
      left: -distance
    , 500
    currentBikePhoto = $lastPhoto
  else
    distance = $(window).width() * (currentBikePhoto - 1)
    $stage.animate
      left: -distance
    , 500


$ ->
  # Gallery setup
  $gallery = $('[data-photo-gallery]')
  BikeGallery.install $gallery
  $(window).resize -> BikeGallery.install $gallery


  # Gallery navigation
  $('[data-photo]').on "click", -> nextPhoto()
  $('[data-photo-toggle="next"]').on "click", -> nextPhoto()
  $('[data-photo-toggle="previous"]').on "click", -> previousPhoto()
  $(window).bind "keydown", (event) ->
    switch event.keyCode
      when 37 then previousPhoto()
      when 39 then nextPhoto()

