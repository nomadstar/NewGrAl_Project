#!/bin/sh
# Este script lanzará todos los servicios según compose.yaml
# Compatible con Railway deployment usando docker compose v2

set -e  # Exit on error

echo "🚀 Iniciando servicios con Docker Compose"
echo "=========================================="

# Verificar que docker compose está disponible
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado"
    exit 1
fi

# Determinar si usamos 'docker compose' (v2) o 'docker-compose' (v1)
COMPOSE_CMD="docker compose"
if ! $COMPOSE_CMD version &> /dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Neither 'docker compose' nor 'docker-compose' found"
        exit 1
    fi
fi

echo "📌 Usando comando: $COMPOSE_CMD"
echo ""

# Iniciar todos los servicios con sus dependencias
# El orden se maneja automáticamente según depends_on en compose.yaml
echo "📦 Construyendo e iniciando todos los servicios..."
echo "-----------------------------------"

if $COMPOSE_CMD -f compose.yaml up --build -d; then
    echo "✅ Todos los servicios iniciados correctamente"
else
    echo "❌ Error al iniciar los servicios"
    echo "⚠️  Revise los logs con: $COMPOSE_CMD logs"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ Todos los servicios han sido iniciados"
echo ""
echo "📊 Estado de los servicios:"
$COMPOSE_CMD -f compose.yaml ps

echo ""
echo "💡 Para ver los logs en tiempo real, ejecute:"
echo "   $COMPOSE_CMD -f compose.yaml logs -f"
echo ""
echo "💡 Para ver logs de un servicio específico, ejecute:"
echo "   $COMPOSE_CMD -f compose.yaml logs -f [servicio]"
echo "   Servicios: db, backend, frontend"
echo ""
echo "🛑 Para detener todos los servicios, ejecute:"
echo "   $COMPOSE_CMD -f compose.yaml down"
