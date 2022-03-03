use std::{num::NonZeroU32, vec};

use aes_gcm::{
    aead::{
        generic_array::{typenum, GenericArray},
        Aead, NewAead,
    },
    Aes256Gcm, Key, Nonce,
};
use flutter_rust_bridge::ZeroCopyBuffer;
use ring::{digest, pbkdf2};

static PBKDF2_ALGO: pbkdf2::Algorithm = pbkdf2::PBKDF2_HMAC_SHA512;
const OUTPUT_LENGTH: usize = digest::SHA256_OUTPUT_LEN;

pub fn derive_key(
    password: String,
    nonce: ZeroCopyBuffer<Vec<u8>>,
) -> ZeroCopyBuffer<Vec<u8>> {
    let mut key = vec![0u8; OUTPUT_LENGTH];

    pbkdf2::derive(
        PBKDF2_ALGO,
        NonZeroU32::new(100000).unwrap(),
        nonce.0.as_ref(),
        password.as_bytes(),
        &mut key,
    );

    ZeroCopyBuffer(key)
}

pub fn encrypt(
    data: ZeroCopyBuffer<Vec<u8>>,
    password: String,
    // Password nonce
    key_nonce: ZeroCopyBuffer<Vec<u8>>,
    // AES nonce
    aes_nonce: ZeroCopyBuffer<Vec<u8>>,
) -> ZeroCopyBuffer<Vec<u8>> {
    let key = derive_key(password, key_nonce.clone());

    let cipher = Aes256Gcm::new(Key::from_slice(&key.0));
    let nonce: &GenericArray<u8, typenum::U12> =
        Nonce::from_slice(&aes_nonce.0);

    let ciphertext = cipher.encrypt(nonce, &*data.0).unwrap();
    let ciphertext_len = ciphertext.len();

    let mut result =
        vec![0u8; key_nonce.0.len() + aes_nonce.0.len() + ciphertext.len()];

    result[0..16].copy_from_slice(&key_nonce.0);
    result[16..28].copy_from_slice(&aes_nonce.0);
    result[28..44]
        .copy_from_slice(&ciphertext[(ciphertext_len - 16)..(ciphertext_len)]);
    result[44..].copy_from_slice(&ciphertext[..(ciphertext_len - 16)]);

    ZeroCopyBuffer(result)
}

pub fn decrypt(
    data: ZeroCopyBuffer<Vec<u8>>,
    password: String,
) -> ZeroCopyBuffer<Vec<u8>> {
    let key_nonce = &data.0[0..16];
    let aes_nonce = &data.0[16..28];
    let mac = &data.0[28..44];
    let ciphertext = &data.0[44..];

    let mut ciphertext_mac = vec![0u8; ciphertext.len() + mac.len()];
    ciphertext_mac[..(ciphertext.len())].copy_from_slice(ciphertext);
    ciphertext_mac[(ciphertext.len())..].copy_from_slice(mac);

    let key = derive_key(password, ZeroCopyBuffer(key_nonce.to_vec()));

    let cipher = Aes256Gcm::new(Key::from_slice(&key.0));
    let nonce: &GenericArray<u8, typenum::U12> = Nonce::from_slice(aes_nonce);

    let plaintext = cipher.decrypt(nonce, ciphertext_mac.as_ref()).unwrap();

    ZeroCopyBuffer(plaintext)
}
