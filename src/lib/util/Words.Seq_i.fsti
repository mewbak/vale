module Words.Seq_i

open FStar.Seq
open Words_s
open Words.Four_s
open Words.Seq_s
open FStar.Mul

val seq_to_seq_four_to_seq_LE  (#a:Type) (x:seq (four a)) :
  Lemma (seq_to_seq_four_LE (seq_four_to_seq_LE x) == x)
  [SMTPat (seq_to_seq_four_LE (seq_four_to_seq_LE x))]

val seq_four_to_seq_to_seq_four_LE (#a:Type) (x:seq a{length x % 4 == 0}) :
  Lemma (seq_four_to_seq_LE (seq_to_seq_four_LE x) == x)
  [SMTPat (seq_four_to_seq_LE (seq_to_seq_four_LE x))]

val four_to_nat_to_four_8 (x:natN (pow2_norm 32)) :
  Lemma (four_to_nat 8 (nat_to_four 8 x) == x)
  [SMTPat (four_to_nat 8 (nat_to_four 8 x))]

val nat_to_four_to_nat (x:four (natN (pow2_norm 8))) :
  Lemma (nat_to_four 8 (four_to_nat 8 x) == x)
  [SMTPat (nat_to_four 8 (four_to_nat 8 x) == x)]


val four_to_seq_to_four_LE (#a:Type) (x:seq4 a) :
  Lemma (four_to_seq_LE (seq_to_four_LE x) == x)

val four_to_seq_LE_is_seq_four_to_seq_LE(#a:Type) (x:four a) : 
  Lemma (four_to_seq_LE x == seq_four_to_seq_LE (create 1 x))

(*
val seq_four_to_seq_LE_injective: unit ->
  Lemma (forall (#a:Type) (x x':seq (four a)). seq_four_to_seq_LE x == seq_four_to_seq_LE x' ==> x == x')

val seq_to_seq_four_LE_injective: unit ->
  Lemma (forall (#a:Type) (x:seq a{length x % 4 == 0}) (x':seq a{length x' % 4 == 0}) . seq_to_seq_four_LE x == seq_to_seq_four_LE x' ==> x == x')
*)
val four_to_nat_8_injective: unit -> 
  Lemma (forall (x x':four (natN (pow2_norm 8))) . four_to_nat 8 x == four_to_nat 8 x' ==> x == x')
  
val nat_to_four_8_injective: unit -> 
  Lemma (forall (x x':natN (pow2_norm 32)) . nat_to_four 8 x == nat_to_four 8 x' ==> x == x')
(*
val seq_to_four_LE_injective: unit ->
  Lemma (forall (#a:Type) (x x':seq4 a) . seq_to_four_LE x == seq_to_four_LE x' ==> x == x') 
*)