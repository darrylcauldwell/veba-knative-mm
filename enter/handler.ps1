Function Process-Handler {
   param(
      [Parameter(Position=0,Mandatory=)][CloudNative.CloudEvents.CloudEvent]$CloudEvent
   )

# Form cloudEventData object and output to console
$cloudEventData = $cloudEvent | Read-CloudEventJsonData -ErrorAction SilentlyContinue -Depth 10
if($cloudEventData -eq $null) {
   $cloudEventData = $cloudEvent | Read-CloudEventData
   }
Write-Host "Full contents of CloudEventDatan"

# Business logic
Write-Host "Host " + $cloudEventData.Host.Name + " has entered vCenter Maintenance Mode"
}
