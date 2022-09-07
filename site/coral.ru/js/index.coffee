window.ASAP = (->
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

log = () ->
    if window.console and window.DEBUG
        console.group? window.DEBUG
        if arguments.length == 1 and Array.isArray(arguments[0]) and console.table
            console.table.apply window, arguments
        else
            console.log.apply window, arguments
        console.groupEnd?()
trouble = () ->
    if window.console
        console.group? window.DEBUG if window.DEBUG
        console.warn?.apply window, arguments
        console.groupEnd?() if window.DEBUG

window.preload = (what, fn) ->
    what = [what] unless  Array.isArray(what)
    $.when.apply($, ($.ajax(lib, dataType: 'script', cache: true) for lib in what)).done -> fn?()

window.queryParam = queryParam = (p, nocase) ->
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

String::zeroPad = (len, c) ->
    s = ''
    c ||= '0'
    len ||= 2
    len -= @length
    s += c while s.length < len
    s + @
Number::zeroPad = (len, c) -> String(@).zeroPad len, c

window.DEBUG = 'APP NAME'

ASAP ->

    $('body .subpage-search-bg > .background').append $('#_intro_markup').html()

    responsiveHandler = (query, match_handler, unmatch_handler) ->
        layout = matchMedia query
        layout.addEventListener 'change', (e) ->
            if e.matches then match_handler() else unmatch_handler()
        if layout.matches then match_handler() else unmatch_handler()
        layout

    responsiveHandler '(max-width:768px)',
        ->
            $player_el = $('.hidden-on-desktop[data-vimeo-id]')
            p = new Vimeo.Player $player_el.get(0),
                id: $player_el.attr('data-vimeo-id')
                background: 1
                playsinline: 1
                autopause: 0
                title: 0
                byline: 0
                portrait: 0
            p.on 'play', ->
                $player_el.addClass 'playback'
        ->
            $player_el = $('.hidden-on-mobile[data-vimeo-id]')
            p = new Vimeo.Player $player_el.get(0),
                id: $player_el.attr('data-vimeo-id')
                background: 1
                playsinline: 1
                autopause: 0
                title: 0
                byline: 0
                portrait: 0
            p.on 'play', ->
                $player_el.addClass 'playback'
