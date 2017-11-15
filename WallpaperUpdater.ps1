<#

# .SYNOPSIS  
    apod-wallpaper
    
# .DESCRIPTION  
    Get the NASA astronmical picture of the day (apod - http://apod.nasa.gov/) as your desktop wallpaper.
    You might use it with an automated task. The Script creates a folder in the execution path.
    In that folder all pictures are saved with date and description.

# .NOTES  
    File Name  : Get-APODWallpaper.ps1  
    Author     : Yanik Bieri - yanikbieri.ch 
    Requires   : PowerShell V4

# .LINK 
    http://yanikbieri.ch/home/category/apod-wallpaper/
	
#>

Function Get-APODImage($date, $ImagePath){
                
    $year = $date.ToString("yy")
    $month = $date.ToString("MM")
    $day = $date.ToString("dd")
	
    $webClient = New-Object System.Net.WebClient
    $webClient.UseDefaultCredentials = $true
    $webClient.Proxy.Credentials = $webClient.Credentials
    $htmlRet = $webClient.DownloadString("https://apod.nasa.gov/apod/ap$($year)$($month)$($day).html")

    $htmlRet = $htmlRet -split "`n"
    
    $picLine = $htmlRet | ? { $_ -like '*<img src="image/*' }
    $picDescr = $htmlRet | ? { $_ -like '*<title> APOD:*' }

    $imagePathPart = $picLine -replace '<img src="' -replace '"'
    $imageDescr = $picDescr.Substring($picDescr.IndexOf("-")+2) -replace " ","_"
    $validateRegex = "[{0}]" -f ([Regex]::Escape( [System.IO.Path]::GetInvalidFileNameChars() -join '' ))
    $imageDescr = $imageDescr -replace "$validateRegex","_"
    
    $imageSavePath = "$($ImagePath)\APOD_$(Get-Date -Format "yyyy_MM_dd")_$($imageDescr).jpg"
	
    $webClient.DownloadFile("https://apod.nasa.gov/apod/$($imagePathPart)", $imageSavePath)
	
    return $imageSavePath
}

Function Set-Wallpaper{
    
    param
    (
        [Parameter(Mandatory=$true)]$Path,
        [ValidateSet('Center', 'Stretch')]$Style = 'Center'
    )
    
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        using Microsoft.Win32;
        namespace Wallpaper
        {
            public enum Style : int
            {
                Center, Stretch
            }
        public class Setter
        {
            public const int SetDesktopWallpaper = 20;
            public const int UpdateIniFile = 0x01;
            public const int SendWinIniChange = 0x02;
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
            private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
            public static void SetWallpaper ( string path, Wallpaper.Style style )
            {
                SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
                RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
                switch( style )
                {
                    case Style.Stretch :
                    key.SetValue(@"WallpaperStyle", "2") ; 
                    key.SetValue(@"TileWallpaper", "0") ;
                    break;
                    case Style.Center :
                    key.SetValue(@"WallpaperStyle", "1") ; 
                    key.SetValue(@"TileWallpaper", "0") ; 
                    break;
                }
            
                key.Close();
            
            }
        }
    }
"@
    
    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )
}



Function Main(){
    $executionPath = "$(Split-Path -parent $PSCommandPath)"
    $logPath = "$($executionPath)\APOD\logs"
    $imagePath = "$($executionPath)\APOD\image"
    
    If(!(Test-Path  $imagePath ))
    {
        New-Item -ItemType Directory $imagePath | Out-Null
    }

    If(!(Test-Path $logPath ))
    {
        New-Item -ItemType Directory $logPath  | Out-Null
    }
    
    $path = $(Get-APODImage $(Get-Date) $($imagePath))
	
	Set-Wallpaper -Path $path	
}

Main
