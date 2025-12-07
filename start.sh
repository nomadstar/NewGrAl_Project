#!/bin/sh
# Este script lanzará todos los servicios según compose.yaml
# Compatible con POSIX sh para Railway deployment

set -e  # Exit on error

echo "🚀 Iniciando servicios con Docker Compose"
echo "=========================================="

# Lista de servicios a iniciar en orden de dependencia
# db -> backend -> frontend
SERVICES="db backend frontend"

# Función para iniciar un servicio
start_service() {
    service_name=$1
    echo ""
    echo "📦 Iniciando servicio: $service_name"
    echo "-----------------------------------"
    
    if docker-compose -f compose.yaml up --build -d "$service_name"; then
        echo "✅ Servicio $service_name iniciado correctamente"
    else
        echo "❌ Error al iniciar servicio $service_name"
        echo "⚠️  Revise los logs con: docker-compose logs $service_name"
        exit 1
    fi
}

# Iniciar cada servicio en orden
for service in $SERVICES; do
    start_service "$service"
done

echo ""
echo "=========================================="
echo "✅ Todos los servicios han sido iniciados"
echo ""
echo "📊 Estado de los servicios:"
docker-compose -f compose.yaml ps

echo ""
echo "💡 Para ver los logs en tiempo real, ejecute:"
echo "   docker-compose -f compose.yaml logs -f"
echo ""
echo "🛑 Para detener todos los servicios, ejecute:"
echo "   docker-compose -f compose.yaml down"
