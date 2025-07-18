Write-Host "=== Construyendo imagen Docker ===" -ForegroundColor Green
docker build -t prexamen-app .

Write-Host "=== Deteniendo contenedor anterior si existe ===" -ForegroundColor Yellow
docker stop prexamen-container 2>$null
docker rm prexamen-container 2>$null

Write-Host "=== Ejecutando contenedor ===" -ForegroundColor Green
docker run -d `
  --name prexamen-container `
  -p 3002:3002 `
  -p 3306:3306 `
  prexamen-app

Write-Host "=== Esperando a que el contenedor esté listo ===" -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "=== Verificando logs del contenedor ===" -ForegroundColor Cyan
docker logs prexamen-container

Write-Host "=== Contenedor ejecutándose ===" -ForegroundColor Green
Write-Host "Aplicación disponible en: http://localhost:3002" -ForegroundColor White
Write-Host "Base de datos MySQL disponible en: localhost:3306" -ForegroundColor White
Write-Host ""
Write-Host "Para ver logs en tiempo real: docker logs -f prexamen-container" -ForegroundColor Gray
Write-Host "Para acceder al contenedor: docker exec -it prexamen-container bash" -ForegroundColor Gray
