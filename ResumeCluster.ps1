# Client credentials
# Create an API User in MCM and provide it role Organization Administrator
# Obtain your ClientID and ClientSecretfrom your API User in MCM
# Obtain your Cluster_ID from your Cluster stats in MCM

$clientId = "**************************************.img.frame.nutanix.com"
$clientSecret = "**************************************"
$cluster_id ="**************************************" 


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

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Method Post -Uri $uri -Headers $Headers -ContentType "application/json" -Body $body
