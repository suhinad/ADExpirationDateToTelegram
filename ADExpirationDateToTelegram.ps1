#Change 'chat_id' and 'token'
$chat_id = '1234567890'
$token='1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ'
$warnDays = (get-date).adddays(2)
$2Day = get-date
$Text = 'Внимание! Скоро истекает срок действия пароля!'
$Users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties msDS-UserPasswordExpiryTimeComputed, EmailAddress, Name | select Name, @{Name ="ExpirationDate";Expression= {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, enabled | Sort-Object expirationdate
foreach ($user in $users) {
if ($user.enabled){
if (($user.ExpirationDate -lt $warnDays) -and ($2Day -lt $user.ExpirationDate) ) {
$lastdays = ( $user.ExpirationDate -$2Day).days
$N = $user.name
$Text = $Text + '%0A' + $N + ' - ' + 'осталось ' + $lastdays + 'д.'
}
}
}
$Text = $Text + '%0A' + '%0A' +'Не забудьте заранее сменить Ваш пароль. Для этого находясь на удаленной рабочей станции нажмите комбинацию клавиш CTRL-ALT-END (не DEL, а именно END) и выберите пункт ИЗМЕНИТЬ ПАРОЛЬ.%0AНовый пароль должен быть уникальным, не совпадать с логином и раньше не использоватся, а также иметь большие маленькие буквы и цифры.%0AЕсли у вас есть вопросы, обратитесь в службу Тех. Поддержки.'
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")
(Invoke-WebRequest -UseBasicParsing -Uri https://api.telegram.org/).Content

curl https://api.telegram.org/bot$token/sendMessage?chat_id=$chat_id"&"text=$Text