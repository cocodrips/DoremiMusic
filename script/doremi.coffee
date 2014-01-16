$ ->
  @noteLength = 400
  @context = new webkitAudioContext()

  $("#send-text").on 'click', ->
    text = $("#contents").val()
    changeText(text)

changeText = (text)->
  long = new RegExp("[-ー]")
  i = 0
  len = 0
  while i < text.length
    cnt = 1
    c = text[i]
    if i != text.length - 1 && text[i] + text[i+1] == ( "ふぁ" or "ファ" )
      c = text[i] + text[i+1]
      i++
    while i < text.length - 1 && text[i + 1].match(long)
      cnt++
      i++
    setTimeout(createNote,  (len) * noteLength, context, char2note(c), cnt)
    i++
    len += cnt


char2note = (c)->
  patterns = {
    "[どド]": 523,
    "[れレ]": 587
    "[みミ]": 659,
    "[ふぁ|ファ]": 698,
    "[そソ]": 783,
    "[らラ]": 880,
    "[しシ]": 988,
    "[とト]": 1044,
  }
  for key in Object.keys(patterns)
    re = new RegExp(key)
    return patterns[key] if c.match(re)
  return -1

createNote = (context, v, cnt)->
  return 0 if v < 0
  oscillator = context.createOscillator()
  oscillator.type = 0
  oscillator.frequency.value = v
  oscillator.connect(context.destination)
  oscillator.noteOn(0)
  setTimeout(stopRing, noteLength * cnt, oscillator)

stopRing = (oscillator)->
  oscillator.noteOff(0);
