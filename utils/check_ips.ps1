for ($i=100; $i -le 254; $i++) { # 1 - 254
    $ip = "172.30.108.$i"  # 192.168.0.$i
    $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet
    if ($pingResult) {
        Write-Host "$ip en uso (Ocupada)"
    } else {
        Write-Host "$ip libre (Disponible)"
    }
}

# ---

# nmap -sn 192.168.0.1-254
# nmap -sn 172.30.105.1-254

# .\utils\check_ips.ps1
