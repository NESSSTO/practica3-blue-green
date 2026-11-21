#!/bin/bash
echo "=== [ROLLBACK] Revirtiendo tráfico a ambiente estable BLUE (v1.0.0) ==="
cat << 'CONF' > ~/project/nginx/conf.d/upstream.conf
upstream tienda_backend {
    server nestotech-blue:80;
}
CONF
docker exec nestotech-gateway nginx -t
docker exec nestotech-gateway nginx -s reload
echo "Rollback completado:"
curl -s http://localhost/api/status.json
echo ""
