# SecureShield v1.0.0

Military-grade encryption library for C++20 with post-quantum cryptographic support and Qt6 GUI.

## Features

### Encryption Algorithms
- **AES-256-GCM** — Authenticated encryption (FIPS 197)
- **ChaCha20-Poly1305** — Modern stream cipher (RFC 8439)
- **XChaCha20-Poly1305** — Extended nonce AEAD with AAD support (RFC 9038)
- **Camellia-256-GCM** — Sovereign AEAD cipher (CTR+GHASH, ISO/IEC 18033-3)
- **Hybrid Cipher** — AES-256 + ECC (X25519) + RSA-2048 + ML-KEM-768/ML-DSA-44
- **10-Layer Cascade** — Military-grade multi-algorithm encryption

### Signatures
- **Ed25519** — Elliptic curve signatures (RFC 8032)
- **ML-DSA-44/65/87** — Post-quantum signatures (NIST FIPS 204) via liboqs
- **RSA-PSS-2048** — Traditional signatures (FIPS 186-5)

### Key Derivation
- **Argon2id** — Password-based KDF with configurable memory/iterations/parallelism (RFC 9106)
- **Multi-Layer KDF** — 30-round PBKDF2 + alternating SHA-256/384/512 chain
- **HKDF-SHA256** — Key derivation (RFC 5869)

### Security Features
- **SSF Executables** — Self-extracting encrypted executables with 5 quantum-resistant signatures
- **Secure Deletion** — Multi-pass overwrite with CSPRNG patterns
- **String Obfuscation** — Compile-time encryption with runtime decryption
- **Anti-Debug** — Multi-technique debugger/sandbox/VM detection
- **Zstd Compression** — Built-in compression before encryption

### GUI (Qt6)
- Encrypt/Decrypt widgets with algorithm selection
- Key Management tab (Ed25519, Hybrid Key pairs)
- Benchmark widget (all algorithms)
- SSF Executable Builder
- Settings & Protection dashboard
- Internationalization (FR/EN)

## Requirements

- C++20 compiler (MSVC 2022+, GCC 12+, Clang 15+)
- CMake 3.20+
- OpenSSL 3.0+ (4.0.1 tested)
- libsodium 1.0.18+
- liboqs (post-quantum)
- Zstd 1.5+
- BLAKE3
- Qt6 6.8+ (optional, for GUI)
- Google Test 1.17+ (for tests)

## Quick Start

### Windows (Recommended)

```bat
# Clone and build
git clone https://github.com/secure-shield/SecureShield.git
cd SecureShield
build.bat
```

### CMake Build

```bash
# Configure
cmake -B build -S . -G "Visual Studio 17 2022" -A x64 \
    -DCMAKE_PREFIX_PATH="C:/Qt/6.8.0/msvc2022_64" \
    -DSECURESHIELD_BUILD_GUI=ON \
    -DSECURESHIELD_BUILD_TESTS=ON

# Build
cmake --build build --config Release

# Test
cd build/bin/Release
test_crypto.exe
test_integration.exe
```

### CMake Options

| Option | Default | Description |
|--------|---------|-------------|
| `SECURESHIELD_BUILD_GUI` | ON | Build Qt6 GUI |
| `SECURESHIELD_BUILD_TESTS` | OFF | Build unit tests |
| `SECURESHIELD_FIPS_MODE` | OFF | FIPS-compliant mode (NIST-only algos) |
| `SECURESHIELD_SPECTRE` | OFF | Enable /Qspectre + /CETCOMPAT hardening |
| `SECURESHIELD_USE_LIBOQS` | ON | Enable post-quantum algorithms |

## Usage Examples

### AES-256-GCM Encryption
```cpp
#include "crypto/AESGCM.hpp"
#include "crypto/Random.hpp"

using namespace ss::crypto;

auto key = AES256GCM::GenerateKey();
std::vector<uint8_t> plaintext = {'H', 'e', 'l', 'l', 'o'};

auto encrypted = AES256GCM::Encrypt(plaintext, key);
auto decrypted = AES256GCM::Decrypt(encrypted, key);
// decrypted == plaintext
```

### Camellia-256-GCM with AAD
```cpp
#include "crypto/Camellia.hpp"

auto key = CamelliaGCM::GenerateKey();
std::vector<uint8_t> plaintext = {'S', 'e', 'c', 'u', 'r', 'e'};
std::vector<uint8_t> aad = {'f', 'i', 'l', 'e', 'n', 'a', 'm', 'e'};

auto encrypted = CamelliaGCM::Encrypt(plaintext, key, aad);
auto decrypted = CamelliaGCM::Decrypt(encrypted, key, aad);
```

### Password-Based Encryption
```cpp
#include "crypto/KeyDerivation.hpp"
#include "crypto/AESGCM.hpp"

using namespace ss::crypto;

KeyDerivation::Salt salt;
SecureRandom::Fill(salt.data(), salt.size());

KeyDerivation::Argon2Config config;
config.iterations = 3;
config.memory_kb = 65536;
config.parallelism = 4;

auto derivedKey = KeyDerivation::Argon2id("my_password", salt, config);
```

### Self-Extracting Executable (.exe + .bat)
```cpp
#include "crypto/SecureExecutable.hpp"

// Create self-extracting executable
SecureExecutable::CreateExecutable("secret.bin", "secret.exe", password);
```

## Project Structure

```
SecureShield/
├── include/              # Public headers
│   ├── core/             # Engine, Config, Logger
│   ├── crypto/           # Encryption algorithms
│   │   └── postquantum/  # ML-KEM, ML-DSA
│   ├── hash/             # Hash functions (SHA-3, BLAKE3)
│   ├── io/               # File operations, SecureDelete
│   ├── obfuscation/      # String encryption
│   ├── protection/       # AntiDebug, Integrity
│   ├── utils/            # Base64, Timer
│   └── compression/      # Zstd compression
├── src/                  # Implementation files
├── gui/                  # Qt6 GUI application
│   ├── stub/             # SSF self-extracting stub (C)
│   ├── widgets/          # Encrypt, Decrypt, Benchmark, KeyMgmt
│   └── dialogs/          # About, Settings
├── tests/                # Unit tests (GTest)
│   ├── test_crypto.cpp   # Cipher tests
│   ├── test_integration.cpp # Integration tests
│   ├── test_hash.cpp     # Hash tests
│   ├── test_io.cpp       # I/O tests
│   └── test_liboqs.cpp   # Post-quantum tests
├── build.bat             # Windows one-click build
├── CMakeLists.txt        # Build system
├── README.md
├── SECURITY.md
└── API.md
```

## Testing

```bash
# 33 tests across crypto, integration, hash, I/O, and post-quantum
cmake -B build -S . -DSECURESHIELD_BUILD_TESTS=ON
cmake --build build --config Release
build/bin/Release/test_crypto.exe
build/bin/Release/test_integration.exe
```

## Security Considerations

- All cryptographic operations use constant-time comparisons
- Memory containing secrets is wiped via `OPENSSL_cleanse` / `SecureZeroMemory`
- RAII auto-wipe destructors on all key pairs (HybridKeyPair, Ed25519::KeyPair, RSAPssKeyPair)
- Password strings should use `SecureString` class for automatic wiping
- Anti-debug protection can be enabled for runtime security
- File encryption uses authenticated encryption (AEAD) — tampering is detected
- MSVC hardening: `/GS`, `/sdl`, `/DYNAMICBASE`, `/NXCOMPAT`
- Optional: `/Qspectre`, `/CETCOMPAT`, `/guard:cf` via `-DSECURESHIELD_SPECTRE=ON`

## License

MIT License — see [LICENSE](LICENSE) for details.
