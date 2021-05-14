$users = qwinsta Administrator ;
$IDs = @() ;

for ($i=1; $i -lt $users.Count;$i++) {
  # using regex to find the IDs
  $temp = [string]($users[$i] | Select-String -pattern "\s\d+\s").Matches ;
  $temp = $temp.Trim() ;
  $IDs += $temp ;
}
return $IDs