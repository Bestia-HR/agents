# Cybersecurity Protocols - Complete Practical Examples

This document contains complete, working code examples for 10 essential cybersecurity protocols.

---

## Table of Contents
1. [TLS (Transport Layer Security)](#1-tls-transport-layer-security)
2. [HTTPS](#2-https)
3. [IPsec](#3-ipsec)
4. [SSH](#4-ssh)
5. [WPA2/WPA3](#5-wpa2wpa3)
6. [Kerberos](#6-kerberos)
7. [OAuth 2.0](#7-oauth-20)
8. [SFTP](#8-sftp)
9. [DNSSEC](#9-dnssec)
10. [S/MIME](#10-smime)

---

## 1. TLS (Transport Layer Security)

### Overview
TLS provides encrypted communication between client and server. Current version is TLS 1.3 (RFC 8446).

### Complete Python Example

```python
#!/usr/bin/env python3
"""
TLS Client Example
Demonstrates TLS 1.3 handshake, certificate validation, and encrypted communication
"""

import ssl
import socket
import certifi

def create_tls_context():
    """Create a secure TLS context with best practices"""
    # Create default context with secure settings
    context = ssl.create_default_context(
        purpose=ssl.Purpose.SERVER_AUTH,
        cafile=certifi.where()  # Use Mozilla's CA bundle
    )
    
    # Force TLS 1.3 (most secure)
    context.minimum_version = ssl.TLSVersion.TLSv1_3
    
    # Disable older, insecure protocols
    context.options |= ssl.OP_NO_SSLv2
    context.options |= ssl.OP_NO_SSLv3
    context.options |= ssl.OP_NO_TLSv1
    context.options |= ssl.OP_NO_TLSv1_1
    
    # Certificate verification settings
    context.verify_mode = ssl.CERT_REQUIRED
    context.check_hostname = True
    
    return context


def tls_client_example(hostname="www.google.com", port=443):
    """Complete TLS client implementation"""
    
    context = create_tls_context()
    
    print(f"Connecting to {hostname}:{port}...")
    print(f"TLS Minimum Version: {context.minimum_version.name}")
    
    # Create connection
    with socket.create_connection((hostname, port), timeout=10) as sock:
        print(f"TCP connection established")
        
        # Wrap socket with TLS
        with context.wrap_socket(sock, server_hostname=hostname) as tls_sock:
            print(f"TLS handshake completed!")
            print(f"  Protocol: {tls_sock.version()}")
            print(f"  Cipher: {tls_sock.cipher()[0]}")
            print(f"  Cipher bits: {tls_sock.cipher()[2]}")
            
            # Get peer certificate
            cert = tls_sock.getpeercert()
            print(f"  Subject: {cert.get('subject')}")
            print(f"  Issuer: {cert.get('issuer')}")
            print(f"  Not After: {cert.get('notAfter')}")
            
            # Get certificate chain
            chain = tls_sock.get_verified_chain()
            print(f"  Certificate chain length: {len(chain)}")
            
            # Send HTTP request (encrypted)
            http_request = (
                f"GET / HTTP/1.1\r\n"
                f"Host: {hostname}\r\n"
                f"User-Agent: TLS-Test-Client/1.0\r\n"
                f"Accept: */*\r\n"
                f"Connection: close\r\n\r\n"
            ).encode('utf-8')
            
            print(f"\nSending encrypted HTTP request...")
            tls_sock.send(http_request)
            
            # Receive response (decrypted automatically)
            response = b""
            while True:
                data = tls_sock.recv(4096)
                if not data:
                    break
                response += data
            
            print(f"Received {len(response)} bytes (decrypted)")
            print(f"\nFirst 500 chars of response:")
            print(response.decode('utf-8', errors='ignore')[:500])


def tls_server_example(host="localhost", port=8443):
    """TLS Server Example (for testing)"""
    
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    
    # Load server certificate and private key
    # Generate with: openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
    context.load_cert_chain(
        certfile="cert.pem",
        keyfile="key.pem"
    )
    
    # Require client certificate (optional, for mutual TLS)
    # context.verify_mode = ssl.CERT_REQUIRED
    # context.load_verify_locations("ca.pem")
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind((host, port))
        sock.listen(5)
        print(f"TLS Server listening on {host}:{port}")
        
        while True:
            client_sock, addr = sock.accept()
            print(f"Connection from {addr}")
            
            with context.wrap_socket(client_sock, server_side=True) as tls_client:
                print(f"TLS version: {tls_client.version()}")
                data = tls_client.recv(1024)
                print(f"Received: {data.decode()}")
                tls_client.send(b"Hello from TLS Server!")


def mutual_tls_example():
    """Mutual TLS (mTLS) - both client and server authenticate"""
    
    context = ssl.create_default_context()
    context.minimum_version = ssl.TLSVersion.TLSv1_3
    
    # Load client certificate for mutual authentication
    context.load_cert_chain(
        certfile="client_cert.pem",
        keyfile="client_key.pem"
    )
    
    # Verify server certificate
    context.verify_mode = ssl.CERT_REQUIRED
    context.load_verify_locations("ca.pem")
    
    with socket.create_connection(("api.secure.com", 443)) as sock:
        with context.wrap_socket(sock, server_hostname="api.secure.com") as tls_sock:
            # Both sides verified each other's certificates
            print(f"mTLS established: {tls_sock.version()}")
            print(f"Server cert: {tls_sock.getpeercert()}")


if __name__ == "__main__":
    # Generate test certificates first:
    # openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
    
    tls_client_example()
    # tls_server_example()  # Run in separate terminal
```

### Key Concepts
- **Handshake**: Client and server agree on cipher suite, exchange keys, verify certificates
- **Certificate Chain**: Server presents cert → Intermediate CA → Root CA
- **Forward Secrecy**: TLS 1.3 uses ephemeral keys (compromised long-term keys don't decrypt past sessions)

---

## 2. HTTPS (HTTP over TLS)

### Overview
HTTPS is HTTP layered over TLS. Port 443. Automatic certificate validation.

### Complete Python Example

```python
#!/usr/bin/env python3
"""
HTTPS Client Examples
Using requests library with full TLS configuration
"""

import requests
import ssl
import certifi
from requests.adapters import HTTPAdapter
from urllib3.util.ssl_ import create_urllib3_context


class TLSAdapter(HTTPAdapter):
    """Custom adapter for specific TLS configuration"""
    
    def init_poolmanager(self, *args, **kwargs):
        context = create_urllib3_context()
        context.minimum_version = ssl.TLSVersion.TLSv1_3
        kwargs['ssl_context'] = context
        return super().init_poolmanager(*args, **kwargs)


def basic_https_request():
    """Simple HTTPS GET request"""
    
    url = "https://api.github.com"
    
    response = requests.get(url, timeout=10)
    
    print(f"Status Code: {response.status_code}")
    print(f"TLS Version: {response.raw._connection.sock.version()}")
    print(f"Cipher: {response.raw._connection.sock.cipher()}")
    print(f"Headers: {dict(response.headers)}")


def https_with_custom_cert():
    """HTTPS with custom CA certificate"""
    
    # For self-signed certificates or private CAs
    response = requests.get(
        "https://internal.company.com/api",
        verify="/path/to/ca-bundle.crt",  # Custom CA
        timeout=10
    )
    
    # Disable