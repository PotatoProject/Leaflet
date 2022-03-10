# How it works

## File format

| 2 bytes                                 | JSON metadata | 16 bytes     | 12 bytes                  | 16 bytes    | Payload |
| --------------------------------------- | ------------- | ------------ | ------------------------- | ----------- | ------- |
| length of JSON metadata (little endian) | string        | PBKDF2 nonce | AES initialization vector | AES-GCM tag | binary  |

The binary payload is a zip encrypted with AES-256-GCM using a key derived using
PBKDF2 with 100,000 iterations and SHA-512 hash.
