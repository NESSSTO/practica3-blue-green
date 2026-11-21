#!/bin/bash
echo "=== [1/4] Verificando salud de ambiente GREEN (v2.0.0) ==="
docker exec nestotech-gateway wget -qO- http://nestotech-green/api/status.json || { echo "Error: Green no responde"; exit 1; }
echo ""
echo "=== [2/4] Redirigiendo upstream hacia GREEN ==="
cat << 'CONF' > ~/project/nginx/conf.d/upstream.conf
upstream tienda_backend {
    server nestotech-green:80;
}
CONF
echo "=== [3/4] Validando sintaxis Nginx ==="
docker exec nestotech-gateway nginx -t
echo "=== [4/4] Aplicando recarga en caliente (Zero-Downtime) ==="
docker exec nestotech-gateway nginx -s reload
echo "Promoción completada:"
curl -s http://localhost/api/status.json
echo ""
