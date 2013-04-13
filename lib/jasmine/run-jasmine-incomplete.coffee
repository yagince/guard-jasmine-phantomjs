system = require 'system'

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
    start = new Date().getTime()
    condition = false
    f = ->
        if (new Date().getTime() - start < timeOutMillis) and not condition
            # If not time-out yet and condition not yet fulfilled
            condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
        else
            if not condition
                # If condition still not fulfilled (timeout but condition is 'false')
                console.log "'waitFor()' timeout"
                phantom.exit 1
            else
                # Condition fulfilled (timeout and/or condition is 'true')
                if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
                clearInterval interval #< Stop this interval
    interval = setInterval f, 100 #< repeat check every 100ms

if system.args.length isnt 2
    console.log 'Usage: run-jasmine.coffee URL'
    phantom.exit 1

page = require('webpage').create()
# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
    console.log msg


page.open system.args[1], (status) ->
    if status isnt 'success'
        console.log 'Unable to access network'
        phantom.exit(1)
    else
        # define utility methods
        page.evaluate ->
            window.COLOR_ES =
                "black":   "\x1b[30m"
                "red":     "\x1b[31m"
                "green":   "\x1b[32m"
                "yellow":  "\x1b[33m"
                "blue":    "\x1b[34m"
                "magenta": "\x1b[35m"
                "cyan":    "\x1b[36m"
                "white":   "\x1b[37m"
                "default": "\x1b[39m"

            window.logWithColor = (log, color) ->
                unless COLOR_ES[color]
                  console.log log
                  return

                console.log "#{COLOR_ES[color]}#{log}#{COLOR_ES['default']}"

        # run jasmine & summarize results
        waitFor ->
            page.evaluate ->
                document.body.querySelector('.symbolSummary .pending') == null
        , ->
            exitCode = page.evaluate ->
                console.log document.body.querySelector('.jasmine_reporter .duration').innerText

                specsCount = document.body.querySelectorAll(".symbolSummary li").length
                failsCount = document.body.querySelectorAll('.symbolSummary li.failed').length

                if failsCount == 0
                    # All specs passed.
                    logWithColor "#{specsCount} examples, 0 failures", 'green'
                    return 0

                # Some specs failed.
                logWithColor "#{specsCount} examples, #{failsCount} failures", 'red'

                console.log "\nFailures:\n"

                list = document.body.querySelectorAll('.results > #details > .specDetail.failed')
                for el, i in list
                    logWithColor "  #{i+1}) #{el.querySelector('.description').innerText}"
                    logWithColor "    #{el.querySelector('.resultMessage.fail').innerText}", 'red'

                    if el.querySelector('.stackTrace')
                        stackTrace = []
                        for line, index in el.querySelector('.stackTrace').innerText.split(/\n/)
                            continue if index == 0 # remove duplicate Error description
                            continue if line.indexOf("__JASMINE_ROOT__") != -1
                            continue if line.indexOf("/lib/jasmine-1.2.0/jasmine.js") != -1
                            logWithColor "    #{line}", 'cyan'

                    console.log("")
                return 1

            phantom.exit(exitCode)

    
