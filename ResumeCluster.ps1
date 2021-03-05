# Client credentials
#client_id from the user from the clusters portal
#User created in clusters portal as Organization Administrator
$clientId = "***************************.img.frame.nutanix.com"
$clientSecret = "***********************************"
$cluster_id ="***************************************" 


$timestamp = [int](Get-Date -UFormat %s)
$toSign = "$timestamp$clientId"


$hmac = new-object System.Security.Cryptography.HMACSHA256
$hmac.Key = [Text.Encoding]::ASCII.GetBytes($clientSecret)
$signature = $hmac.ComputeHash([Text.Encoding]::ASCII.GetBytes($toSign))
$signature = [System.BitConverter]::ToString($signature)

$signature = [System.Text.RegularExpressions.Regex]::Replace($signature, "-", "").ToLower()

$stringTime = [string]($timestamp)

$headers = @{}
$headers.Add("X-Frame-ClientId", $clientId)
$headers.Add("X-Frame-Timestamp", $stringTime)
$headers.Add("X-Frame-Signature", $signature)

$domain = "https://api-gateway-prod.frame.nutanix.com"
$uri = $domain + "/v1/clusters/" + $cluster_id + "/resume_cluster"
$body = ""

Invoke-WebRequest -Method Post -Uri $uri -Headers $Headers -ContentType "application/json" -Body $body