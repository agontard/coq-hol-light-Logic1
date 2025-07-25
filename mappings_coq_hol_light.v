Require Import HOLLight_Real_With_N.mappings.
Import BinNat ssreflect ssrnat ssrfun eqtype choice classical_sets boolp HB.structures type.
Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

(*****************************************************************************)
(* Proof that Rocq's R is a fourcolor.model of real numbers. *)
(*****************************************************************************)

Require Import Stdlib.Reals.Reals.
Open Scope R_scope.

HB.instance Definition _ := is_Type' 0.

Definition Rsup : (R -> Prop) -> R.
Proof.
  intro E. case: (pselect (bound E)); intro h.
  case (pselect (exists x, E x)); intro i.
  destruct (completeness E h i) as [b j]. exact b.
  exact 0. exact 0.
Defined.

Lemma is_lub_Rsup E : bound E -> (exists x, E x) -> is_lub E (Rsup E).
Proof.
  intros h i. unfold Rsup. case (pselect (bound E)); intro h'.
  case (pselect (exists x, E x)); intro i'.
  destruct (completeness E h' i') as [b j]. exact j. contradiction. contradiction.
Qed.

Require Import fourcolor.reals.real.
Import Real.

Definition R_struct : structure := {|
  val := R;
  le := Rle;
  sup := Rsup;
  add := Rplus;
  zero := R0;
  opp := Ropp;
  mul := Rmult;
  one := R1;
  inv := Rinv
|}.

Canonical R_struct.

Lemma Rsup_upper_bound E : has_sup E -> ub E (Rsup E).
Proof.
  intros [i j]. unfold Rsup. case (pselect (bound E)); intro c.
  case (pselect (exists x : R, E x)); intro d.
  destruct (completeness E c d) as [b [k l]]. intros x h. apply k. exact h.
  intros x h. assert (exists x : R, E x). exists x. exact h. contradiction.
  intros x h. assert (exists x : R, E x). exists x. exact h. contradiction.
Qed.

Lemma Rsup_total E x : has_sup E -> down E x \/ Rle (sup E) x.
Proof.
  intros [i [b j]]. case (pselect (down E x)); intro k. auto. right.
  assert (l : bound E). exists b. exact j.
  generalize (is_lub_Rsup l i); intros [m n]. apply n.
  intros y hy.
  unfold down in k. Search (forall P Q, exists2 x, P & Q = _). rewrite exists2E -forallNE in k.
  generalize (k y); intro k'. rewrite not_andE orNp in k'.
  unfold Rle. left. apply Rnot_le_lt. apply k'. exact hy.
Qed.

(* Remark: in fourcolor, le is primitive and eq is defined as the
intersection of le and the inverse of le, but in coq, lt is primitive
and le is defined from lt and Logic.eq. *)

Lemma eq_R_struct : @eq R_struct = @Logic.eq R.
Proof.
  ext=> [x y [h i]| x y h].
  apply Rle_antisym; auto.
  subst y. split; apply Rle_refl.
Qed.

Lemma R_axioms : axioms R_struct.
Proof.
  apply Axioms.
  apply Rle_refl.
  apply Rle_trans.
  apply Rsup_upper_bound.
  apply Rsup_total.
  apply Rplus_le_compat_l.
  intros x y. rewrite eq_R_struct. apply Rplus_comm.
  intros x y z. rewrite eq_R_struct. rewrite -> Rplus_assoc. reflexivity.
  intro x. rewrite eq_R_struct. apply Rplus_0_l.
  intro x. rewrite eq_R_struct. apply Rplus_opp_r.
  apply Rmult_le_compat_l.
  intros x y. rewrite eq_R_struct. apply Rmult_comm.
  intros x y z. rewrite eq_R_struct. rewrite -> Rmult_assoc. reflexivity.
  intros x y z. rewrite eq_R_struct. apply Rmult_plus_distr_l.
  intro x. rewrite eq_R_struct. apply Rmult_1_l.
  intro x. rewrite eq_R_struct. apply Rinv_r.
  rewrite eq_R_struct. apply R1_neq_R0.
Qed.

Definition R_model : model := {|
  model_structure := R_struct;
  model_axioms := R_axioms;
|}.

Lemma eq_R_model :
  @eq (model_structure R_model) = @Logic.eq (val (model_structure R_model)).
Proof. exact eq_R_struct. Qed.

(*****************************************************************************)
(* Proof that real is a fourcolor.model of real numbers. *)
(*****************************************************************************)

Require Import HOLLight_Real_With_N.terms.

Lemma real_add_of_num p q :
  real_of_num (p + q)%N = real_add (real_of_num p) (real_of_num q).
Proof.
  unfold real_of_num, real_add.
  f_equal. rewrite treal_add_of_num. ext=> [x h | x [p' [q' [h1 [h2 h3]]]]].

  exists (treal_of_num p). exists (treal_of_num q). split. exact h. split.
  rewrite axiom_24_aux. reflexivity. exists (treal_of_num p). reflexivity.
  rewrite axiom_24_aux. reflexivity. exists (treal_of_num q). reflexivity.

  rewrite axiom_24_aux in h2. 2: exists (treal_of_num p); reflexivity.
  rewrite axiom_24_aux in h3. 2: exists (treal_of_num q); reflexivity.
  rewrite h2 h3. exact h1.
Qed.

Definition real_sup : (real -> Prop) -> real.
Proof.
  intro P. case (pselect (exists x, P x)); intro h.
  case (pselect (exists M, forall x, (P x) -> real_le x M)); intro i.
  set (Q := fun M => (forall x : real, P x -> real_le x M) /\
                    (forall M' : real, (forall x : real, P x -> real_le x M')
                                  -> real_le M M')).
  exact (ε Q). exact (real_of_num 0). exact (real_of_num 0).
Defined.

Definition real_struct : structure := {|
  val := real;
  le := real_le;
  sup := real_sup;
  add := real_add;
  zero := real_of_num 0;
  opp := real_neg;
  mul := real_mul;
  one := real_of_num 1;
  inv := real_inv
|}.

Canonical real_struct.

Require Import HOLLight_Real_With_N.theorems.

Lemma real_sup_is_lub E :
  has_sup E -> ub E (real_sup E) /\ (forall b, ub E b -> real_le (real_sup E) b).
Proof.
  intros [i j]. unfold real_sup.
  destruct (pselect (exists x : real, E x)).
  destruct (pselect (exists M : real, forall x : real, E x -> real_le x M)).
  set (Q := fun M : real =>
              (forall x : real, E x -> real_le x M) /\
                (forall M' : real, (forall x : real, E x -> real_le x M') -> real_le M M')).
  assert (k: exists M : real, Q M). apply (thm_REAL_COMPLETE E (conj i j)).
  generalize (ε_spec k); intros [l m]. auto. contradiction. contradiction.
Qed.

Lemma real_sup_upper_bound E : has_sup E -> ub E (real_sup E).
Proof. intro h. apply (proj1 (real_sup_is_lub h)). Qed.

Lemma real_sup_total E x : has_sup E -> down E x \/ real_le (real_sup E) x.
Proof.
  intro h. case (pselect (down E x)); intro k. auto. right.
  generalize (real_sup_is_lub h); intros [i j]. apply j.
  intros y hy.
  unfold down in k. rewrite exists2E -forallNE in k.
  generalize (k y); intro k'. rewrite not_andE orNp in k'.
  apply thm_REAL_LT_IMP_LE. apply k'. apply hy.
Qed.

Lemma eq_real_struct: @eq real_struct = @Logic.eq real.
Proof.
  by ext => x y ; rewrite/eq thm_REAL_LE_ANTISYM.
Qed.

Lemma real_axioms : axioms real_struct.
Proof.
  apply Axioms.
  apply thm_REAL_LE_REFL.
  intros x y z xy yz; apply (thm_REAL_LE_TRANS x y z (conj xy yz)).
  apply real_sup_upper_bound.
  apply real_sup_total.
  intros x y z yz; rewrite -> thm_REAL_LE_LADD; exact yz.
  intros x y. rewrite eq_real_struct. apply thm_REAL_ADD_SYM.
  intros x y z. rewrite eq_real_struct. apply thm_REAL_ADD_ASSOC.
  intro x. rewrite eq_real_struct. apply thm_REAL_ADD_LID.
  intro x. rewrite eq_real_struct. rewrite -> thm_REAL_ADD_SYM. apply thm_REAL_ADD_LINV.
  intros x y z hx yz. apply thm_REAL_LE_LMUL. auto.
  intros x y. rewrite eq_real_struct. apply thm_REAL_MUL_SYM.
  intros x y z. rewrite eq_real_struct. apply thm_REAL_MUL_ASSOC.
  intros x y z. rewrite eq_real_struct. apply thm_REAL_ADD_LDISTRIB.
  intro x. rewrite eq_real_struct. apply thm_REAL_MUL_LID.
  intro x. rewrite eq_real_struct. rewrite -> thm_REAL_MUL_SYM. apply thm_REAL_MUL_LINV.
  unfold one, zero. simpl. rewrite eq_real_struct thm_REAL_OF_NUM_EQ. lia.
Qed.

Definition real_model : model := {|
  model_structure := real_struct;
  model_axioms := real_axioms;
|}.

Lemma eq_real_model:
  @eq (model_structure real_model) = @Logic.eq (val (model_structure real_model)).
Proof. exact eq_real_struct. Qed.

Require Import fourcolor.reals.realcategorical.
Set Bullet Behavior "Strict Subproofs".

Definition R_of_real := @Rmorph_to real_model R_model.
Definition real_of_R := @Rmorph_to R_model real_model.

Lemma R_of_real_of_R r : R_of_real (real_of_R r) = r.
Proof. rewrite <- eq_R_model. apply (@Rmorph_to_inv R_model real_model). Qed.

Lemma real_of_R_of_real r : real_of_R (R_of_real r) = r.
Proof. rewrite <- eq_real_model. apply (@Rmorph_to_inv real_model R_model). Qed.

(*****************************************************************************)
(* Mapping of HOL-Light reals to Rocq reals. *)
(*****************************************************************************)

Definition mk_real : ((prod hreal hreal) -> Prop) -> R := fun x => R_of_real (mk_real x).

Definition dest_real : R -> (prod hreal hreal) -> Prop := fun x => dest_real (real_of_R x).

Lemma axiom_23 : forall (a : R), (mk_real (dest_real a)) = a.
Proof. intro a. unfold mk_real, dest_real. rewrite axiom_23. apply R_of_real_of_R. Qed.

Lemma axiom_24_aux : forall r, (exists x, r = treal_eq x) -> dest_real (mk_real r) = r.
Proof.
  intros c [x h]. unfold dest_real, mk_real.
  rewrite real_of_R_of_real -axiom_24.
  exists x. exact h.
Qed.

Lemma axiom_24 : forall (r : (prod hreal hreal) -> Prop), ((fun s : (prod hreal hreal) -> Prop => exists x : prod hreal hreal, s = (treal_eq x)) r) = ((dest_real (mk_real r)) = r).
Proof.
  intro c. unfold dest_real, mk_real. rewrite real_of_R_of_real -axiom_24.
  reflexivity.
Qed.

Lemma real_of_R_morph : morphism real_of_R.
Proof. apply Rmorph_toP. Qed.

Lemma R_of_real_morph : morphism R_of_real.
Proof. apply Rmorph_toP. Qed.

Lemma le_morph_R x y : le x y = le (real_of_R x) (real_of_R y).
Proof.
  generalize (morph_le real_of_R_morph x y); intros [h i]. apply prop_ext; auto.
Qed.

Lemma real_le_def : Rle = (fun x1 : R => fun y1 : R => @ε Prop (fun u : Prop => exists x1' : prod hreal hreal, exists y1' : prod hreal hreal, ((treal_le x1' y1') = u) /\ ((dest_real x1 x1') /\ (dest_real y1 y1')))).
Proof.
  apply funext =>x ; apply funext=>y.
  unfold dest_real. rewrite le_morph_R.
  generalize (real_of_R x); clear x; intro x.
  generalize (real_of_R y); clear y; intro y.
  reflexivity.
Qed.

Lemma add_morph_R x y : real_of_R (add x y) = (add (real_of_R x) (real_of_R y)).
Proof. rewrite <- eq_real_model. apply (morph_add real_of_R_morph). Qed.

Lemma add_eq x y : add x y = R_of_real (add (real_of_R x) (real_of_R y)).
Proof. rewrite <- add_morph_R, R_of_real_of_R. reflexivity. Qed.

Lemma real_add_def : Rplus = (fun x1 : R => fun y1 : R => mk_real (fun u : prod hreal hreal => exists x1' : prod hreal hreal, exists y1' : prod hreal hreal, (treal_eq (treal_add x1' y1') u) /\ ((dest_real x1 x1') /\ (dest_real y1 y1')))).
Proof.
  ext=> x y.
  rewrite add_eq. unfold mk_real. apply f_equal. reflexivity.
Qed.

Lemma mul_morph_R x y : real_of_R (mul x y) = (mul (real_of_R x) (real_of_R y)).
Proof. rewrite <- eq_real_model. apply (morph_mul real_of_R_morph). Qed.

Lemma mul_eq x y : mul x y = R_of_real (mul (real_of_R x) (real_of_R y)).
Proof. rewrite <- mul_morph_R, R_of_real_of_R. reflexivity. Qed.

Lemma real_mul_def : Rmult = (fun x1 : R => fun y1 : R => mk_real (fun u : prod hreal hreal => exists x1' : prod hreal hreal, exists y1' : prod hreal hreal, (treal_eq (treal_mul x1' y1') u) /\ ((dest_real x1 x1') /\ (dest_real y1 y1')))).
Proof.
  ext=> x y.
  rewrite mul_eq. unfold mk_real. apply f_equal. reflexivity.
Qed.

Lemma zero_morph_R : real_of_R 0%R = real_of_num 0.
Proof. rewrite <- eq_real_model. apply (morph_zero real_of_R_morph). Qed.

Lemma zero_eq : 0%R = R_of_real (real_of_num 0).
Proof. rewrite <- zero_morph_R, R_of_real_of_R. reflexivity. Qed.

Lemma inv_morph_R x : real_of_R (inv x) = inv (real_of_R x).
Proof.
  case (pselect (x = 0%R)); intro h.
  subst x. unfold inv. simpl. rewrite Rinv_0 zero_eq !real_of_R_of_real.
  Set Printing All.
  change (@Logic.eq (real) (real_of_num 0) (real_inv (real_of_num 0))).
  symmetry. apply thm_REAL_INV_0.
  rewrite <- eq_real_model. apply (morph_inv real_of_R_morph).
  rewrite eq_R_model. exact h.
  Unset Printing All.
Qed.

Lemma inv_eq x : inv x = R_of_real (inv (real_of_R x)).
Proof. rewrite <- inv_morph_R, R_of_real_of_R. reflexivity. Qed.

Lemma real_inv_def : Rinv = (fun x : R => mk_real (fun u : prod hreal hreal => exists x' : prod hreal hreal, (treal_eq (treal_inv x') u) /\ (dest_real x x'))).
Proof. ext=>x. rewrite inv_eq. unfold mk_real. reflexivity. Qed.

Lemma neg_morph_R x : real_of_R (opp x) = opp (real_of_R x).
Proof. rewrite <- eq_real_model. apply (morph_opp real_of_R_morph). Qed.

Lemma neg_eq x : opp x = R_of_real (opp (real_of_R x)).
Proof. rewrite <- neg_morph_R, R_of_real_of_R. reflexivity. Qed.

Lemma real_neg_def : Ropp = (fun x1 : R => mk_real (fun u : prod hreal hreal => exists x1' : prod hreal hreal, (treal_eq (treal_neg x1') u) /\ (dest_real x1 x1'))).
Proof. ext=>x. rewrite neg_eq. unfold mk_real. reflexivity. Qed.

Lemma one_morph_R : real_of_R 1%R = real_of_num 1.
Proof. rewrite <- eq_real_model. apply (morph_one real_of_R_morph). Qed.

Lemma one_eq : 1%R = R_of_real (real_of_num 1).
Proof. rewrite <- one_morph_R, R_of_real_of_R. reflexivity. Qed.

Definition R_of_N n :=
  match n with
  | N0 => 0
  | N.pos p => IPR p
  end.

Require Import Stdlib.micromega.Lra.

Lemma R_of_N_succ n : R_of_N (N.succ n) = R_of_N n + 1.
Proof.
  destruct n; simpl. unfold IPR. lra. rewrite Rplus_comm. apply succ_IPR.
Qed.

Lemma R_of_N_add p q : R_of_N (p + q)%N = R_of_N p + R_of_N q.
Proof.
  destruct p; destruct q; simpl. lra. unfold IPR. lra. unfold IPR. lra.
  apply plus_IPR.
Qed.

Lemma Npos_succ p : N.pos (Pos.succ p) = (N.pos p + 1)%N.
Proof. lia. Qed.

Lemma treal_eq_of_num_add m n :
  treal_eq (treal_of_num (m + n))
  = treal_eq (treal_add (treal_of_num m) (treal_of_num n)).
Proof.
  apply (@eq_class_intro (prod hreal hreal)). apply treal_eq_sym. apply treal_eq_trans.
  symmetry. apply thm_TREAL_OF_NUM_ADD.
Qed.

Lemma mk_real_treal_eq_add p q :
  mk_real (treal_eq (treal_add (treal_of_num p) (treal_of_num q)))
  = (mk_real (treal_eq (treal_of_num p)) + mk_real (treal_eq (treal_of_num q)))%R.
Proof.
  rewrite add_eq. unfold mk_real. f_equal. rewrite !real_of_R_of_real.
  rewrite <- treal_eq_of_num_add.
  change (real_of_num (p + q) = add (real_of_num p) (real_of_num q)).
  rewrite real_add_of_num. reflexivity.
Qed.

Lemma IPR_eq_mk_real p : IPR p = mk_real (treal_eq (treal_of_num (N.pos p))).
Proof.
  pattern p; revert p; apply Pos.peano_ind.
  apply one_eq.
  intros p hp. rewrite succ_IPR Rplus_comm.
  assert (e: IPR 1 = mk_real (treal_eq (treal_of_num 1))). apply one_eq.
  rewrite hp e Npos_succ -mk_real_treal_eq_add -treal_eq_of_num_add.
  reflexivity.
Qed.

Lemma real_of_num_def : R_of_N = (fun m : N => mk_real (fun u : prod hreal hreal => treal_eq (treal_of_num m) u)).
Proof.
  ext=>n.
  change (R_of_N n = mk_real (treal_eq (treal_of_num n))).
  destruct n; simpl. apply zero_eq. apply IPR_eq_mk_real.
Qed.

Lemma R_of_N0 : R_of_N 0 = 0%R.
Proof. reflexivity. Qed.

Lemma R_of_N1 : R_of_N 1 = 1%R.
Proof. reflexivity. Qed.

Lemma Rnot_le x y : (~ x <= y) = (x > y).
Proof.
  apply prop_ext; intro h.
  apply Rnot_le_gt. exact h.
  apply Rgt_not_le. exact h.
Qed.

Lemma real_abs_def :
  Rabs = (fun y0 : R => @COND R (Rle (R_of_N (NUMERAL 0)) y0) y0 (Ropp y0)).
Proof.
  ext=>r. rewrite/Rabs/NUMERAL R_of_N0. symmetry. destruct (Rcase_abs r).
  - if_triv using Rgt_not_le.
  - if_triv using Rge_le.
Qed.

Lemma real_div_def : Rdiv = (fun y0 : R => fun y1 : R => Rmult y0 (Rinv y1)).
Proof.
  ext. reflexivity.
Qed.

Lemma real_sub_def : Rminus = (fun y0 : R => fun y1 : R => Rplus y0 (Ropp y1)).
Proof.
  ext. reflexivity.
Qed.

Lemma real_ge_def : Rge = (fun y0 : R => fun y1 : R => Rle y1 y0).
Proof.
  ext=> x y h.
  apply Rge_le. exact h. apply Rle_ge. exact h.
Qed.

Lemma real_gt_def : Rgt = (fun y0 : R => fun y1 : R => Rlt y1 y0).
Proof.
  ext=> x y h.
  apply Rgt_lt. exact h. apply Rlt_gt. exact h.
Qed.

Lemma real_lt_def : Rlt = (fun y0 : R => fun y1 : R => ~ (Rle y1 y0)).
Proof.
  ext=> x y h.
  rewrite Rnot_le. exact h. rewrite Rnot_le in h. exact h.
Qed.

Lemma real_max_def : Rmax = (fun y0 : R => fun y1 : R => @COND R (Rle y0 y1) y1 y0).
Proof.
  ext=> x y. unfold Rmax.
  destruct (Rle_dec x y) ; if_triv.
Qed.

Lemma real_min_def : Rmin = (fun y0 : R => fun y1 : R => @COND R (Rle y0 y1) y0 y1).
Proof.
  ext=> x y. unfold Rmin.
  destruct (Rle_dec x y) ; if_triv.
Qed.

Definition Rpow (r : R) n : R := powerRZ r (Z.of_N n).

(* either leave it like that or adapt the ext n tactic to work within R_scope. *)
Close Scope R_scope.

Lemma real_pow_def : Rpow = (@ε ((prod N (prod N (prod N (prod N (prod N (prod N (prod N N))))))) -> R -> N -> R) (fun real_pow' : (prod N (prod N (prod N (prod N (prod N (prod N (prod N N))))))) -> R -> N -> R => forall _24085 : prod N (prod N (prod N (prod N (prod N (prod N (prod N N)))))), (forall x : R, (real_pow' _24085 x (NUMERAL 0%N)) = (R_of_N (NUMERAL (BIT1 0%N)))) /\ (forall x : R, forall n : N, (real_pow' _24085 x (N.succ n)) = (Rmult x (real_pow' _24085 x n)))) (@pair N (prod N (prod N (prod N (prod N (prod N (prod N N)))))) (NUMERAL (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N (prod N (prod N (prod N N))))) (NUMERAL (BIT1 (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N (prod N (prod N N)))) (NUMERAL (BIT1 (BIT0 (BIT0 (BIT0 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N (prod N N))) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N N)) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 0%N)))))))) (@pair N (prod N N) (NUMERAL (BIT0 (BIT0 (BIT0 (BIT0 (BIT1 (BIT1 (BIT1 0%N)))))))) (@pair N N (NUMERAL (BIT1 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 0%N)))))))) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 (BIT1 0%N)))))))))))))))).
Proof.
  N_rec_align.
  intros x n. unfold Rpow. rewrite <- !Znat.N_nat_Z.
  rewrite <- !Rfunctions.pow_powerRZ.
  rewrite Nnat.N2Nat.inj_succ. reflexivity.
Qed.

Open Scope R_scope.

Definition Rsgn r := r / Rabs r.

Lemma Rsgn_0 : Rsgn 0 = 0.
Proof. unfold Rsgn. lra. Qed.

Lemma Rsgn_pos r : r > 0 -> Rsgn r = 1.
Proof.
  intro h.
  unfold Rsgn.
  rewrite Rabs_pos_eq. 2: lra.
  rewrite Rdiv_diag. 2: lra.
  reflexivity.
Qed.

Lemma Rsgn_neg r : r < 0 -> Rsgn r = -1.
Proof.
  intro h.
  unfold Rsgn.
  rewrite Rabs_left. 2: assumption.
  rewrite Rdiv_opp_r.
  rewrite Rdiv_diag. 2: lra.
  reflexivity.
Qed.

Lemma real_sgn_def : Rsgn = (fun _26598 : R => @COND R (Rlt (R_of_N (NUMERAL 0%N)) _26598) (R_of_N (NUMERAL (BIT1 0%N))) (@COND R (Rlt _26598 (R_of_N (NUMERAL 0%N))) (Ropp (R_of_N (NUMERAL (BIT1 0%N)))) (R_of_N (NUMERAL 0%N)))).
Proof.
  unfold Rsgn.
  ext=> r. cbn.
  repeat if_intro=>*.
  - now apply Rsgn_pos.
  - now apply Rsgn_neg.
  - replace r with 0 ; lra.
Qed.

(*****************************************************************************)
(* Mapping of integers. *)
(*****************************************************************************)

HB.instance Definition _ := is_Type' (0 : Z).

Definition int_of_real r := Z.pred (up r).

Lemma axiom_25 : forall (a : Z), (int_of_real (IZR a)) = a.
Proof.
  intro k. unfold int_of_real. generalize (archimed (IZR k)).
  generalize (up (IZR k)); intros l [h1 h2].
  apply lt_IZR in h1. rewrite <- minus_IZR in h2. apply le_IZR in h2. lia.
Qed.

Definition integer : R -> Prop := fun _28588 : R => exists n : N, (Rabs _28588) = (R_of_N n).

Lemma integer_def : integer = (fun _28715 : R => exists n : N, (Rabs _28715) = (R_of_N n)).
Proof. reflexivity. Qed.

Lemma minus_eq_minus x y : -x = y -> x = - y.
Proof. intro e. subst y. symmetry. apply Ropp_involutive. Qed.

Lemma integer_IZR r : integer r -> exists k, r = IZR k.
Proof.
  intros [n h]. destruct (Rcase_abs r) as [i|i].

  rewrite (Rabs_left _ i) in h. apply minus_eq_minus in h. subst r. clear i.
  pattern n; revert n; apply N.peano_ind.
  exists 0%Z. rewrite R_of_N0. ring.
  intros n [k hk]. rewrite R_of_N_succ.
  exists (k - 1)%Z. rewrite minus_IZR -hk. ring.

  rewrite (Rabs_right _ i) in h. subst r. clear i.
  pattern n; revert n; apply N.peano_ind.
  exists 0%Z. rewrite R_of_N0. reflexivity.
  intros n [k hk]. rewrite R_of_N_succ.
  exists (k + 1)%Z. rewrite plus_IZR -hk. reflexivity.
Qed.

Definition Zabs (z:Z): N :=
  match z with
  | Z0 => N0
  | Zpos p => N.pos p
  | Zneg p => N.pos p
  end.

Lemma pos_succ p : N.pos (Pos.succ p) = N.succ (N.pos p).
Proof. induction p; simpl; reflexivity. Qed.

Lemma IZR_pos_eq_R_of_N_pos p: IZR (Z.pos p) = R_of_N (N.pos p).
Proof.
  pattern p; revert p; apply Pos.peano_ind.
  rewrite R_of_N1. reflexivity.
  intros p hp. rewrite Pos2Z.inj_succ succ_IZR pos_succ R_of_N_succ hp.
  reflexivity.
Qed.

Lemma IZR_integer r : (exists k, r = IZR k) -> integer r.
Proof.
  intros [k h]. subst r. exists (Zabs k). rewrite <- abs_IZR. destruct k; simpl.
  rewrite <- R_of_N0. reflexivity. apply IZR_pos_eq_R_of_N_pos.
  apply IZR_pos_eq_R_of_N_pos.
Qed.

Lemma axiom_26 : forall (r : R), ((fun x : R => integer x) r) = ((IZR (int_of_real r)) = r).
Proof.
  intro r. apply prop_ext; intro h.
  apply integer_IZR in h. destruct h as [k h]. subst r. apply f_equal.
  apply axiom_25.
  apply IZR_integer. exists (int_of_real r). symmetry. exact h.
Qed.

Definition Z_of_N (n:N): Z :=
  match n with
  | N0 => Z0
  | N.pos p => Z.pos p
  end.

Lemma Z_of_N_succ n : Z_of_N (N.succ n) = (Z_of_N n + 1)%Z.
Proof.
  destruct n. reflexivity.
  pattern p; revert p; apply Pos.peano_ind.
  reflexivity.
  intro p. simpl. lia.
Qed.

Require Import Stdlib.Reals.R_Ifp.

Lemma up_IZR z : up (IZR z) = (z + 1)%Z.
Proof. symmetry; apply tech_up; rewrite plus_IZR; lra.
Qed.

Lemma up_shiftz r z : up (r + IZR z)%R = (up r + z)%Z.
Proof. assert (H := archimed r). symmetry; apply tech_up; rewrite plus_IZR; lra. Qed.

Lemma up0 : up 0 = 1%Z.
Proof. apply up_IZR. Qed.

Lemma up_succ r : up (r + 1) = (up r + 1)%Z.
Proof. apply up_shiftz. Qed.

Lemma int_of_num_def : Z_of_N = (fun _28789 : N => int_of_real (R_of_N _28789)).
Proof.
  ext=> n; pattern n; revert n; apply N.peano_ind; unfold int_of_real.
  rewrite R_of_N0 up0. reflexivity.
  intro n. unfold int_of_real. rewrite Z_of_N_succ R_of_N_succ up_succ. lia.
Qed.

Lemma int_le_def :
  Z.le = (fun _28741 : Z => fun _28742 : Z => Rle (IZR _28741) (IZR _28742)).
Proof.
  ext=> n m.
  - apply IZR_le.
  - apply le_IZR.
Qed.

Lemma int_lt_def :
  Z.lt = (fun _28753 : Z => fun _28754 : Z => Rlt (IZR _28753) (IZR _28754)).
Proof.
  ext=> n m.
  - apply IZR_lt.
  - apply lt_IZR.
Qed.

Lemma int_ge_def :
  Z.ge = (fun _28765 : Z => fun _28766 : Z => Rge (IZR _28765) (IZR _28766)).
Proof.
  rewrite real_ge_def.
  ext=> n m.
  - intros h%Z.ge_le. apply IZR_le. assumption.
  - intros h. apply Z.le_ge. apply le_IZR. assumption.
Qed.

Lemma int_gt_def :
  Z.gt = (fun _28777 : Z => fun _28778 : Z => Rgt (IZR _28777) (IZR _28778)).
Proof.
  rewrite real_gt_def.
  ext=> n m.
  - intros h%Z.gt_lt. apply IZR_lt. assumption.
  - intros h. apply Z.lt_gt. apply lt_IZR. assumption.
Qed.

Lemma int_neg_def :
  Z.opp = (fun _28794 : Z => int_of_real (Ropp (IZR _28794))).
Proof.
  ext=> n.
  rewrite <- opp_IZR. rewrite axiom_25.
  reflexivity.
Qed.

Lemma int_add_def :
  Z.add = (fun _28803 : Z => fun _28804 : Z => int_of_real (Rplus (IZR _28803) (IZR _28804))).
Proof.
  ext=> n m.
  rewrite <- plus_IZR. rewrite axiom_25.
  reflexivity.
Qed.

Lemma int_sub_def :
  Z.sub = (fun _28835 : Z => fun _28836 : Z => int_of_real (Rminus (IZR _28835) (IZR _28836))).
Proof.
  ext=> n m.
  rewrite <- minus_IZR. rewrite axiom_25.
  reflexivity.
Qed.

Lemma int_mul_def :
  Z.mul =
  (fun _28847 : Z => fun _28848 : Z => int_of_real (Rmult (IZR _28847) (IZR _28848))).
Proof.
  ext=> n m.
  rewrite <- mult_IZR. rewrite axiom_25.
  reflexivity.
Qed.

Lemma int_abs_def :
  Z.abs = (fun _28867 : Z => int_of_real (Rabs (IZR _28867))).
Proof.
  ext=> n.
  rewrite Rabs_Zabs. rewrite axiom_25.
  reflexivity.
Qed.

Lemma int_sgn_def :
  Z.sgn = (fun _28878 : Z => int_of_real (Rsgn (IZR _28878))).
Proof.
  ext=> [[]] *. all : cbn.
  - rewrite Rsgn_0. rewrite axiom_25. reflexivity.
  - rewrite Rsgn_pos.
    2:{ apply IZR_lt. lia. }
    rewrite axiom_25. reflexivity.
  - rewrite Rsgn_neg.
    2:{ apply IZR_lt. lia. }
    rewrite axiom_25. reflexivity.
Qed.

Lemma int_max_def :
  Z.max = (fun _28938 : Z => fun _28939 : Z => int_of_real (Rmax (IZR _28938) (IZR _28939))).
Proof.
  ext=> n m.
  eapply Rmax_case_strong. all: intro h. all: apply le_IZR in h.
  - rewrite Z.max_l. 2: lia.
    rewrite axiom_25. reflexivity.
  - rewrite Z.max_r. 2: lia.
    rewrite axiom_25. reflexivity.
Qed.

Lemma int_min_def :
  Z.min = (fun _28956 : Z => fun _28957 : Z => int_of_real (Rmin (IZR _28956) (IZR _28957))).
Proof.
  ext=> n m.
  eapply Rmin_case_strong. all: intro h. all: apply le_IZR in h.
  - rewrite Z.min_l. 2: lia.
    rewrite axiom_25. reflexivity.
  - rewrite Z.min_r. 2: lia.
    rewrite axiom_25. reflexivity.
Qed.

Definition Zpow n m := (n ^ Z.of_N m)%Z.

Lemma int_pow_def :
  Zpow = (fun _28974 : Z => fun _28975 : N => int_of_real (Rpow (IZR _28974) _28975)).
Proof.
  ext=> n m.
  rewrite <- (Nnat.N2Nat.id m).
  generalize (N.to_nat m) as k. clear m. intro m.
  unfold Zpow, Rpow.
  rewrite Znat.nat_N_Z.
  rewrite <- Rfunctions.pow_powerRZ.
  rewrite <- axiom_25 at 1. f_equal.
  induction m as [| m ih].
  - cbn. reflexivity.
  - rewrite Znat.Nat2Z.inj_succ. rewrite Z.pow_succ_r. 2: lia.
    rewrite mult_IZR. rewrite ih. reflexivity.
Qed.

Definition Zdiv a b := (Z.sgn b * (a / Z.abs b))%Z.
(* = Stdlib.ZArith.Zeuclid.ZEuclid.div but Stdlib.ZArith.Zeuclid is deprecated *)

Definition Zrem a b := (a mod Z.abs b)%Z.
(* = Stdlib.ZArith.Zeuclid.ZEuclid.modulo but Stdlib.ZArith.Zeuclid is deprecated *)

Close Scope R_scope.

Lemma div_def :
  Zdiv = (@ε ((prod N (prod N N)) -> Z -> Z -> Z) (fun q : (prod N (prod N N)) -> Z -> Z -> Z => forall _29326 : prod N (prod N N), exists r : Z -> Z -> Z, forall m : Z, forall n : Z, @COND Prop (n = (Z_of_N (NUMERAL 0%N))) (((q _29326 m n) = (Z_of_N (NUMERAL 0%N))) /\ ((r m n) = m)) ((Z.le (Z_of_N (NUMERAL 0%N)) (r m n)) /\ ((Z.lt (r m n) (Z.abs n)) /\ (m = (Z.add (Z.mul (q _29326 m n) n) (r m n)))))) (@pair N (prod N N) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N N (NUMERAL (BIT1 (BIT0 (BIT0 (BIT1 (BIT0 (BIT1 (BIT1 0%N)))))))) (NUMERAL (BIT0 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 (BIT1 0%N))))))))))).
Proof.
  align_ε.
  { exists Zrem. unfold Zdiv, Zrem. cbn. intros m n.
    if_intro=>*.
    - subst n. cbn. split.
      + reflexivity.
      + apply Zdiv.Zmod_0_r.
    - assert (han : (0 < Z.abs n)%Z).
      { pose proof (Z.abs_nonneg n). lia. }
      split. 2: split.
      + apply Z.mod_pos_bound. assumption.
      + apply Z.mod_pos_bound. assumption.
      + pose proof (Z.div_mod m (Z.abs n)). lia.
  }
  cbn. intros div' _ [rem h].
  ext=> m n. specialize (h m n).
  eapply if_elim with (1 := h) ; clear.
  - unfold Zdiv. intros -> [-> e].
    cbn. reflexivity.
  - intros hnz [h1 [h2 h3]].
    assert (Z.sgn n * div' m n = m / Z.abs n)%Z as e.
    { apply Z.div_unique_pos with (rem m n). all: lia. }
    unfold Zdiv. lia.
Qed.

Lemma rem_def :
  Zrem = (@ε ((prod N (prod N N)) -> Z -> Z -> Z) (fun r : (prod N (prod N N)) -> Z -> Z -> Z => forall _29327 : prod N (prod N N), forall m : Z, forall n : Z, @COND Prop (n = (Z_of_N (NUMERAL 0%N))) (((Zdiv m n) = (Z_of_N (NUMERAL 0%N))) /\ ((r _29327 m n) = m)) ((Z.le (Z_of_N (NUMERAL 0%N)) (r _29327 m n)) /\ ((Z.lt (r _29327 m n) (Z.abs n)) /\ (m = (Z.add (Z.mul (Zdiv m n) n) (r _29327 m n)))))) (@pair N (prod N N) (NUMERAL (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 (BIT1 0%N)))))))) (@pair N N (NUMERAL (BIT1 (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 0%N)))))))) (NUMERAL (BIT1 (BIT0 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 0%N))))))))))).
Proof.
  align_ε.
  { unfold Zdiv, Zrem. intros m n.
    if_intro=>*.
    - subst n. cbn. split.
      + reflexivity.
      + apply Zdiv.Zmod_0_r.
    - cbn in *.
      assert (han : (0 < Z.abs n)%Z).
      { pose proof (Z.abs_nonneg n). lia. }
      split. 2: split.
      + apply Z.mod_pos_bound. assumption.
      + apply Z.mod_pos_bound. assumption.
      + pose proof (Z.div_mod m (Z.abs n)). lia.
  }
  cbn. intros rem' _ h.
  ext=> m n. specialize (h m n).
  eapply if_elim with (1 := h) ; clear.
  - unfold Zdiv, Zrem. intros -> [e ->].
    cbn. apply Zdiv.Zmod_0_r.
  - unfold Zdiv, Zrem. intros hnz [h1 [h2 h3]].
    pose proof (Z.div_mod m (Z.abs n)) as e.
    rewrite <- Z.sgn_abs in e at 1.
    lia.
Qed.

Open Scope R_scope.

Lemma Zdiv_pos a b : (0 < b)%Z -> Zdiv a b = Z.div a b.
Proof.
  intro h. unfold Zdiv. rewrite Z.sgn_pos. 2: assumption.
  rewrite Z.abs_eq. 2: lia. lia.
Qed.

Definition Rmod_eq (a b c : R) := exists k, b - c = IZR k * a.

Lemma real_mod_def :
  Rmod_eq = (fun _29623 : R => fun _29624 : R => fun _29625 : R => exists q : R, (integer q) /\ ((Rminus _29624 _29625) = (Rmult q _29623))).
Proof.
  ext=> a b c; rewrite/Rmod_eq.
  - intros [k e]. exists (IZR k). split.
    + apply IZR_integer. eexists. reflexivity.
    + assumption.
  - intros [q [hq e]].
    apply integer_IZR in hq as [k ->].
    exists k. assumption.
Qed.

Lemma int_divides_def :
  Z.divide = (fun _29644 : Z => fun _29645 : Z => exists x : Z, _29645 = (Z.mul _29644 x)).
Proof.
  ext=>a b.
  - apply PreOmega.Z.divide_alt.
  - intros [c e]. eapply Znumtheory.Zdivide_intro with c. lia.
Qed.

Definition int_coprime '(a,b) := exists x y, (a * x + b * y = 1)%Z.

Lemma int_coprime_def :
  int_coprime = (fun _29691 : prod Z Z => exists x : Z, exists y : Z, (Z.add (Z.mul (@fst Z Z _29691) x) (Z.mul (@snd Z Z _29691) y)) = (Z_of_N (NUMERAL (BIT1 0%N)))).
Proof.
  by ext;case.
Qed.

Definition int_gcd '(a,b) := Z.gcd a b.

Close Scope R_scope.

Lemma int_gcd_def :
  int_gcd = (@ε ((prod N (prod N (prod N (prod N (prod N (prod N N)))))) -> (prod Z Z) -> Z) (fun d : (prod N (prod N (prod N (prod N (prod N (prod N N)))))) -> (prod Z Z) -> Z => forall _30960 : prod N (prod N (prod N (prod N (prod N (prod N N))))), forall a : Z, forall b : Z, (Z.le (Z_of_N (NUMERAL 0%N)) (d _30960 (@pair Z Z a b))) /\ ((Z.divide (d _30960 (@pair Z Z a b)) a) /\ ((Z.divide (d _30960 (@pair Z Z a b)) b) /\ (exists x : Z, exists y : Z, (d _30960 (@pair Z Z a b)) = (Z.add (Z.mul a x) (Z.mul b y)))))) (@pair N (prod N (prod N (prod N (prod N (prod N N))))) (NUMERAL (BIT1 (BIT0 (BIT0 (BIT1 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N (prod N (prod N N)))) (NUMERAL (BIT0 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N (prod N N))) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT0 (BIT1 (BIT1 (BIT1 0%N)))))))) (@pair N (prod N (prod N N)) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 0%N)))))))) (@pair N (prod N N) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 0%N)))))))) (@pair N N (NUMERAL (BIT1 (BIT1 (BIT0 (BIT0 (BIT0 (BIT1 (BIT1 0%N)))))))) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 0%N))))))))))))))).
Proof.
  cbn. align_ε. unfold int_gcd.
  - intros a b. split. 2: split. 3: split.
    + apply Z.gcd_nonneg.
    + apply Z.gcd_divide_l.
    + apply Z.gcd_divide_r.
    + pose proof (Z.gcd_bezout a b (Z.gcd a b) erefl) as [x [y h]].
      exists x, y. lia.
  - intros gcd' _ h.
    ext=> [[a b]].
    specialize (h a b) as [hnn [hdl [hdr [x [y e]]]]].
    apply Z.gcd_unique. 1-3: assumption.
    intros q ha hb. rewrite e.
    apply Z.divide_add_r.
    + apply Z.divide_mul_l. assumption.
    + apply Z.divide_mul_l. assumption.
Qed.

Definition int_lcm '(a,b) := Z.lcm a b.

Lemma int_lcm_def :
  int_lcm = (fun y0 : prod Z Z => @COND Z ((Z.mul (@fst Z Z y0) (@snd Z Z y0)) = (Z_of_N (NUMERAL 0%N))) (Z_of_N (NUMERAL 0%N)) (Zdiv (Z.abs (Z.mul (@fst Z Z y0) (@snd Z Z y0))) (int_gcd (@pair Z Z (@fst Z Z y0) (@snd Z Z y0))))).
Proof.
  unfold int_lcm, int_gcd. cbn.
  ext=>[[a b]]. cbn.
  if_intro=>*.
  - rewrite Z.lcm_eq_0. lia.
  - set (m := Z.lcm a b).
    set (d := (Z.abs(a * b) / m)%Z).
    assert (hmnz : m <> 0%Z).
    { pose proof (Z.lcm_eq_0 a b). 
       lia.
    }
    assert (hmab : (Z.abs (a * b) mod m)%Z = 0%Z).
    { apply Znumtheory.Zdivide_mod.
      rewrite Z.divide_abs_r.
      apply Z.lcm_least.
      - apply Z.divide_mul_l. reflexivity.
      - apply Z.divide_mul_r. reflexivity.
    }
    assert (h : Z.gcd a b = d).
    { apply Z.gcd_unique.
      - apply Zdiv.Z_div_nonneg_nonneg.
        + lia.
        + apply Z.lcm_nonneg.
      - unfold d.
        assert (h : (b | m)%Z).
        { apply Z.divide_lcm_r. }
        apply Z.mul_divide_mono_l with (p := a) in h.
        apply Z.divide_abs_l in h.
        apply Z.divide_div with (a := m) in h.
        2: assumption.
        2:{ apply Z.mod_divide. all: assumption. }
        rewrite Znumtheory.Zdivide_Zdiv_eq_2 in h.
        2:{ pose proof (Z.lcm_nonneg a b). lia. }
        2: reflexivity.
        rewrite Z.div_same in h. 2: assumption.
        replace (a * 1)%Z with a in h by lia.
        assumption.
      - unfold d.
        assert (h : (a | m)%Z).
        { apply Z.divide_lcm_l. }
        apply Z.mul_divide_mono_r with (p := b) in h.
        apply Z.divide_abs_l in h.
        apply Z.divide_div with (a := m) in h.
        2: assumption.
        2:{ apply Z.mod_divide. all: assumption. }
        replace (m * b)%Z with (b * m)%Z in h by lia.
        rewrite Znumtheory.Zdivide_Zdiv_eq_2 in h.
        2:{ pose proof (Z.lcm_nonneg a b). lia. }
        2: reflexivity.
        rewrite Z.div_same in h. 2: assumption.
        replace (b * 1)%Z with b in h by lia.
        assumption.
      - intros n ha hb.
        assert (hnnz : n <> 0%Z).
        { destruct ha as [k e]. lia. }
        assert (hndm : (n | m)%Z).
        { transitivity b. 1: assumption. apply Z.divide_lcm_r. }
        replace n with (m * n / m)%Z.
        2:{ rewrite Z.mul_comm. apply Z.div_mul. assumption. }
        replace d with (m * d / m)%Z.
        2:{ rewrite Z.mul_comm. apply Z.div_mul. assumption. }
        apply Z.divide_div.
        1: assumption. 1:{ apply Z.divide_mul_l. reflexivity. }
        replace (m * d)%Z with (((m * d) / n) * n)%Z.
        2:{
          replace (m * d)%Z with (d * m)%Z by lia.
          rewrite Z.divide_div_mul_exact. 2,3: assumption.
          rewrite <- Z.mul_assoc.
          rewrite Z.mul_comm.
          replace ((m / n) * n)%Z with (n * (m / n))%Z by lia.
          rewrite <- Zdiv.Z_div_exact_full_2. 2: assumption.
          2:{ apply Znumtheory.Zdivide_mod. assumption. }
          lia.
        }
        apply Z.mul_divide_mono_r.
        replace (m * d / n)%Z with (Z.abs (a * b) / n)%Z.
        2:{
          unfold d.
          rewrite <- Zdiv.Z_div_exact_full_2. 2,3: assumption.
          lia.
        }
        apply Z.lcm_least.
        + replace a with ((n * a) / n)%Z at 1.
          2:{
            rewrite Z.divide_div_mul_exact. 2,3: assumption.
            rewrite <- Zdiv.Z_div_exact_full_2. 2: assumption.
            2:{ apply Znumtheory.Zdivide_mod. assumption. }
            reflexivity.
          }
          apply Z.divide_div. 1: assumption.
          1:{ apply Z.divide_mul_l. reflexivity. }
          rewrite Z.divide_abs_r.
          rewrite Z.mul_comm.
          apply Z.mul_divide_mono_l.
          assumption.
        + replace b with ((n * b) / n)%Z at 1.
          2:{
            rewrite Z.divide_div_mul_exact. 2,3: assumption.
            rewrite <- Zdiv.Z_div_exact_full_2. 2: assumption.
            2:{ apply Znumtheory.Zdivide_mod. assumption. }
            reflexivity.
          }
          apply Z.divide_div. 1: assumption.
          1:{ apply Z.divide_mul_l. reflexivity. }
          rewrite Z.divide_abs_r.
          apply Z.mul_divide_mono_r.
          assumption.
    }
    unfold d in h.
    apply (f_equal (Z.mul m)) in h as e.
    rewrite <- Zdiv.Z_div_exact_full_2 in e. 2,3: assumption.
    apply (f_equal (fun x => (x / Z.gcd a b)%Z)) in e.
    assert (hgcd : Z.gcd a b <> 0%Z).
    { pose proof (Z.gcd_divide_r a b) as []. lia. }
    rewrite Z.divide_div_mul_exact in e. 2: assumption. 2: reflexivity.
    rewrite Z.div_same in e. 2: assumption.
    rewrite Zdiv_pos.
    2:{ pose proof (Z.gcd_nonneg a b). lia. }
    lia.
Qed.

(*****************************************************************************)
(* Sets. *)
(*****************************************************************************)
Require Import Stdlib.Lists.List.
Require Import mathcomp.classical.all_classical.
Open Scope classical_set_scope.

Import boolp ssrbool type.

Definition IN (A : Type) (a : A) (s : set A) : Prop := in_set s a.

Lemma IN_def {A : Type'} : @IN A = (fun _32317 : A => fun _32318 : A -> Prop => _32318 _32317).
Proof.
  exact (funext (fun a => funext (fun s => in_setE s a))).
Qed.

Lemma EMPTY_def (A : Type') : set0 = (fun x : A => False).
Proof.
  ext=>x H ; inversion H.
Qed.

Definition INSERT (A : Type) (a : A) s := a |` s.

Lemma INSERT_def (A : Type') : @INSERT A = (fun _32373 : A => fun _32374 : A -> Prop => fun y : A => (@IN A y _32374) \/ (y = _32373)).
Proof.
  by ext=>a E a'; rewrite thm_DISJ_SYM IN_def.
Qed.

Lemma UNIV_def (A : Type') : [set : A] = (fun x : A => True).
Proof. reflexivity. Qed.

Definition GSPEC (A : Type') := @id (set A).
Lemma GSPEC_def (A : Type') : @GSPEC A = (fun _32329 : A -> Prop => _32329).
Proof. reflexivity. Qed.

Definition SETSPEC (A : Type) (x : A) P := [set x' | P /\ x=x'].

Lemma SETSPEC_def (A : Type') : (@SETSPEC A) = (fun _32334 : A => fun _32335 : Prop => fun _32336 : A => _32335 /\ (_32334 = _32336)).
Proof. exact erefl. Qed.

(* Eliminating useless GSPEC and SETSPEC combination *)
Lemma SPEC_elim (A : Type') {P : A -> Prop} : GSPEC (fun x => exists x', SETSPEC x (P x') x') = P.
Proof.
  ext=> x H. destruct H as (x', (HP , e)). now subst x'.
  now exists x.
Qed.

Lemma SUBSET_def (A : Type') : subset = (fun _32443 : A -> Prop => fun _32444 : A -> Prop => forall x : A, (@IN A x _32443) -> @IN A x _32444).
Proof. now rewrite IN_def. Qed.

Lemma UNION_def (A : Type') : setU = (fun _32385 : A -> Prop => fun _32386 : A -> Prop => @GSPEC A (fun GEN_PVAR_0 : A => exists x : A, @SETSPEC A GEN_PVAR_0 ((@IN A x _32385) \/ (@IN A x _32386)) x)).
Proof.
  by ext=> B C x ; rewrite SPEC_elim IN_def.
Qed.

Lemma INTER_def (A : Type') : setI = (fun _32402 : A -> Prop => fun _32403 : A -> Prop => @GSPEC A (fun GEN_PVAR_2 : A => exists x : A, @SETSPEC A GEN_PVAR_2 ((@IN A x _32402) /\ (@IN A x _32403)) x)).
Proof.
  by ext=> B C x ; rewrite SPEC_elim IN_def.
Qed.

Definition UNIONS (A : Type') (s : set (set A)) :=
  [set a | exists s0, in_set s s0 /\ in_set s0 a].

Lemma UNIONS_def (A : Type') : (@UNIONS A) = (fun _32397 : (A -> Prop) -> Prop => @GSPEC A (fun GEN_PVAR_1 : A => exists x : A, @SETSPEC A GEN_PVAR_1 (exists u : A -> Prop, (@IN (A -> Prop) u _32397) /\ (@IN A x u)) x)).
Proof.
  apply funext=>s. symmetry. exact SPEC_elim.
Qed.

Definition INTERS (A : Type') (s : set (set A)) :=
  [set a | forall s0, in_set s s0 -> in_set s0 a].

Lemma INTERS_def (A : Type') : @INTERS A = (fun _32414 : (A -> Prop) -> Prop => @GSPEC A (fun GEN_PVAR_3 : A => exists x : A, @SETSPEC A GEN_PVAR_3 (forall u : A -> Prop, (@IN (A -> Prop) u _32414) -> @IN A x u) x)).
Proof.
  apply funext => E. symmetry. exact SPEC_elim.
Qed.

Definition IMAGE {A B : Type} (f : A -> B) s := [set (f x) | x in s].

Lemma IMAGE_def {A B : Type'} : (@IMAGE A B) = (fun _32493 : A -> B => fun _32494 : A -> Prop => @GSPEC B (fun GEN_PVAR_7 : B => exists y : B, @SETSPEC B GEN_PVAR_7 (exists x : A, (@IN A x _32494) /\ (y = (_32493 x))) y)).
Proof.
  ext 3 => f E b. unfold IMAGE,image. simpl. rewrite SPEC_elim exists2E.
  apply prop_ext ; intros (a, (H,H')) ; rewrite -> IN_def in * ; breakgoal.
Qed.

(* Variant *)
Lemma SPEC_IMAGE {A B : Type'} {f : A -> B} {s : set A} :
  GSPEC (fun x => exists x', SETSPEC x (IN x' s) (f x')) = [set (f x) | x in s].
Proof. fold (IMAGE f s). now rewrite IMAGE_def SPEC_elim. Qed.

Lemma DIFF_def (A : Type') : setD = (fun _32419 : A -> Prop => fun _32420 : A -> Prop => @GSPEC A (fun GEN_PVAR_4 : A => exists x : A, @SETSPEC A GEN_PVAR_4 ((@IN A x _32419) /\ (~ (@IN A x _32420))) x)).
Proof.
  by ext=> B C ; rewrite SPEC_elim IN_def.
Qed.

Definition DELETE (A : Type') s (a : A) := s `\ a.

Lemma DELETE_def (A : Type') : @DELETE A = (fun _32431 : A -> Prop => fun _32432 : A => @GSPEC A (fun GEN_PVAR_6 : A => exists y : A, @SETSPEC A GEN_PVAR_6 ((@IN A y _32431) /\ (~ (y = _32432))) y)).
Proof.
  by ext=> s a ; rewrite SPEC_elim IN_def.
Qed.

Lemma PSUBSET_def (A : Type') : proper = (fun _32455 : A -> Prop => fun _32456 : A -> Prop => (@subset A _32455 _32456) /\ (~ (_32455 = _32456))).
Proof.
  ext 2 => s s'. rewrite properEneq thm_CONJ_SYM. f_equal.
  now rewrite <- asboolE, asbool_neg.
Qed.

Notation "@DISJOINT" := (@disj_set : forall T, set T -> set T -> Prop) (only parsing).

Lemma DISJOINTdef (A : Type') : @DISJOINT A = (fun _32467 : A -> Prop => fun _32468 : A -> Prop => (@setI A _32467 _32468) = (@set0 A)) :> (set A -> set A -> Prop).
Proof.
  by ext 2 => B C ; rewrite <- asboolE.
Qed.

Definition is_set1 (A : Type) (s : set A) := exists a, s = [set a].

Lemma SING_def (A : Type') : @is_set1 A = (fun _32479 : A -> Prop => exists x : A, _32479 = (@INSERT A x (@set0 A))).
Proof.
  ext => s [x H] ; exists x.
  by rewrite/INSERT setU0. by rewrite/INSERT setU0 in H.
Qed.

(* ssimpl simplifies HOL_Light set objects to rocq ones in, I believe,
   the most suitable way. Maybe it would be better for some to unfold IN
   as the boolean predicate instead of rewriting it to the Prop one. *)
Ltac ssimpl :=
  rewrite ?SPEC_IMAGE?SPEC_elim/GSPEC/SETSPEC/DELETE/IMAGE/INTERS/UNIONS/
  INSERT/BIT1/BIT0/NUMERAL?setU0?IN_def.

(*****************************************************************************)
(* Finite sets. *)
(*****************************************************************************)

(* mathcomp : in bijection with {0 ; ... ; n-1} for some n *)

Lemma FINITE_def (A : Type') : finite_set = (fun a : A -> Prop => forall FINITE' : (A -> Prop) -> Prop, (forall a' : A -> Prop, ((a' = (@set0 A)) \/ (exists x : A, exists s : A -> Prop, (a' = (@INSERT A x s)) /\ (FINITE' s))) -> FINITE' a') -> FINITE' a).
Proof.
  ssimpl. ind_align.
  - revert x H ; elim:x0=>[s|n IHn s /eq_cardSP [a sa s_min_a]].
    by rewrite II0 card_eq0 => /eqP-> ; left.
    right ; exist a (s `\ a) ; split ; first by rewrite setD1K.
    exact (H' _ (IHn _ s_min_a)).
  - exact (finite_set0 _).
  - by rewrite finite_setU.
Qed.

(* Inductive version, like the one in HOL-Light and in Rocq's Stdlib : *)
Inductive finite' (A : Type) : set A -> Prop :=
|finite'_set0 : finite' set0
|finite'_setU1 s a : finite' s -> finite' (a |` s).

Lemma finite_as_ind (A : Type') : finite_set = @finite' A.
Proof. by symmetry ; rewrite FINITE_def ; ind_align. Qed.

(* Version using lists *)
Import seq.
Open Scope list_scope.
Definition set_of_list (A : Type') (l : list A) : A -> Prop := [set` l].

Lemma set_cons (A : Type') (a : A) (l : list A) :
  [set` a::l] = a |` [set` l].
Proof.
  rewrite predeqP /= => x.
  rewrite in_cons ; split ; first move/orP ; move => [Hxa | Hxl] ; only 2 : by auto.
  - by left ; apply/eqP :Hxa.
  - by rewrite Hxa eq_refl.
  - by rewrite Hxl Bool.orb_comm.
Qed.

Lemma set_of_list_def (A : Type') : (@set_of_list A) = (@ε ((prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N N)))))))))) -> (list A) -> A -> Prop) (fun set_of_list' : (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N N)))))))))) -> (list A) -> A -> Prop => forall _56425 : prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N N))))))))), ((set_of_list' _56425 (@nil A)) = (@set0 A)) /\ (forall h : A, forall t : list A, (set_of_list' _56425 (@cons A h t)) = (@INSERT A h (set_of_list' _56425 t)))) (@pair N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N N))))))))) (NUMERAL (BIT1 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 (BIT1 N0)))))))) (@pair N (prod N (prod N (prod N (prod N (prod N (prod N (prod N (prod N N)))))))) (NUMERAL (BIT1 (BIT0 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 N0)))))))) (@pair N (prod N (prod N (prod N (prod N (prod N (prod N (prod N N))))))) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT0 (BIT1 (BIT1 (BIT1 N0)))))))) (@pair N (prod N (prod N (prod N (prod N (prod N (prod N N)))))) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 N0)))))))) (@pair N (prod N (prod N (prod N (prod N (prod N N))))) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 N0)))))))) (@pair N (prod N (prod N (prod N (prod N N)))) (NUMERAL (BIT0 (BIT1 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 N0)))))))) (@pair N (prod N (prod N (prod N N))) (NUMERAL (BIT1 (BIT1 (BIT1 (BIT1 (BIT1 (BIT0 (BIT1 N0)))))))) (@pair N (prod N (prod N N)) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT1 (BIT0 (BIT1 (BIT1 N0)))))))) (@pair N (prod N N) (NUMERAL (BIT1 (BIT0 (BIT0 (BIT1 (BIT0 (BIT1 (BIT1 N0)))))))) (@pair N N (NUMERAL (BIT1 (BIT1 (BIT0 (BIT0 (BIT1 (BIT1 (BIT1 N0)))))))) (NUMERAL (BIT0 (BIT0 (BIT1 (BIT0 (BIT1 (BIT1 (BIT1 N0))))))))))))))))))).
Proof.
  by ssimpl ; total_align; first apply set_nil ; last apply set_cons.
Qed.

(* Can be usefull for some finiteness proofs. *)
Lemma finite_seqE {T : eqType} A :
   finite_set A = exists s : seq T, A = [set` s].
Proof. apply propext ; exact (finite_seqP A). Qed.

Lemma finite_witness (A : Type') (l : list A) (s : set A) : s = [set` l] -> finite_set s.
Proof. by rewrite/set_of_list=>->. Qed.

Arguments finite_witness {_} _.

Lemma in_In (A : eqType) (x : A) (l : list A) : (x \in l) = In x l :> Prop.
Proof.
  ext ; elim:l=>[|a l IHl] //= H.
  - by move/orP:H=>[Hax | Hxl] ; first move/eqP:Hax=>-> ; auto.
  - by rewrite in_cons ; case:H=>[-> | Hxl] ; apply/orP ; auto.
Qed.

Lemma uniq_NoDup (A : eqType) (l : list A) : uniq l = NoDup l :> Prop.
Proof.
  ext ; elim:l=>[|a l IHl] //= H.
  - by apply NoDup_nil.
  - apply NoDup_cons ; move/andP:H ; last by move=>[_ H] ; auto.
    by rewrite -in_In =>[[H _]] ; apply/negP.
  - inversion_clear H ; apply/andP ; split ; last by auto.
    by apply/negP ; rewrite in_In.
Qed.

Definition list_of_set (A : Type') (s : set A) : list A :=
  ε (fun l : list A => [set` l] = s /\ NoDup l).

Notation "[ 'list' 'of' s ]" := (list_of_set s) (format "[ 'list'  'of'  s ]") : classical_set_scope.

Lemma list_of_set_spec (A:Type') (s : set A) (H : finite_set s):
  [set` [list of s]] = s /\ NoDup (list_of_set s).
Proof.
  rewrite finite_as_ind in H ; rewrite/list_of_set.
  match goal with [|- [set` (ε ?Q)] = _ /\ _] => have ex : exists l, Q l end.
  - elim : {s}H => [|s a _ [l [<- ndl]]] ; first (exists nil ; is_True (@NoDup_nil A)).
    by rewrite set_nil.
    case: (pselect (a \in l))=>H.
    + exists l ; split ; last by assumption.
      by rewrite predeqP =>x /= ; split ; first auto ; last move=>[->|].
    + exists (a::l) ; rewrite set_cons ; split ; first by [].
      by apply NoDup_cons ; first rewrite -in_In.
  - exact (ε_spec ex).
Qed.

Lemma In_list_of_set (A:Type') (s : set A) :
  finite_set s -> forall x, In x [list of s] = s x.
Proof.
  by move=>fin_s x ; rewrite -{2}(proj1 (list_of_set_spec fin_s)) -in_In.
Qed.

Lemma list_of_set0 (A:Type') (s : set A) : (s = set0) -> ([list of s] = nil).
Proof.
  move: (list_of_set_spec (finite_set0 A)) => [e _] ->.
  destruct (list_of_set set0) as [|a l] ; first by reflexivity.
  rewrite set_cons setU_eq0 in e.
  have contra : set0 a by move:e=>[<- _] ; reflexivity.
  by inversion contra.
Qed.

Require Import Stdlib.Sorting.Permutation.

Lemma eq_mod_permut A (l: list A):
  forall l', (forall x, List.In x l = List.In x l') -> NoDup l -> NoDup l' -> Permutation l l'.
Proof.
  induction l; destruct l'.

  intros. apply perm_nil.

  intro e. generalize (e a). simpl. intro h. symmetry in h.
  apply False_rec. rewrite <- h. left. reflexivity.

  intro e. generalize (e a). simpl. intro h.
  apply False_rec. rewrite <- h. left. reflexivity.

  intros e n n'. inversion n; inversion n'; subst.
  destruct (pselect (a = a0)).

  (* case a = a0 *)
  subst a0. apply perm_skip. apply IHl.

  intro x. apply prop_ext; intro h.
  assert (i: List.In x (a::l)). right. exact h.
  rewrite e in i. destruct i. subst x. contradiction. exact H.
  assert (i: List.In x (a::l')). right. exact h.
  rewrite <- e in i. destruct i. subst x. contradiction. exact H.
  assumption.
  assumption.

  (* case a <> a0 *)
  assert (i: In a (a0 :: l')). rewrite <- (e a). left. reflexivity.
  apply in_split in i. destruct i as [l1 [l2 i]]. rewrite i.
  rewrite <- Permutation_middle. apply perm_skip. apply IHl.
  2: assumption.
  2: apply NoDup_remove_1 with a; rewrite <- i; apply NoDup_cons; assumption.

  intro x. apply prop_ext; intro h.

  assert (j: List.In x (a::l)). right. exact h.
  rewrite e i in j. apply in_elt_inv in j. destruct j as [j|j].
  subst x. contradiction. exact j.
  assert (j: In x (l1 ++ a :: l2)%list). apply in_or_app. apply in_app_or in h.
    destruct h as [h|h]. left. exact h. right. right. exact h.
  rewrite <- i, <- e in j. destruct j as [j|j].
  subst x. rewrite i in n'. apply NoDup_remove in n'. destruct n' as [h1 h2].
  contradiction. exact j.
Qed.

Lemma list_of_setU1 {A:Type'} (a:A) {s} :
  finite_set s -> exists l', Permutation l' (a :: [list of s]) /\
                     [list of a |` s] = if s a then [list of s] else l'.
Proof.
  intro H.
  exists (if s a then a :: [list of s] else [list of a |` s]).
  if_intro=>H' ; split ; auto.
  - f_equal. rewrite setUidr. reflexivity. now intros _ ->.
  - apply eq_mod_permut.
    + intro x. rewrite In_list_of_set.
      ext. inversion 1 as [->|]. 3 : intros [i | i].
      * now left.
      * right. now rewrite In_list_of_set.
      * left. now symmetry.
      * right. now rewrite <- In_list_of_set.
      * rewrite -> finite_as_ind in *. now apply finite'_setU1.
    + apply list_of_set_spec. rewrite -> finite_as_ind in *. now apply finite'_setU1.
    + apply NoDup_cons. now rewrite In_list_of_set.
      now apply list_of_set_spec.
Qed.

Definition ITSET {A B : Type'} : (A -> B -> B) -> (A -> Prop) -> B -> B := fun _43025 : A -> B -> B => fun _43026 : A -> Prop => fun _43027 : B => @ε ((A -> Prop) -> B) (fun g : (A -> Prop) -> B => ((g (@set0 A)) = _43027) /\ (forall x : A, forall s : A -> Prop, (@finite_set A s) -> (g (@INSERT A x s)) = (@COND B (@IN A x s) (g s) (_43025 x (g s))))) _43026.

Definition permut_inv {A B:Type} (f:A -> B -> B) :=
  forall b y x, f x (f y b) = f y (f x b).

Definition fold_set {A B:Type'} (f : A -> B -> B) (s : set A) (b : B) :=
  if permut_inv f /\ finite_set s then fold_right f b [list of s] else ITSET f s b.

Lemma permut_inv_fold_right {A B : Type} {f : A -> B -> B} {b : B} {l : list A} l' :
  Permutation l l' -> permut_inv f -> fold_right f b l = fold_right f b l'.
Proof.
  intros H H'. induction H.
  - reflexivity.
  - simpl. now f_equal.
  - apply H'.
  - now rewrite IHPermutation1.
Qed.

(* Note the structure, could definitely be generalized to
   partial functions on subsets with a definition similar to finite. *)
Lemma ITSET_def {A B : Type'} : (@fold_set A B) = ITSET.
Proof.
  rewrite/fold_set/ITSET. ext=> f s b.
  destruct (pselect (permut_inv f)). 2 : if_triv.
  revert s. align_ε_if.
  - split. now rewrite list_of_set0. intros a E H'. unfold INSERT.
    destruct (list_of_setU1 a H') as (l, (Hl, ->)). ssimpl. if_intro=>H.
    reflexivity. now rewrite (permut_inv_fold_right Hl).
  - rewrite finite_as_ind. intros f' (HEmpty,HINSERT) (HEmpty', HINSERT') E (_, Hfin).
    induction Hfin. now rewrite HEmpty HEmpty'.
    unfold INSERT in *. now rewrite -> HINSERT, HINSERT', IHHfin.
Qed.

Import finmap.
Open Scope fset_scope.

Definition CARD (A : Type') (s : set A) := fold_set (fun _ => N.succ) s 0.

Lemma permut_inv_succ (A : Type) : permut_inv (fun _ : A => N.succ).
Proof. easy. Qed.

Definition card (A : Type') (s : set A) :=
  if finite_set s then N.of_nat (#|` fset_set s|) else CARD s.

Lemma in_fset_list {A : Type'} (l : list A) :
  [fset x in l] =i l.
Proof.
  by elim:l=>[|a l IHl] x /= ; rewrite !in_fset_.
Qed.

Lemma fset_set_list {A : Type'} (l : list A) :
  fset_set [set` l] = [fset x in l].
Proof.
  apply fsetP=>x ; rewrite in_fset_set ; last by apply (finite_witness l).
  by rewrite in_fset_list mem_setE.
Qed.

Lemma CARD_def (A : Type') : (@card A) = (fun _43228 : A -> Prop => @fold_set A N (fun x : A => fun n : N => N.succ n) _43228 (NUMERAL N0)).
Proof.
  numsimp.
  rewrite/card/fold_set; ext=>s ; if_intro =>fin_s ; last by [].
  if_triv using permut_inv_succ.
  move:(list_of_set_spec fin_s)=>[eq nd] ; rewrite -{1}eq.
  rewrite fset_set_list card_fseq undup_id ; last by rewrite uniq_NoDup.
  transitivity (lengthN [list of s]) ; first by apply length_of_nat_N.
  by elim:[list of s] => [|a l IHl] ; last (simpl ; f_equal).
Qed.

Definition dimindex (A : Type') (_ : set A) :=
  if finite_set [set: A] then card [set: A] else 1.

Lemma dimindex_def (A : Type') : (@dimindex A) = (fun _94156 : A -> Prop => @COND N (@finite_set A (@setT A)) (@card A (@setT A)) (NUMERAL (BIT1 N0))).
Proof. exact erefl. Qed.

Lemma dimindex_nonzero (A : Type') (s : set A) : 0 < dimindex s.
Proof.
  rewrite/dimindex ; if_intro =>fin_A ; last by lia.
  have var : 0 <> card [set: A] ; last by lia.
  replace 0 with (N.of_nat #|`fset_set (set0:set A)|).
  2 : by rewrite fset_set0 cardfs0.
  rewrite/card ; if_triv => /Nnat.Nat2N.inj/= H ; move/fcard_eq:H=>H.
  have contra0 : card_eq (@set0 A) [set: A] by apply H.
  rewrite card_eq_sym card_eq0 in contra0.
  have contra : (@set0 A) point by move/eqP:contra0=><-.
  destruct contra.
Qed.

(* seq_fset seems intended only for internal use in mathcomp but has useful results. *)
Lemma fset_set_seq_fset (A: Type') (l : list A) : [fset x in l] = seq_fset tt l.
Proof.
  by apply fsetP=>x ; rewrite in_fset_list seq_fsetE.
Qed.

Lemma card_set_of_list (A : Type') (l : list A) : card [set` l] = lengthN (undup l).
Proof.
  rewrite/card fset_set_list fset_set_seq_fset ; if_triv using (finite_witness l).
  rewrite size_seq_fset ; apply length_of_nat_N.
Qed.

Lemma list_of_set_def (A : Type') : (@list_of_set A) = (fun _56426 : A -> Prop => @ε (list A) (fun l : list A => ((@set_of_list A l) = _56426) /\ ((@lengthN A l) = (@card A _56426)))).
Proof.
  rewrite/list_of_set/set_of_list ; ext=>s ; f_equal ; ext=> l [<- Hl] ; split=>//.
  all : rewrite -> card_set_of_list, <- uniq_NoDup in *.
  - by rewrite undup_id.
  - apply negbNE ; rewrite -ltn_size_undup ; apply/negP.
    do 2 rewrite -length_of_nat_N in Hl ; apply Nnat.Nat2N.inj in Hl.
    move/leP ; have Hl' : size l = size (undup l) by []. rewrite Hl'. lia.
Qed.

(* Could be useful for cardinal proofs. *)
Lemma card_witness {A : Type'} (l : list A) (s : set A) (n : N) : s = [set` l] ->
  n = lengthN (undup l) -> card s = n.
Proof.
  by move=>->-> ; apply card_set_of_list.
Qed.

Arguments card_witness {_} _.
Close Scope fset_scope.

(*****************************************************************************)
(* A type for natural numbers between 1 and n for n > 0 *)
(*****************************************************************************)

Section non_zero_natural_numbers.

Class non_zero (n : N) := gt_0 : 0 < n.
Local Notation C := non_zero.

Local Ltac lia := unfold non_zero in * ; Lia.lia.

Global Instance non_zero_pos p : C (N.pos p).
Proof. lia. Qed.

Global Instance non_zero_succ n : C (N.succ n) := N.lt_0_succ n.

Global Instance non_zero_sum_l n m : C n -> C (n+m) := N.add_pos_l n m.

Global Instance non_zero_sum_r n m : C m -> C (n+m) := N.add_pos_r n m.

Global Instance non_zero_prod n m : C n -> C m -> C (n*m) := N.mul_pos_pos n m.

Global Instance non_zero_max_l n m : C n -> C (N.max n m).
Proof. lia. Qed.

Global Instance non_zero_max_r n m : C m -> C (N.max n m).
Proof. lia. Qed.

Global Instance non_zero_dimindex (A : Type') (s : set A) : C (dimindex s) :=
  dimindex_nonzero s.

End non_zero_natural_numbers.

(* Integer interval [( n ; m )] *)
Import interval order.
(* TODO : Might be better to define the boolean order on N and
   use actual N intervals. *)
Definition Ninterval (n m : N) := [set (N.of_nat k) | k in `[N.to_nat n, N.to_nat m]].

(* four dots because of preexisting meaning to .. and ... in Rocq *)
Notation "[ n  '....'  m ]" := (Ninterval n m).

Notation "x 'BETWEEN' n 'AND' m " := ([n .... m] x) (at level 1).

Lemma to_nat_inj_le : forall n m, (N.to_nat n <= N.to_nat m)%coq_nat = (n <= m).
Proof.
  move=>n m ; rewrite/N.le Nnat.N2Nat.inj_compare.
  by ext=>H ; apply Nat.compare_le_iff.
Qed.

(* This lemma is only present in the latest version of mathcomp. *)
Lemma mem_image {aT rT : Type} {f : aT -> rT} {A a} : injective f ->
   (f a \in [set f x | x in A]) = (a \in A).
Proof. by move=> /image_inj finj; apply/idP/idP ; rewrite !(inE, in_setE) finj. Qed.

(* The one to actually use in proofs, to take advantage of lia
   for example. *)
Lemma Ninterval_def : Ninterval = fun n m k => n <= k <= m.
Proof.
  rewrite/Ninterval ; ext 3 => n m k.
  rewrite -{1}[k]Nnat.N2Nat.id -(@in_setE N) mem_image ; last by exact Nnat.Nat2N.inj.
  rewrite mem_setE ; ext=>H.
  - by move/itv_dec:H=>[] ; split ; rewrite -to_nat_inj_le ; apply/leP.
  - by apply/itv_dec ; split ; apply/leP ; rewrite to_nat_inj_le ; case:H.
Qed.

(* Add rewriting Ninterval_def' to ssimpl. *)
Ltac ssimpl ::=
  rewrite ?SPEC_IMAGE?SPEC_elim/GSPEC/SETSPEC/DELETE/IMAGE/INTERS/UNIONS/
  INSERT/BIT1/BIT0/NUMERAL?setU0?IN_def?Ninterval_def.

Lemma dotdot_def : Ninterval = (fun _66922 : N => fun _66923 : N => @GSPEC N (fun GEN_PVAR_231 : N => exists x : N, @SETSPEC N GEN_PVAR_231 ((N.le _66922 x) /\ (N.le x _66923)) x)).
Proof. by ext 2 => n m ; ssimpl. Qed.



Unset Implicit Arguments.
Section enum_type.
(* Basically finite ordinal arithmetic with types. *)
Local Close Scope N_scope.
Local Open Scope coq_nat_scope.

Context (n : N) {H : non_zero n}.
Local Definition inhabits k := IN k (Ninterval 1 n).

Local Lemma inhabits_1 : inhabits 1.
Proof.
  unfold inhabits. ssimpl. unfold non_zero in H. lia.
Qed.

Definition enum_type : Type' := subtype inhabits_1.
Definition mk_enum := mk inhabits_1.
Definition dest_enum := dest inhabits_1.
Definition mk_dest_enum := mk_dest inhabits_1.
Definition dest_mk_enum := dest_mk inhabits_1.

End enum_type.
Set Implicit Arguments.

(*****************************************************************************)
(* Cart.finite_image: natural numbers between 1 and the cardinal of A,
if A is finite, and 1 otherwise. *)
(*****************************************************************************)

Definition finite_image (A : Type') := enum_type (dimindex [set: A]).

Definition finite_index (A : Type') := mk_enum (dimindex [set: A]).

Definition dest_finite_image (A : Type') := dest_enum (dimindex [set: A]).

Lemma axiom_27 (A : Type')  : forall a : finite_image A, (@finite_index A (@dest_finite_image A a)) = a.
Proof. exact (mk_dest_enum (dimindex [set: A])). Qed.

Lemma axiom_28 (A : Type') : forall r : N, ((fun x : N => @IN N x (Ninterval (NUMERAL (BIT1 0)) (@dimindex A [set: A]))) r) = ((@dest_finite_image A (@finite_index A r)) = r).
Proof. exact (dest_mk_enum (dimindex [set: A])). Qed.

(*****************************************************************************)
(* Cart.cart A B is finite_image B -> A. *)
(*****************************************************************************)

Definition cart A B := finite_image B -> A.

Definition mk_cart : forall {A B : Type'}, ((finite_image B) -> A) -> cart A B :=
  fun A B f => f.

Definition dest_cart : forall {A B : Type'}, (cart A B) -> (finite_image B) -> A :=
  fun A B f => f.

Lemma axiom_29 : forall {A B : Type'} (a : cart A B), (@mk_cart A B (@dest_cart A B a)) = a.
Proof. reflexivity. Qed.

Lemma axiom_30 : forall {A B : Type'} (r : (finite_image B) -> A), ((fun f : (finite_image B) -> A => True) r) = ((@dest_cart A B (@mk_cart A B r)) = r).
Proof. intros A B r. apply prop_ext. reflexivity. exact (fun _ => Logic.I). Qed.

(*****************************************************************************)
(* Cart.finite_sum *)
(*****************************************************************************)

Definition finite_sum (A B : Type') :=
  enum_type (dimindex [set: A] + dimindex [set: B]).

Definition mk_finite_sum {A B : Type'} :=
  mk_enum (dimindex [set: A] + dimindex [set: B]).

Definition dest_finite_sum {A B : Type'} :=
  dest_enum (dimindex [set: A] + dimindex [set: B]).

Definition axiom_31 {A B : Type'} : forall a : finite_sum A B, (@mk_finite_sum A B (@dest_finite_sum A B a)) = a :=
  mk_dest_enum (dimindex [set: A] + dimindex [set: B]).

Definition axiom_32 {A B : Type'} : forall r : N, ((fun x : N => @IN N x (Ninterval (NUMERAL (BIT1 0)) (N.add (@dimindex A [set: A]) (@dimindex B [set: B])))) r) = ((@dest_finite_sum A B (@mk_finite_sum A B r)) = r) :=
  dest_mk_enum (dimindex [set: A] + dimindex [set: B]).

(*****************************************************************************)
(* Cart.finite_diff *)
(*****************************************************************************)

Definition finite_diff (A B : Type') :=
  enum_type (N.max (dimindex [set: A] - dimindex [set: B]) 1).

Definition mk_finite_diff {A B : Type'} :=
  mk_enum (N.max (dimindex [set: A] - dimindex [set: B]) 1).

Definition dest_finite_diff {A B : Type'} :=
  dest_enum (N.max (dimindex [set: A] - dimindex [set: B]) 1).

Definition axiom_33 {A B : Type'} : forall a : finite_diff A B, (@mk_finite_diff A B (@dest_finite_diff A B a)) = a :=
  mk_dest_enum (N.max (dimindex [set: A] - dimindex [set: B]) 1).

Lemma pos_diff_eq n m : N.max (n-m) 1 = if m < n then n-m else 1.
Proof. if_intro ; lia. Qed.

Lemma axiom_34 : forall {A B : Type'} (r : N), ((fun x : N => @IN N x (Ninterval (NUMERAL (BIT1 0)) (@COND N (N.lt (@dimindex B [set: B]) (@dimindex A [set: A])) (N.sub (@dimindex A [set: A]) (@dimindex B [set: B])) (NUMERAL (BIT1 0))))) r) = ((@dest_finite_diff A B (@mk_finite_diff A B r)) = r).
Proof.
  intros. rewrite/COND -pos_diff_eq. apply dest_mk_enum.
Qed.

(*****************************************************************************)
(* Cart.finite_prod *)
(*****************************************************************************)

Definition finite_prod (A B : Type') :=
  enum_type (dimindex [set: A] * dimindex [set: B]).

Definition mk_finite_prod (A B : Type') :=
  mk_enum (dimindex [set: A] * dimindex [set: B]).

Definition dest_finite_prod (A B : Type') :=
  dest_enum (dimindex [set: A] * dimindex [set: B]).

Definition axiom_35 {A B : Type'} : forall a : finite_prod A B, (@mk_finite_prod A B (@dest_finite_prod A B a)) = a :=
  mk_dest_enum (dimindex [set: A] * dimindex [set: B]).

Definition axiom_36 {A B : Type'} : forall r : N, ((fun x : N => @IN N x (Ninterval (NUMERAL (BIT1 0)) (N.mul (@dimindex A (@setT A)) (@dimindex B (@setT B))))) r) = ((@dest_finite_prod A B (@mk_finite_prod A B r)) = r) :=
  dest_mk_enum (dimindex [set: A] * dimindex [set: B]).

(*****************************************************************************)
(* Mapping of a subtype of recspace (embedding of any type A into recspace A) *)
(*****************************************************************************)
Unset Implicit Arguments.
Section non_recursive_inductive_type.

  Variable A : Type'.

  Definition nr_dest (a:A) : recspace A := CONSTR 0 a Fnil.

  Definition nr_pred (r : recspace A) := exists a, r = nr_dest a.

  Definition nr_mk := finv nr_dest.

  Lemma nr_mk_dest : forall a : A, (nr_mk (nr_dest a)) = a.
  Proof.
    _mk_dest_rec. intros a a' H. now inversion H.
  Qed.

  Lemma nr_dest_mk : forall r : recspace A, (forall P : recspace A -> Prop, (forall r' : recspace A, nr_pred r' -> P r') -> P r) = (nr_dest (nr_mk r) = r).
  Proof.
    intro r. apply (@finv_inv_r _ _ _ (fun r0 => (forall P : recspace A -> Prop,
      (forall r' : recspace A, nr_pred r' -> P r') -> P r0))) ; intro H.
    - apply H. clear r H. intros r (a,H). now exists a.
    - destruct H as (a,<-). intros P H. apply H. now exists a.
  Qed.

End non_recursive_inductive_type.
Set Implicit Arguments.

(*****************************************************************************)
(* Cart.tybit0 *)
(*****************************************************************************)

Definition tybit0 A := finite_sum A A.

Definition _mk_tybit0 : forall (A : Type'), (recspace (finite_sum A A)) -> tybit0 A := fun A => nr_mk (finite_sum A A).

Definition _dest_tybit0 : forall (A : Type'), (tybit0 A) -> recspace (finite_sum A A) := fun A => nr_dest (finite_sum A A).

Lemma axiom_37 : forall (A : Type') (a : tybit0 A), (@_mk_tybit0 A (@_dest_tybit0 A a)) = a.
Proof. intro A. apply nr_mk_dest. Qed.

Lemma test {A B : Type} (f : A -> B) (a : A) : (fun a' => f a') a = f a.
Proof. reflexivity. Qed.

Lemma axiom_38 : forall (A : Type') (r : recspace (finite_sum A A)), ((fun a : recspace (finite_sum A A) => forall tybit0' : (recspace (finite_sum A A)) -> Prop, (forall a' : recspace (finite_sum A A), (exists a'' : finite_sum A A, a' = ((fun a''' : finite_sum A A => @mappings.CONSTR (finite_sum A A) (NUMERAL 0) a''' (fun n : N => @mappings.BOTTOM (finite_sum A A))) a'')) -> tybit0' a') -> tybit0' a) r) = ((@_dest_tybit0 A (@_mk_tybit0 A r)) = r).
Proof. intro A. apply nr_dest_mk. Qed.

(*****************************************************************************)
(* Cart.tybit1 *)
(*****************************************************************************)

Definition tybit1 A := finite_sum (finite_sum A A) unit.

Definition _mk_tybit1 : forall (A : Type'), (recspace (finite_sum (finite_sum A A) unit)) -> tybit1 A := fun A => nr_mk (finite_sum (finite_sum A A) unit).

Definition _dest_tybit1 : forall (A : Type'), (tybit1 A) -> recspace (finite_sum (finite_sum A A) unit) := fun A => nr_dest (finite_sum (finite_sum A A) unit).

Lemma axiom_39 : forall (A : Type') (a : tybit1 A), (@_mk_tybit1 A (@_dest_tybit1 A a)) = a.
Proof. intro A. apply nr_mk_dest. Qed.

Lemma axiom_40 : forall (A : Type') (r : recspace (finite_sum (finite_sum A A) unit)), ((fun a : recspace (finite_sum (finite_sum A A) unit) => forall tybit1' : (recspace (finite_sum (finite_sum A A) unit)) -> Prop, (forall a' : recspace (finite_sum (finite_sum A A) unit), (exists a'' : finite_sum (finite_sum A A) unit, a' = ((fun a''' : finite_sum (finite_sum A A) unit => @mappings.CONSTR (finite_sum (finite_sum A A) unit) (NUMERAL 0) a''' (fun n : N => @mappings.BOTTOM (finite_sum (finite_sum A A) unit))) a'')) -> tybit1' a') -> tybit1' a) r) = ((@_dest_tybit1 A (@_mk_tybit1 A r)) = r).
Proof. intro A. apply nr_dest_mk. Qed.

(*****************************************************************************)
(* Library.Frag.frag (free Abelian group) *)
(*****************************************************************************)

Definition is_frag {A:Type'} (f:A -> Z) := finite_set (fun a : A => f a <> 0%Z).

Lemma is_frag0 (A:Type') : is_frag (fun _:A => 0%Z).
Proof.
  unfold is_frag. apply (finite_witness nil). rewrite set_nil.
  ext => a ; now destruct 1.
Qed.

Definition frag A := subtype (is_frag0 A).

Definition mk_frag : forall (A : Type'), (A -> Z) -> frag A := fun A => mk (is_frag0 A).

Definition dest_frag : forall (A : Type'), (frag A) -> A -> Z := fun A => dest (is_frag0 A).

Lemma axiom_41 : forall (A : Type') (a : frag A), (@mk_frag A (@dest_frag A a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_42 : forall (A : Type') (r : A -> Z), ((fun f : A -> Z => @finite_set A (@GSPEC A (fun GEN_PVAR_709 : A => exists x : A, @SETSPEC A GEN_PVAR_709 (~ ((f x) = (Z_of_N (NUMERAL 0%N)))) x))) r) = ((@dest_frag A (@mk_frag A r)) = r).
Proof.
  intros A r. match goal with |- ?P r = _ => replace P with (@is_frag A) end.
  apply dest_mk. ext 1 => r'. now ssimpl.
Qed.

(*****************************************************************************)
(* Library.grouptheory.group *)
(*****************************************************************************)

Definition Grp (A:Type') := prod (A -> Prop) (prod A (prod (A -> A) (A -> A -> A))).
Definition Gcar {A:Type'} (G: Grp A) := fst G.
Definition G0 {A:Type'} (G:Grp A) := fst (snd G).
Definition Gop {A:Type'} (G:Grp A) := snd (snd (snd G)).
Definition Ginv {A:Type'} (G:Grp A) := fst (snd (snd G)).

Definition is_group {A:Type'} (r:Grp A) := IN (G0 r) (Gcar r)
/\ ((forall x, IN x (Gcar r) -> IN (Ginv r x) (Gcar r))
/\ ((forall x y, (IN x (Gcar r) /\ (IN y (Gcar r))) -> IN (Gop r x y) (Gcar r))
/\ ((forall x y z, (IN x (Gcar r) /\ (IN y (Gcar r) /\ IN z (Gcar r))) ->
Gop r x (Gop r y z) = Gop r (Gop r x y) z)
/\ ((forall x, IN x (Gcar r) -> (Gop r (G0 r) x = x) /\ (Gop r x (G0 r) = x))
/\ (forall x, IN x (Gcar r) -> (Gop r (Ginv r x) x = G0 r) /\ (Gop r x (Ginv r x) = G0 r)))))).

Definition g0 (A:Type') : Grp A := (fun x => x = point, (point, (fun _ => point, fun _ _ => point ))).

Lemma is_group0 (A:Type') : is_group (g0 A).
Proof. by rewrite/is_group ; ssimpl ; firstorder. Qed.

Definition Group (A:Type') := subtype (is_group0 A).

Definition group : forall (A : Type'), Grp A -> Group A := fun A => mk (is_group0 A).
Definition group_operations : forall (A : Type'), (Group A) -> Grp A := fun A => dest (is_group0 A).

Lemma axiom_43 : forall (A : Type') (a : Group A), (@group A (@group_operations A a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_44 : forall (A : Type') (r : Grp A), is_group r = (group_operations (group r) = r).
Proof. intros A r. apply dest_mk. Qed.

(*****************************************************************************)
(* Library.Matroids.matroid *)
(*****************************************************************************)

Definition is_matroid {A:Type'} m := (forall s : A -> Prop, (@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) -> @subset A (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s) (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ ((forall s : A -> Prop, (@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) -> @subset A s (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)) /\ ((forall s : A -> Prop, forall t : A -> Prop, ((@subset A s t) /\ (@subset A t (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m))) -> @subset A (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s) (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m t)) /\ ((forall s : A -> Prop, (@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) -> (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)) = (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)) /\ ((forall s : A -> Prop, forall x : A, ((@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ (@IN A x (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s))) -> exists s' : A -> Prop, (@finite_set A s') /\ ((@subset A s' s) /\ (@IN A x (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s')))) /\ (forall s : A -> Prop, forall x : A, forall y : A, ((@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ ((@IN A x (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ ((@IN A y (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m (@INSERT A x s))) /\ (~ (@IN A y (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)))))) -> @IN A x (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m (@INSERT A y s))))))).

Lemma is_matroid_def {A:Type'} m : is_matroid m = ((forall s : A -> Prop, (@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) -> @subset A (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s) (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ ((forall s : A -> Prop, (@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) -> @subset A s (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)) /\ ((forall s : A -> Prop, forall t : A -> Prop, ((@subset A s t) /\ (@subset A t (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m))) -> @subset A (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s) (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m t)) /\ ((forall s : A -> Prop, (@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) -> (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)) = (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)) /\ ((forall s : A -> Prop, forall x : A, ((@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ (@IN A x (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s))) -> exists s' : A -> Prop, (@finite_set A s') /\ ((@subset A s' s) /\ (@IN A x (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s')))) /\ (forall s : A -> Prop, forall x : A, forall y : A, ((@subset A s (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ ((@IN A x (@fst (A -> Prop) ((A -> Prop) -> A -> Prop) m)) /\ ((@IN A y (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m (@INSERT A x s))) /\ (~ (@IN A y (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m s)))))) -> @IN A x (@snd (A -> Prop) ((A -> Prop) -> A -> Prop) m (@INSERT A y s)))))))).
Proof. reflexivity. Qed.

Lemma is_matroid0 (A:Type') : is_matroid (pair (fun _:A => False) (fun x => x)).
Proof. by rewrite/is_matroid ; ssimpl ; firstorder. Qed.

Definition Matroid (A:Type') := subtype (is_matroid0 A).

Definition matroid : forall (A : Type'), (prod (A -> Prop) ((A -> Prop) -> A -> Prop)) -> Matroid A := fun A => mk (is_matroid0 A).

Definition dest_matroid : forall (A : Type'), (Matroid A) -> prod (A -> Prop) ((A -> Prop) -> A -> Prop) := fun A => dest (is_matroid0 A).

Lemma axiom_45 : forall (A : Type') (a : Matroid A), (@matroid A (@dest_matroid A a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_46 : forall (A : Type') (r : prod (A -> Prop) ((A -> Prop) -> A -> Prop)), (is_matroid r) = ((@dest_matroid A (@matroid A r)) = r).
Proof. intros A r. apply dest_mk. Qed.

(*****************************************************************************)
(* Library.Analysis.topology *)
(*****************************************************************************)

Definition istopology (A : Type') : ((A -> Prop) -> Prop) -> Prop :=
  fun U => (IN set0 U)
        /\ ((forall s t, ((IN s U) /\ (IN t U)) -> IN (setI s t) U)
           /\ (forall k, subset k U -> IN (UNIONS k) U)).

Lemma istopology_def (A : Type') : (@istopology A) = (fun U : (A -> Prop) -> Prop => (@IN (A -> Prop) (@set0 A) U) /\ ((forall s : A -> Prop, forall t : A -> Prop, ((@IN (A -> Prop) s U) /\ (@IN (A -> Prop) t U)) -> @IN (A -> Prop) (@setI A s t) U) /\ (forall k : (A -> Prop) -> Prop, (@subset (A -> Prop) k U) -> @IN (A -> Prop) (@UNIONS A k) U))).
Proof. exact erefl. Qed.

Lemma istopology0 (A:Type') : @istopology A (fun _ => True).
Proof. rewrite/istopology ; ssimpl ; firstorder. Qed.

Definition Topology (A:Type') := subtype (istopology0 A).

Definition topology : forall (A : Type'), ((A -> Prop) -> Prop) -> Topology A := fun A => mk (istopology0 A).

Definition open_in : forall (A : Type'), (Topology A) -> (A -> Prop) -> Prop := fun A => dest (istopology0 A).

Lemma axiom_47 : forall (A : Type') (a : Topology A), (@topology A (@open_in A a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_48 : forall (A : Type') (r : (A -> Prop) -> Prop), ((fun t : (A -> Prop) -> Prop => @istopology A t) r) = ((@open_in A (@topology A r)) = r).
Proof. intros A r. apply dest_mk. Qed.

(*****************************************************************************)
(* Multivariate.Metric.net *)
(*****************************************************************************)

Definition is_net {A:Type'} (g: prod ((A -> Prop) -> Prop) (A -> Prop)) :=
  forall s t, ((IN s (fst g)) /\ (IN t (fst g))) -> IN (setI s t) (fst g).

Lemma is_net_def {A:Type'} g : is_net g = forall s : A -> Prop, forall t : A -> Prop, ((@IN (A -> Prop) s (@fst ((A -> Prop) -> Prop) (A -> Prop) g)) /\ (@IN (A -> Prop) t (@fst ((A -> Prop) -> Prop) (A -> Prop) g))) -> @IN (A -> Prop) (@setI A s t) (@fst ((A -> Prop) -> Prop) (A -> Prop) g).
Proof. reflexivity. Qed.

Lemma is_net0 (A:Type') : @is_net A (pair (fun _ => True) (point _)).
Proof. by rewrite/is_net ; ssimpl ; firstorder. Qed.

Definition net (A:Type') := subtype (@is_net0 A).

Definition mk_net : forall (A : Type'), (prod ((A -> Prop) -> Prop) (A -> Prop)) -> net A := fun A => mk (@is_net0 A).

Definition dest_net : forall (A : Type'), (net A) -> prod ((A -> Prop) -> Prop) (A -> Prop) := fun A => dest (@is_net0 A).

Lemma axiom_49 : forall (A : Type') (a : net A), (@mk_net A (@dest_net A a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_50 : forall (A : Type') (r : prod ((A -> Prop) -> Prop) (A -> Prop)), is_net r = ((@dest_net A (@mk_net A r)) = r).
Proof. intros A a. apply dest_mk. Qed.

(*****************************************************************************)
(* Multivariate.Metric.metric *)
(*****************************************************************************)

Definition MS (A:Type') := prod (A -> Prop) ((prod A A) -> R).

Definition Mcar {A:Type'} : MS A -> A -> Prop := fst.
Definition Mdist {A:Type'} : MS A -> prod A A -> R := snd.

Definition is_metric_space (A : Type') : MS A -> Prop :=
  fun M => (forall x y, ((IN x (Mcar M)) /\ (IN y (Mcar M))) ->
                Rle (R_of_N (NUMERAL 0%N)) (Mdist M (@pair A A x y)))
        /\ ((forall x y, ((IN x (Mcar M)) /\ (IN y (Mcar M))) ->
                   ((Mdist M (pair x y)) = (R_of_N (NUMERAL 0%N))) = (x = y))
           /\ ((forall x y, ((IN x (Mcar M)) /\ (IN y (Mcar M))) ->
                      (Mdist M (pair x y)) = (Mdist M (pair y x)))
              /\ (forall x y z, ((IN x (Mcar M)) /\ ((IN y (Mcar M)) /\ (IN z (Mcar M)))) ->
                          Rle (Mdist M (pair x z)) (Rplus (Mdist M (pair x y)) (Mdist M (pair y z)))))).

Lemma is_metric_space_def (A : Type') : (@is_metric_space A) = (fun M : prod (A -> Prop) ((prod A A) -> R) => (forall x : A, forall y : A, ((@IN A x (@fst (A -> Prop) ((prod A A) -> R) M)) /\ (@IN A y (@fst (A -> Prop) ((prod A A) -> R) M))) -> Rle (R_of_N (NUMERAL 0%N)) (@snd (A -> Prop) ((prod A A) -> R) M (@pair A A x y))) /\ ((forall x : A, forall y : A, ((@IN A x (@fst (A -> Prop) ((prod A A) -> R) M)) /\ (@IN A y (@fst (A -> Prop) ((prod A A) -> R) M))) -> ((@snd (A -> Prop) ((prod A A) -> R) M (@pair A A x y)) = (R_of_N (NUMERAL 0%N))) = (x = y)) /\ ((forall x : A, forall y : A, ((@IN A x (@fst (A -> Prop) ((prod A A) -> R) M)) /\ (@IN A y (@fst (A -> Prop) ((prod A A) -> R) M))) -> (@snd (A -> Prop) ((prod A A) -> R) M (@pair A A x y)) = (@snd (A -> Prop) ((prod A A) -> R) M (@pair A A y x))) /\ (forall x : A, forall y : A, forall z : A, ((@IN A x (@fst (A -> Prop) ((prod A A) -> R) M)) /\ ((@IN A y (@fst (A -> Prop) ((prod A A) -> R) M)) /\ (@IN A z (@fst (A -> Prop) ((prod A A) -> R) M)))) -> Rle (@snd (A -> Prop) ((prod A A) -> R) M (@pair A A x z)) (Rplus (@snd (A -> Prop) ((prod A A) -> R) M (@pair A A x y)) (@snd (A -> Prop) ((prod A A) -> R) M (@pair A A y z))))))).
Proof. exact erefl. Qed.

Lemma is_metric_space0 (A:Type') : @is_metric_space A (pair (fun _ => False) (fun _ => 0%R)).
Proof.
  rewrite/is_metric_space R_of_N0 ; ssimpl ; firstorder.
Qed.

Definition Metric (A:Type') := subtype (is_metric_space0 A).

Definition metric : forall (A : Type'), (prod (A -> Prop) ((prod A A) -> R)) -> Metric A := fun A => mk (is_metric_space0 A).
Definition dest_metric : forall (A : Type'), (Metric A) -> prod (A -> Prop) ((prod A A) -> R) := fun A => dest (is_metric_space0 A).

Lemma axiom_51 : forall (A : Type') (a : Metric A), (@metric A (@dest_metric A a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_52 : forall (A : Type') (r : prod (A -> Prop) ((prod A A) -> R)), ((fun m : prod (A -> Prop) ((prod A A) -> R) => @is_metric_space A m) r) = ((@dest_metric A (@metric A r)) = r).
Proof. intros A r. apply dest_mk. Qed.

(*****************************************************************************)
(* Multivariate.Clifford.multivector *)
(*****************************************************************************)

Definition is_multivector (A:Type') (s:N -> Prop) := subset s (Ninterval 1 (dimindex (@setT A))).

Lemma is_multivector0 (A:Type') : is_multivector A (fun n => n = 1).
Proof.
  unfold is_multivector. ssimpl.
  intros x ->. set (H := dimindex_nonzero [set: A]). lia.
Qed.

Definition Multivector (A:Type') := subtype (is_multivector0 A).

Definition mk_multivector : forall {N' : Type'}, (N -> Prop) -> Multivector N' := fun A => mk (is_multivector0 A).

Definition dest_multivector : forall {N' : Type'}, (Multivector N') -> N -> Prop := fun A => dest (is_multivector0 A).

Lemma axiom_53 : forall {N' : Type'} (a : Multivector N'), (@mk_multivector N' (@dest_multivector N' a)) = a.
Proof. intros A a. apply mk_dest. Qed.

Lemma axiom_54 : forall {N' : Type'} (r : N -> Prop), ((fun s : N -> Prop => @subset N s (Ninterval (NUMERAL (BIT1 0%N)) (@dimindex N' (@setT N')))) r) = ((@dest_multivector N' (@mk_multivector N' r)) = r).
Proof. intros A r. apply dest_mk. Qed.
