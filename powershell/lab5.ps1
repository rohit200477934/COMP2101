param ( [switch]$Disks, [switch]$Network , [switch]$System)

function out-hardwareInfo {
    Write-Output "//// HARDWARE DATA ////"
    Get-CimInstance win32_computersystem | 
    Format-List name, model, Manufacturer, Description
}

function out-osInfo {
    Write-Output "//// OS DATA ////"
    Get-CimInstance win32_operatingsystem | 
    Select-Object Name, Version | 
    Format-List
}
  

function out-processorInfo {
    Write-Output "//// PROCESSOR DATA ////"
    Get-CimInstance win32_processor | 
    Select-Object name, currentclockSpeed, maxclockspeed, numberofcores, 
    @{  n = "L1CacheSize"; e = { 
            switch ($_.L1CacheSize) {
                0 { $valueData = "0" }
                $null { $valueData = "Data Unavailable" }
          ($null -ne $_.L1CacheSize -and $_.L1CacheSize -ne 0 ) { $valueData = $_.L1CacheSize }
            };
            $valueData }
    },
    L2CacheSize,
    L3CacheSize  | Format-List
}
  

function out-ramInfo {
    Write-Output "//// PRIMARY MEMORY DATA ////"
    $totalram = 0
    Get-WmiObject win32_physicalmemory |
    ForEach-Object {
        $eachDIMM = $_ ;
        New-Object -TypeName psObject -Property @{
            Manufacturer = $eachDIMM.Manufacturer
            Description  = $eachDIMM.Description
            "Size(GB)"   = $eachDIMM.Capacity / 1073741824
            Bank         = $eachDIMM.banklabel
            Slot         = $eachDIMM.devicelocator
        }
        $totalram += $eachDIMM.Capacity
    } |
    Format-Table manufacturer, description, "Size(GB)", Bank, Slot -AutoSize
    Write-Output "Total RAM Capacity = $($totalram/1073741824) GB"
}

function out-diskInfo {
    Write-Output "//// DISKDRIVE DATA ////"
    $allDiskDrives = Get-CIMInstance CIM_diskdrive | Where-Object DeviceID -ne $null
    foreach ($disk in $allDiskDrives) {
        $allPartitions = $disk | Get-CIMAssociatedInstance -resultclassname CIM_diskpartition
        foreach ($partition in $allPartitions) {
            $allLogicalDisks = $partition | Get-CIMAssociatedInstance -resultclassname CIM_logicaldisk
            foreach ($logicalDisk in $allLogicalDisks) {
                new-object -typename psobject -property @{
                    Model                   = $disk.Model
                    Manufacturer            = $disk.Manufacturer
                    Location                = $partition.deviceid
                    Drive                   = $logicalDisk.deviceid
                    "Size(GB)"              = [string]($logicalDisk.size / 1073741824 -as [int]) + 'GB'
                    FreeSpace               = [string]($logicalDisk.FreeSpace / 1073741824 -as [int]) + 'GB'
                    "FreeSpace(Percentage)" = ([string]((($logicalDisk.FreeSpace / $logicalDisk.Size) * 100) -as [int]) + '%')
                } | Format-Table -AutoSize
            } 
        }
    }   
}

function out-networkInfo {
    Write-Output "//// NETWORK DATA ////"
    Get-CimInstance win32_networkadapterconfiguration | Where-Object { $_.ipenabled -eq 'True' } | 
    Select-Object Index, Description, 
    @{  n = 'Subnet'; e = {
            switch ($_.Subnet) {
                $null { $valueData = 'Data Unavailable' }
                Default { $valueData = $_.Subnet }
            };
            $valueData
        }
    },
    @{  n = 'DNSDomain'; e = {
            switch ($_.DNSDomain) {
                $null { $valueData = 'Data Unavailable' }
                Default { $valueData = $_.DNSDomain }
            };
            $valueData
        }
    }, 
    DNSServerSearchOrder, IPAddress |
    Format-Table Index, Description, Subnet, DNSDomain, DNSserversearchorder, IPaddress
}


function out-graphicInfo {
    Write-Output "//// GRAPHICS DATA ////"
    $graphicObject = Get-WmiObject win32_videocontroller
    $graphicObject = New-Object -TypeName psObject -Property @{
        Name        = $graphicObject.Name
        Description = $graphicObject.Description
        Resolution  = [string]($graphicObject.CurrentHorizontalResolution) + 'px * ' + [string]($graphicObject.CurrentVerticalResolution) + 'px'
    } 
    
    $graphicObject | Format-List Name, Description, Resolution
}

if ( !($System) -and !($Disks) -and !($Network)) {
  out-hardwareInfo
  out-osInfo
  out-processorInfo
  out-ramInfo
  out-diskInfo
  out-networkInfo
  out-graphicInfo
}

if ($System -eq $true) {
  out-hardwareInfo
  out-osInfo
  out-processorInfo
  out-ramInfo
  out-graphicInfo
}
if ($Disks -eq $true) {
  out-diskInfo
}
if ($Network -eq $true) {
  out-networkInfo
}
