param(
    [string]$user
)

$users = qwinsta $user ;
return $users;