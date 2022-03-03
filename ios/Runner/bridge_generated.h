#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_derive_key(int64_t port_,
                     struct wire_uint_8_list *password,
                     struct wire_uint_8_list *nonce);

void wire_encrypt(int64_t port_,
                  struct wire_uint_8_list *data,
                  struct wire_uint_8_list *password,
                  struct wire_uint_8_list *key_nonce,
                  struct wire_uint_8_list *aes_nonce);

void wire_decrypt(int64_t port_, struct wire_uint_8_list *data, struct wire_uint_8_list *password);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_derive_key);
    dummy_var ^= ((int64_t) (void*) wire_encrypt);
    dummy_var ^= ((int64_t) (void*) wire_decrypt);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}