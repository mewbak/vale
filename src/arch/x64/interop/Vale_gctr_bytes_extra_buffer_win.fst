module Vale_gctr_bytes_extra_buffer_win

open Words_s
open Types_s
open Types_i
open X64.Machine_s
open X64.Memory_i
open X64.Vale.State_i
open X64.Vale.Decls_i
open AES_s
open X64.AES
open GCTR_s
open GCTR_i
open GCM_helpers_i
open X64.GCTR

val va_code_gctr_bytes_extra_buffer_win: unit -> va_code
let va_code_gctr_bytes_extra_buffer_win () = va_code_gctr_bytes_extra_buffer_win AES_128

//TODO: Fill this
  //va_pre and va_post should correspond to the pre- and postconditions generated by Vale
let va_pre (va_b0:va_code) (va_s0:va_state) (stack_b:buffer64)
(plain_b:buffer128) (num_bytes:nat64) (iv_old:(quad32)) (iv_b:buffer128) (key:(aes_key_LE AES_128)) (keys_b:buffer128) (cipher_b:buffer128)  =
   ((va_require_total va_b0 (va_code_gctr_bytes_extra_buffer_win ()) va_s0) /\ (va_get_ok
    va_s0) /\ (locs_disjoint [(loc_buffer stack_b); (loc_buffer plain_b); (loc_buffer iv_b);
    (loc_buffer keys_b); (loc_buffer cipher_b)]) /\ (buffer_readable (va_get_mem va_s0) stack_b) /\
    (buffer_readable (va_get_mem va_s0) plain_b) /\ (buffer_readable (va_get_mem va_s0) iv_b) /\
    (buffer_readable (va_get_mem va_s0) keys_b) /\ (buffer_readable (va_get_mem va_s0) cipher_b) /\
    (buffer_length stack_b) >= 6 /\ (valid_stack_slots (va_get_mem va_s0) (va_get_reg Rsp va_s0)
    stack_b 0) /\ (va_get_reg Rcx va_s0) == (buffer_addr plain_b (va_get_mem va_s0)) /\ (va_get_reg
    Rdx va_s0) == num_bytes /\ (va_get_reg R8 va_s0) == (buffer_addr iv_b (va_get_mem va_s0)) /\
    (va_get_reg R9 va_s0) == (buffer_addr keys_b (va_get_mem va_s0)) /\ (buffer_read stack_b 5
    (va_get_mem va_s0)) == (buffer_addr cipher_b (va_get_mem va_s0)) /\ (buffer_length plain_b) ==
    (bytes_to_quad_size num_bytes) /\ (buffer_length cipher_b) == (buffer_length plain_b) /\
    (buffer_length iv_b) == 1 /\ (buffer_addr plain_b (va_get_mem va_s0)) + 16 `op_Multiply`
    (bytes_to_quad_size num_bytes) < pow2_64 /\ (buffer_addr cipher_b (va_get_mem va_s0)) + 16
    `op_Multiply` (bytes_to_quad_size num_bytes) < pow2_64 /\ 4096 `op_Multiply` num_bytes <
    pow2_32 /\ 256 `op_Multiply` (bytes_to_quad_size num_bytes) < pow2_32 /\ (buffer_length keys_b)
    == (nr AES_128) + 1 /\ (buffer_as_seq (va_get_mem va_s0) keys_b) == (key_to_round_keys_LE
    AES_128 key) /\ (let num_blocks = num_bytes `op_Division` 16 in num_bytes `op_Modulus` 16 =!= 0
    /\ ((0 < num_bytes && num_bytes < 16 `op_Multiply` (bytes_to_quad_size num_bytes))) /\ 16
    `op_Multiply` ((bytes_to_quad_size num_bytes) - 1) < num_bytes /\ (gctr_partial AES_128
    num_blocks (buffer128_as_seq (va_get_mem va_s0) plain_b) (buffer128_as_seq (va_get_mem va_s0)
    cipher_b) key iv_old) /\ (buffer128_read iv_b 0 (va_get_mem va_s0)) == (inc32 iv_old
    num_blocks)))

let va_post (va_b0:va_code) (va_s0:va_state) (va_sM:va_state) (va_fM:va_fuel) (stack_b:buffer64)
(plain_b:buffer128) (num_bytes:nat64) (iv_old:(quad32)) (iv_b:buffer128) (key:(aes_key_LE AES_128)) (keys_b:buffer128) (cipher_b:buffer128)  =
    va_pre va_b0 va_s0 stack_b plain_b num_bytes iv_old iv_b key keys_b cipher_b /\ 
   ((va_ensure_total va_b0 va_s0 va_sM va_fM) /\ (va_get_ok va_sM)
    /\ (va_get_reg Rbx va_sM) == (va_get_reg Rbx va_s0) /\ (va_get_reg Rbp va_sM) == (va_get_reg
    Rbp va_s0) /\ (va_get_reg Rdi va_sM) == (va_get_reg Rdi va_s0) /\ (va_get_reg Rsi va_sM) ==
    (va_get_reg Rsi va_s0) /\ (va_get_reg Rsp va_sM) == (va_get_reg Rsp va_s0) /\ (va_get_reg R12
    va_sM) == (va_get_reg R12 va_s0) /\ (va_get_reg R13 va_sM) == (va_get_reg R13 va_s0) /\
    (va_get_reg R14 va_sM) == (va_get_reg R14 va_s0) /\ (va_get_reg R15 va_sM) == (va_get_reg R15
    va_s0) /\ (va_get_xmm 6 va_sM) == (va_get_xmm 6 va_s0) /\ (va_get_xmm 7 va_sM) == (va_get_xmm 7
    va_s0) /\ (va_get_xmm 8 va_sM) == (va_get_xmm 8 va_s0) /\ (va_get_xmm 9 va_sM) == (va_get_xmm 9
    va_s0) /\ (va_get_xmm 10 va_sM) == (va_get_xmm 10 va_s0) /\ (va_get_xmm 11 va_sM) ==
    (va_get_xmm 11 va_s0) /\ (va_get_xmm 12 va_sM) == (va_get_xmm 12 va_s0) /\ (va_get_xmm 13
    va_sM) == (va_get_xmm 13 va_s0) /\ (va_get_xmm 14 va_sM) == (va_get_xmm 14 va_s0) /\
    (va_get_xmm 15 va_sM) == (va_get_xmm 15 va_s0) /\ (modifies_buffer128 cipher_b (va_get_mem
    va_s0) (va_get_mem va_sM)) /\ (buffer_readable (va_get_mem va_sM) plain_b) /\ (buffer_readable
    (va_get_mem va_sM) iv_b) /\ (buffer_readable (va_get_mem va_sM) keys_b) /\ (buffer_readable
    (va_get_mem va_sM) cipher_b) /\ (let num_blocks = num_bytes `op_Division` 16 in let plain =
    (Seq.slice (le_seq_quad32_to_bytes (buffer128_as_seq (va_get_mem va_sM) plain_b)) 0 num_bytes) in
    let cipher = (Seq.slice (le_seq_quad32_to_bytes (buffer128_as_seq (va_get_mem va_sM) cipher_b)) 0
    num_bytes) in cipher == (gctr_encrypt_LE iv_old (make_gctr_plain_LE plain) AES_128 key) /\ (let
    cipher_blocks = (slice_work_around (buffer128_as_seq (va_get_mem va_sM) cipher_b) num_blocks)
    in let old_cipher_blocks = (slice_work_around (buffer128_as_seq (va_get_mem va_s0) cipher_b)
    num_blocks) in cipher_blocks == old_cipher_blocks)) /\ (va_state_eq va_sM (va_update_mem va_sM
    (va_update_flags va_sM (va_update_xmm 15 va_sM (va_update_xmm 14 va_sM (va_update_xmm 13 va_sM
    (va_update_xmm 12 va_sM (va_update_xmm 11 va_sM (va_update_xmm 10 va_sM (va_update_xmm 9 va_sM
    (va_update_xmm 8 va_sM (va_update_xmm 7 va_sM (va_update_xmm 6 va_sM (va_update_xmm 5 va_sM
    (va_update_xmm 4 va_sM (va_update_xmm 3 va_sM (va_update_xmm 2 va_sM (va_update_xmm 1 va_sM
    (va_update_xmm 0 va_sM (va_update_reg R15 va_sM (va_update_reg R14 va_sM (va_update_reg R13
    va_sM (va_update_reg R12 va_sM (va_update_reg R11 va_sM (va_update_reg R10 va_sM (va_update_reg
    R9 va_sM (va_update_reg R8 va_sM (va_update_reg Rsp va_sM (va_update_reg Rbp va_sM
    (va_update_reg Rdi va_sM (va_update_reg Rsi va_sM (va_update_reg Rdx va_sM (va_update_reg Rcx
    va_sM (va_update_reg Rbx va_sM (va_update_reg Rax va_sM (va_update_ok va_sM
    va_s0)))))))))))))))))))))))))))))))))))))

val va_lemma_gctr_bytes_extra_buffer_win(va_b0:va_code) (va_s0:va_state) (stack_b:buffer64)
(plain_b:buffer128) (num_bytes:nat64) (iv_old:(quad32)) (iv_b:buffer128) (key:(aes_key_LE AES_128)) (keys_b:buffer128) (cipher_b:buffer128) : Ghost ((va_sM:va_state) * (va_fM:va_fuel))
  (requires va_pre va_b0 va_s0 stack_b plain_b num_bytes iv_old iv_b key keys_b cipher_b )
  (ensures (fun (va_sM, va_fM) -> va_post va_b0 va_s0 va_sM va_fM stack_b plain_b num_bytes iv_old iv_b key keys_b cipher_b ))

let va_lemma_gctr_bytes_extra_buffer_win va_b0 va_s0 = va_lemma_gctr_bytes_extra_buffer_win va_b0 va_s0 AES_128
