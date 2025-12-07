#!/bin/bash

# Test para verificar si el parsing de horarios_prohibidos funciona correctamente

ENDPOINT="http://localhost:8080/rutacritica/run"

# Crear payload con horarios_prohibidos (todas las franjas de 08:30-09:50)
cat > /tmp/test_request_horarios.json << 'EOF'
{
  "email": "test@example.com",
  "ramos_pasados": ["CBM1000", "CBM1001", "CBQ1000"],
  "ramos_prioritarios": [],
  "horarios_preferidos": [],
  "malla": "MC2020.xlsx",
  "sheet": "Malla 2020",
  "horarios_prohibidos": [
    "LU 08:30 - 09:50",
    "MA 08:30 - 09:50",
    "MI 08:30 - 09:50",
    "JU 08:30 - 09:50",
    "VI 08:30 - 09:50"
  ]
}
EOF

echo "📝 Enviando request CON horarios_prohibidos..."
echo "================================================="
curl -s -X POST \
  -H 'Content-Type: application/json' \
  -d @/tmp/test_request_horarios.json \
  "$ENDPOINT" | jq '.' 2>&1 | head -50

echo ""
echo ""
echo "🔍 Esperando para ver logs del backend en stderr..."
sleep 2

echo ""
echo "✅ Test completado. Revisa los logs del backend para ver los debug messages"
