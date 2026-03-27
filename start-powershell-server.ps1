Write-Host "Starting PowerShell server..."
Write-Host "Opening demo pages..."
Start-Process "http://localhost:8080/index-demo.html"
Start-Process "http://localhost:8080/admin-demo.html"
Write-Host "Server is running at http://localhost:8080"
Write-Host "Press Ctrl+C to stop the server"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Server started. Listening on http://localhost:8080"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $url = $request.Url.LocalPath
    $filePath = Join-Path $PSScriptRoot $url.Substring(1)
    
    if (Test-Path $filePath -PathType Leaf) {
        $content = [IO.File]::ReadAllBytes($filePath)
        $response.ContentType = "text/html"
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
        $response.Close()
        continue
    }
    
    $response.Close()
}

$listener.Stop()
