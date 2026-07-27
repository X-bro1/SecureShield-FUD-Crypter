# SecureShield v1.0.0

Military-grade encryption library for C++20 with post-quantum cryptographic support.

## Features

- **AES-256-GCM** — Authenticated encryption (FIPS 197)
- **ChaCha20-Poly1305** — Modern stream cipher (RFC 8439)
- **XChaCha20-Poly1305** — Extended nonce variant (RFC 9038)
- **Camellia-CBC** — Japanese standard cipher (ISO/IEC 18033-3)
- **Hybrid Cipher** — AES-256 + ECC (X25519) + RSA-2048 + ML-KEM-768/ML-DSA-44
- **Ed25519** — Elliptic curve signatures (RFC 8032)
- **Post-Quantum** — ML-KEM-768 (NIST FIPS 203) + ML-DSA-44 (NIST FIPS 204) via liboqs
- **Key Derivation** — Argon2id with multi-layer support (up to 10 layers)
- **Secure Deletion** — Multi-pass overwrite with CSPRNG patterns
- **String Obfuscation** — Compile-time encryption with runtime decryption
- **Anti-Debug** — Multi-technique debugger/sandbox/VM detection

## Requirements

- C++20 compiler (MSVC 2022+, GCC 12+, Clang 15+)
- CMake 3.20+
- OpenSSL 3.0+
- libsodium 1.0.18+
- liboqs (post-quantum)
- Zstd 1.5+
- BLAKE3
- Qt6 (optional, for GUI)

## Quick Start

### Using vcpkg (Recommended)

```bash
# Clone the repository
git clone https://github.com/secure-shield/SecureShield.git
cd SecureShield

# Install dependencies
vcpkg install

# Build
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=[vcpkg root]/scripts/buildsystems/vcpkg.cmake
cmake --build build --config Release
```

### Manual Build

```bash
# Install dependencies via your package manager, then:
cmake -B build -S . -DSECURESHIELD_BUILD_GUI=OFF
cmake --build build --config Release
```

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

### Password-Based Encryption
```cpp
#include "crypto/KeyDerivation.hpp"
#include "crypto/AESGCM.hpp"

using namespace ss::crypto;

KeyDerivation::Salt salt;
SecureRandom::Fill(salt.data(), salt.size());

auto derivedKey = KeyDerivation::Argon2id("my_password", salt);
AES256GCM::Key aesKey;
std::copy_n(derivedKey.begin(), AES256GCM::KEY_SIZE, aesKey.begin());
```

### Post-Quantum Hybrid Encryption
```cpp
#include "crypto/HybridCipher.hpp"

using namespace ss::crypto;

auto keypair = HybridCipher::GenerateHybridKeyPair();
std::vector<uint8_t> data = {'s', 'e', 'c', 'r', 'e', 't'};

auto encrypted = HybridCipher::Encrypt(data, keypair, keypair);
auto decrypted = HybridCipher::Decrypt(encrypted, keypair, keypair);
```

## Project Structure

```
SecureShield/
├── include/              # Public headers
│   ├── core/             # Engine, Config, Logger
│   ├── crypto/           # Encryption algorithms
│   │   └── postquantum/  # ML-KEM, ML-DSA
│   ├── hash/             # Hash functions
│   ├── io/               # File operations, SecureDelete
│   ├── obfuscation/      # String encryption
│   ├── protection/       # AntiDebug, Integrity
│   ├── utils/            # Utilities
│   └── compression/      # Zstd compression
├── src/                  # Implementation files
├── gui/                  # Qt6 GUI application
├── tests/                # Unit tests (GTest)
├── examples/             # Usage examples
└── CMakeLists.txt        # Build system
```

## Testing

```bash
cmake -B build -S . -DSECURESHIELD_BUILD_TESTS=ON
cmake --build build --config Debug
ctest --test-dir build --output-on-failure
```

## Security Considerations

- All cryptographic operations use constant-time comparisons
- Memory containing secrets is wiped via `OPENSSL_cleanse` / `SecureZeroMemory`
- Password strings should use `SecureString` class for automatic wiping
- Anti-debug protection can be enabled for runtime security
- File encryption uses authenticated encryption (AEAD) — tampering is detected

## License

MIT License — see [LICENSE](LICENSE) for details.
