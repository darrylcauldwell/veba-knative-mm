Function Process-Handler {
   param(
      [Parameter(Position=0,Mandatory=$true)][CloudNative.CloudEvents.CloudEvent]$CloudEvent
   )

# Form cloudEventData object and output to console
$cloudEventData = $cloudEvent | Read-CloudEventJsonData -ErrorAction SilentlyContinue -Depth 10
if($cloudEventData -eq $null) {
   $cloudEventData = $cloudEvent | Read-CloudEventData
   }
Write-Host "Full contents of CloudEventData`n $(${cloudEventData} | ConvertTo-Json)`n"

# Business logic
Write-Host "Host " $cloudEventData.Host.Name " has entered vCenter Maintenance Mode"
Write-Host "V3"
}
