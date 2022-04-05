get-ciminstance win32_networkadapterconfiguration |
where-object { $_.IPEnabled -eq "True" } |
format-table Index ,
Description, 
DNSDomain, 
DNSServerSearchOrder,
IPAddress -AutoSize
