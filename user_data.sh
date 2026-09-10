#!/bin/bash
set -euo pipefail

dnf install -y nginx

TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AZ=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)
IID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

cat > /usr/share/nginx/html/index.html <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${project_name}</title>
  <style>
    body { font-family: system-ui, sans-serif; margin: 0; display: grid;
           place-items: center; min-height: 100vh; background: #0f172a; color: #e2e8f0; }
    .card { background: #1e293b; padding: 2.5rem 3rem; border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,.4); text-align: center; max-width: 90vw; }
    h1 { margin: 0 0 .5rem; }
    code { background: #334155; padding: .15rem .4rem; border-radius: 4px; word-break: break-all; }
    p { margin: .4rem 0; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hello from ${project_name} &#128075;</h1>
    <p>Served by nginx on Amazon Linux 2023</p>
    <p>Instance: <code>$IID</code></p>
    <p>Availability zone: <code>$AZ</code></p>
    <p>Route 53 name: <code>${fqdn}</code></p>
    <p>Public DNS (sslip.io): <code>${sslip_host}</code></p>
    <p>Deployed with Terraform</p>
  </div>
</body>
</html>
HTML

systemctl enable --now nginx
