function Stats
{
    $ip = (/opt/pwnbox/net.sh)
    if (!($ip -like '169.*')) {
        return "[`e[37m$ip`e[32m]"
    } else {
        return ""
    }
}

function prompt
{
    Write-Host ("`e[1;32m┌─" + (Stats) + "`e[32m[`e[37m" + [Environment]::UserName + "`e[32m💀`e[34m" + (hostname) + "`e[32m]─[`e[37m" + (Get-Location) + "`e[32m]")
    Write-Host ("`e[32m└──╼ [`e[34mPS`e[32m]>") -nonewline
    return " "
}
