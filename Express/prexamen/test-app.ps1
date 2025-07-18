Write-Host "=== Probando la aplicación ===" -ForegroundColor Green

Write-Host "1. Probando endpoint /alumnos..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3002/alumnos" -TimeoutSec 10
    Write-Host "✅ /alumnos funciona correctamente" -ForegroundColor Green
    Write-Host "   Status: $($response.StatusCode)" -ForegroundColor White
    Write-Host "   Respuesta: $($response.Content.Length) caracteres" -ForegroundColor White
} catch {
    Write-Host "❌ Error en /alumnos: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n2. Probando endpoint /alumnos/García..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3002/alumnos/García" -TimeoutSec 10
    Write-Host "✅ /alumnos/García funciona correctamente" -ForegroundColor Green
    Write-Host "   Status: $($response.StatusCode)" -ForegroundColor White
    Write-Host "   Respuesta: $($response.Content.Length) caracteres" -ForegroundColor White
} catch {
    Write-Host "❌ Error en /alumnos/García: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n3. Probando endpoint /profesor/Infante/Juan..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3002/profesor/Infante/Juan" -TimeoutSec 10
    Write-Host "✅ /profesor/Infante/Juan funciona correctamente" -ForegroundColor Green
    Write-Host "   Status: $($response.StatusCode)" -ForegroundColor White
    Write-Host "   Respuesta: $($response.Content.Length) caracteres" -ForegroundColor White
} catch {
    Write-Host "❌ Error en /profesor/Infante/Juan: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n4. Probando página principal..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3002/" -TimeoutSec 10
    Write-Host "✅ Página principal funciona correctamente" -ForegroundColor Green
    Write-Host "   Status: $($response.StatusCode)" -ForegroundColor White
    Write-Host "   Respuesta: $($response.Content.Length) caracteres" -ForegroundColor White
} catch {
    Write-Host "❌ Error en página principal: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Resumen ===" -ForegroundColor Green
Write-Host "Aplicación disponible en: http://localhost:3002" -ForegroundColor White
Write-Host "Base de datos MySQL disponible en: localhost:3306" -ForegroundColor White
Write-Host "`nPara ver logs en tiempo real: docker logs -f prexamen-container" -ForegroundColor Gray
