# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **DO NOT** open a public GitHub issue
2. Email: security@secureshield.dev (or create a private issue)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Suggested fix (if any)

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial assessment**: Within 5 business days
- **Fix timeline**: Depends on severity (Critical: 7 days, High: 14 days, Medium: 30 days)

## Cryptographic Guarantees

### Algorithms Used

| Algorithm | Standard | Purpose |
|-----------|----------|---------|
| AES-256-GCM | FIPS 197 | Symmetric authenticated encryption |
| ChaCha20-Poly1305 | RFC 8439 | Symmetric authenticated encryption |
| XChaCha20-Poly1305 | RFC 9038 | Extended-nonce AEAD |
| Camellia-CBC + HMAC | ISO 18033-3 | Symmetric encryption |
| Ed25519 | RFC 8032 | Digital signatures |
| RSA-2048 OAEP/PSS | FIPS 186-5 | Key exchange + signatures |
| ML-KEM-768 | NIST FIPS 203 | Post-quantum key encapsulation |
| ML-DSA-44 | NIST FIPS 204 | Post-quantum signatures |
| Argon2id | RFC 9106 | Password-based key derivation |
| HKDF-SHA256 | RFC 5869 | Key derivation |

### Security Properties

- **Confidentiality**: All encryption uses 256-bit keys (128-bit security minimum)
- **Integrity**: All AEAD ciphers provide authentication; Camellia uses Encrypt-then-MAC
- **Forward Secrecy**: Hybrid cipher uses ephemeral X25519 key agreement
- **Post-Quantum**: ML-KEM-768 and ML-DSA-44 provide quantum resistance (NIST standardized 2024)
- **Constant-Time**: All comparisons use XOR-based constant-time algorithms
- **Memory Safety**: Secrets are wiped from memory via `OPENSSL_cleanse`

### Known Limitations

1. Hybrid cipher loads entire file into memory (not streaming)
2. Anti-debug is OS-specific (best on Windows, partial on Linux)
3. String obfuscation is compiler-dependent (GCC/Clang only for `__builtin_COLUMN`)

## Best Practices

1. Use `SecureString` for all password handling
2. Enable anti-debug in production (`AntiDebug::Enable(AntiDebugLevel::Advanced)`)
3. Use `SecureDelete` for sensitive file cleanup
4. Verify file integrity with SHA-3/BLAKE3 checksums
5. Use multi-layer key derivation for high-security applications

## Audit History

- **v1.0.0** (2025): Initial security audit — 30+ issues identified and resolved
