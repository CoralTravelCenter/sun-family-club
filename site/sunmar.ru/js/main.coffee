window.ASAP ||= (->
    fns = []
    callall = () ->
        f() while f = fns.shift()
    if document.addEventListener
        document.addEventListener 'DOMContentLoaded', callall, false
        window.addEventListener 'load', callall, false
    else if document.attachEvent
        document.attachEvent 'onreadystatechange', callall
        window.attachEvent 'onload', callall
    (fn) ->
        fns.push fn
        callall() if document.readyState is 'complete'
)()

window.log ||= () ->
    if window.console and window.DEBUG
        console.group? window.DEBUG
        if arguments.length == 1 and Array.isArray(arguments[0]) and console.table
            console.table.apply window, arguments
        else
            console.log.apply window, arguments
        console.groupEnd?()
window.trouble ||= () ->
    if window.console
        console.group? window.DEBUG if window.DEBUG
        console.warn?.apply window, arguments
        console.groupEnd?() if window.DEBUG

window.preload ||= (what, fn) ->
    what = [what] unless  Array.isArray(what)
    $.when.apply($, ($.ajax(lib, dataType: 'script', cache: true) for lib in what)).done -> fn?()

window.queryParam ||= queryParam = (p, nocase) ->
    params_kv = location.search.substr(1).split('&')
    params = {}
    params_kv.forEach (kv) -> k_v = kv.split('='); params[k_v[0]] = k_v[1] or ''
    if p
        if nocase
            return decodeURIComponent(params[k]) for k of params when k.toUpperCase() == p.toUpperCase()
            return undefined
        else
            return decodeURIComponent params[p]
    params

window.DEBUG = 'APP NAME'

ASAP ->

    $('[data-popin]').on 'click', ->
        $($(this).attr('data-popin')).addClass 'shown'

    $('.popin .dismiss').on 'click', ->
        $(this).closest('.shown').removeClass 'shown'

    $('.programs .buttonlike').on 'click', ->
        $this = $(this)
        $this.addClass('red').siblings('.red').removeClass('red')
        setTimeout ->
            $('.flickity-enabled').flickity('resize')
        , 10

    preload 'https://cdnjs.cloudflare.com/ajax/libs/flickity/2.3.0/flickity.pkgd.min.js', ->
        $('.opt-slider, .ultra-slider').flickity
            cellSelector: '.slide'
            cellAlight: 'left'
            groupCells: yes
            contain: yes
            prevNextButtons: yes
            pageDots: no
        setTimeout ->
            $('.flickity-enabled').flickity('resize')
        , 100
