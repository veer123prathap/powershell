$counters = @(
   '\PhysicalDisk(**)\% Idle Time'
   '\PhysicalDisk(**)\Avg. Disk sec/Read'
   '\PhysicalDisk(**)\Avg. Disk sec/Write'
   '\PhysicalDisk(**)\Current Disk Queue Length'
   '\Memory\Available Bytes'
   '\Memory\Pages/sec'
 )
 $out='C:\Program Files\wmi_exporter\textfile_inputs\test1.prom'

function Metric-creator{
    Set-Content -Path $out -Encoding Ascii -NoNewline -Value ""
    Add-Content -Path $out -Encoding Ascii -NoNewline -Value "# HELP wmi custom metrics.`n"
    Add-Content -Path $out -Encoding Ascii -NoNewline -Value "# TYPE test_beta_bytes gauge`n"
foreach ($k in $samples) {
$a=$k.Category
$b=$k.Counter
$c=$k.Value
  Add-Content -Path $out -Encoding Ascii -NoNewline -Value "wmi_custom_collector{category=`"$($a)`", counter=`"$($b)`"} $( $c )`n"
}

    }

$samples = foreach ($counter in $counters) {
   $sample = (Get-Counter -Counter $counter).CounterSamples
   [pscustomobject]@{
     Category = $sample.Path.Split('\')[3]
     Counter = $sample.Path.Split('\')[4]
     Instance = $sample.InstanceName
     Value = $sample.CookedValue[0]
   }
   
 }
 
 Metric-creator
