Function Process-Handler {
   param(
      [Parameter(Position=0,Mandatory=$true)][CloudNative.CloudEvents.CloudEvent]$CloudEvent
   )

# Form cloudEventData object and output to console for debugging
$cloudEventData = $cloudEvent | Read-CloudEventJsonData -ErrorAction SilentlyContinue -Depth 10
if($cloudEventData -eq $null) {
   $cloudEventData = $cloudEvent | Read-CloudEventData
   }
Write-Host "Full contents of CloudEventData`n $(${cloudEventData} | ConvertTo-Json)`n"

# Perform onward action

## vROps REST API documentation https://code.vmware.com/apis/364/vrealize-operations

## Hardcoded variables to move to secrets later
$vropsFqdn = "vrops.cork.local"
$vropsPassword = "VMware1!"
## Form unauthorized headers payload
$headers = @{
   "Content-Type" = "application/json";
   "Accept" = "application/json"
   }

## Bypass certificate issues
add-type @"
   using System.Net;
   using System.Security.Cryptography.X509Certificates;
   public class TrustAllCertsPolicy : ICertificatePolicy {
       public bool CheckValidationResult(
           ServicePoint srvPoint, X509Certificate certificate,
           WebRequest request, int certificateProblem) {
           return true;
       }
   }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

## Acquire bearer token
$uri = "https://" $vropsFqdn "/suite-api/api/auth/token/acquire"

$basicAuthBody = @{
    username = "admin";
    password = $vropsPassword ;
    }

$basicAuthBodyJson = $basicAuthBody | ConvertTo-Json -Depth 5

Write-Host "Acquiring bearer token..."
$bearer = Invoke-WebRequest -Uri $uri -Method POST -Headers $headers -Body $basicAuthBodyJson
Write-Host "Bearer token is " $bearer

## Form authorized headers payload
$authedHeaders = @{
   "Content-Type" = "application/json";
   "Accept"  = "application/json";
   "Authentication" = "vRealizeOpsToken " $bearer
   }

Write-Host "Formed authentication headers are " $authedHeaders

## Get host ResourceID
$uri = "https://" $vropsFqdn "/api/adapterkinds/VMWARE/resourcekinds/HostSystem/resources?identifiers[name]=" $host
Write-Host "Acquiring host ResourceID..."
$resource = Invoke-WebRequest -Uri $uri -Method GET -Headers $authedHeaders
Write-Host "ResourceID of host is " $resource.identifier

## Mark host as maintenance mode
$uri = "https://" $vropsFqdn "/api/resources/" $resource.identifier "/maintained"
Write-Host "Marking host as vROps maintenance mode..."
Invoke-WebRequest -Uri $uri -Method PUT -Headers $authedHeaders
}
