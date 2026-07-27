# SecureShield API Reference

## Core

### Engine
Singleton managing initialization, encryption, decryption, and integrity operations.

```cpp
#include "core/Engine.hpp"

// Initialize
Engine::instance().initialize();

// Encrypt file with key
auto result = Engine::instance().encryptFile(
    "input.txt", "output.enc", aesKey);

// Decrypt file with key
auto result = Engine::instance().decryptFile(
    "output.enc", "decrypted.txt", aesKey);

// Password-based encryption
auto result = Engine::instance().encryptFileWithPassword(
    "input.txt", "output.enc", "my_password");
```

## Crypto

### AES256GCM
```cpp
auto key = AES256GCM::GenerateKey();                    // 256-bit key
auto iv = AES256GCM::GenerateIV();                       // 96-bit IV
auto encrypted = AES256GCM::Encrypt(plaintext, key);    // AEAD
auto decrypted = AES256GCM::Decrypt(encrypted, key);    // Verify + decrypt
```

### ChaCha20Poly1305
```cpp
auto key = SecureRandom::Key<ChaCha20Poly1305::KEY_SIZE>();
auto encrypted = ChaCha20Poly1305::Encrypt(plaintext, key);
auto decrypted = ChaCha20Poly1305::Decrypt(encrypted, key);
```

### CamelliaCBC
```cpp
auto key = SecureRandom::Key<CamelliaCBC::KEY_SIZE>();
auto encrypted = CamelliaCBC::Encrypt(plaintext, key);     // + HMAC tag
auto decrypted = CamelliaCBC::Decrypt(encrypted, key);     // MAC verify first
```

### KeyDerivation
```cpp
auto salt = SecureRandom::Fill(...);
auto key = KeyDerivation::Argon2id(password, salt, config);
bool valid = KeyDerivation::VerifyArgon2id(password, salt, key);
auto multiKey = KeyDerivation::MultiLayerDerive(password, salt, 32, 10);
```

### SecureRandom
```cpp
uint8_t buf[32];
SecureRandom::Fill(buf, 32);
auto key = SecureRandom::Key<32>();
auto nonce = SecureRandom::Nonce<12>();
```

### Ed25519
```cpp
auto [privKey, pubKey] = Ed25519::GenerateKeyPair();
auto sig = Ed25519::Sign(data, privKey);
bool ok = Ed25519::Verify(data, sig, pubKey);
```

### HybridCipher
```cpp
auto keypair = HybridCipher::GenerateHybridKeyPair();
auto encrypted = HybridCipher::Encrypt(plaintext, recipientPub, senderPriv);
auto decrypted = HybridCipher::Decrypt(encrypted, recipientPriv, senderPub);
```

## Post-Quantum (NIST FIPS 203/204)

### ML-KEM-768 (Key Encapsulation)
```cpp
auto kp = MLKEM768::GenerateKeyPair();
MLKEM768Ciphertext ct;
auto ss1 = MLKEM768::Encapsulate(kp.publicKey, ct);
auto ss2 = MLKEM768::Decapsulate(ct, kp.privateKey);   // ss1 == ss2
```

### ML-DSA-44 (Digital Signature)
```cpp
auto kp = MLDSA44::GenerateKeyPair();
auto sig = MLDSA44::Sign(data, kp.privateKey);
bool ok = MLDSA44::Verify(data, sig, kp.publicKey);
```

## Hash

```cpp
auto d = SHA256::Compute(data);
auto d = SHA512::Compute(data);
auto d = SHA3::Compute(data);
auto d = BLAKE2::Compute(data);
auto d = Blake3::Compute(data);
auto d = Whirlpool::Compute(data);
auto d = RIPEMD160::Compute(data);
```

## Protection

### SecureDelete
```cpp
SecureDelete::DeleteFile("secret.txt", 3);    // 3-pass overwrite
SecureDelete::WipeMemory(ptr, size, 3);
```

### AntiDebug
```cpp
AntiDebug::Enable(AntiDebugLevel::Advanced, true);
auto result = AntiDebug::FullCheck();
AntiDebug::Disable();
```

### SecureString
```cpp
SecureString password("my_secret_password");
// Memory is automatically wiped on destruction
```
