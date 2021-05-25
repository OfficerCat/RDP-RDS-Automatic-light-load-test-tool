
Start-Process -FilePath "notepad"
Start-Sleep 2
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate("Unbennant - Editor")
Start-Sleep 1
$wshell.SendKeys('Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.')
Start-Sleep 1
$wshell.SendKeys('~')
Start-Sleep 1
$wshell.SendKeys('it amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,')
Start-Sleep 1
Start-Process "https://youtu.be/po-0n1BKW2w"
Start-Process "https://www.microsoft.com/de-de"
Start-Sleep 20
$wshell.AppActivate('Unbennant - Editor')
Start-Sleep 1
$wshell.SendKeys('Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.')
Start-Sleep 1
$wshell.SendKeys('~')
Start-Sleep 1
$wshell.SendKeys('it amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,')
Start-Sleep 1
Start-Process "https://www.microsoft.com/de-de"
Start-Sleep 30

shutdown /l /f

