/* Map from dk/lp symbols on the right to Coq expressions on the left:
The declarations of dk/lp symbols are removed and their occurrences are
replaced by the given Coq expressions. */

// primitive types
builtin "Type'" ≔ Set;
builtin "point" ≔ el;
builtin "Prop" ≔ bool;
builtin "arr" ≔ fun;

// connectives
builtin "eq" ≔ =;

builtin "imp" ≔ ⇒;
builtin "imp_def" ≔ ⇒_def;

builtin "all" ≔ ∀;
builtin "all_def" ≔ ∀_def;

builtin "or" ≔ ∨;
builtin "or_def" ≔ ∨_def;

builtin "and" ≔ ∧;
builtin "and_def" ≔ ∧_def;

builtin "ex" ≔ ∃;
builtin "ex_def" ≔ ∃_def;

builtin "not" ≔ ¬;
builtin "not_def" ≔ ¬_def;

builtin "True" ≔ ⊤;
builtin "T_def" ≔ ⊤_def;

builtin "False" ≔ ⊥;
builtin "F_def" ≔ ⊥_def;

builtin "ex1" ≔ ∃₁;
builtin "ex1_def" ≔ ∃₁_def;

// natural deduction rules
builtin "Logic.I" ≔ ⊤ᵢ;
builtin "conj" ≔ ∧ᵢ;
builtin "proj1" ≔ ∧ₑ₁;
builtin "proj2" ≔ ∧ₑ₂;
builtin "or_intro1" ≔ ∨ᵢ₁;
builtin "or_intror" ≔ ∨ᵢ₂;
builtin "or_elim" ≔ ∨ₑ;
builtin "ex_intro" ≔ ∃ᵢ;
builtin "ex_elim" ≔ ∃ₑ;

// HOL-Light rules
builtin "REFL" ≔ REFL;
builtin "EQ_MP" ≔ EQ_MP;
builtin "MK_COMB" ≔ MK_COMB;
builtin "ssrfun.etrans" ≔ TRANS;
builtin "ssrfun.esym" ≔ SYM;

// HOL-Light axioms
builtin "ε" ≔ ε;
builtin "axiom_0" ≔ axiom_0;
builtin "axiom_1" ≔ axiom_1;
builtin "funext" ≔ fun_ext;
builtin "prop_ext" ≔ prop_ext;

// miscellaneous
builtin "COND" ≔ COND;
builtin "COND_def" ≔ COND_def;
builtin "eq" ≔ GEQ;
builtin "GEQ_def" ≔ GEQ_def;
builtin "cancel2" ≔ ISO;
builtin "ISO_def" ≔ ISO_def;
builtin "ε" ≔ GABS;
builtin "GABS_def" ≔ GABS_def;
builtin "and" ≔ _UNGUARDED_PATTERN;
builtin "_UNGUARDED_PATTERN_def" ≔ _UNGUARDED_PATTERN_def;
builtin "False" ≔ _FALSITY_;
builtin "_FALSITY__def" ≔ _FALSITY__def;
builtin "True" ≔ hashek;
builtin "hashek_def" ≔ hashek_def;
builtin "LET" ≔ LET;
builtin "LET_def" ≔ LET_def;
builtin "LET_END" ≔ LET_END;
builtin "LET_END_def" ≔ LET_END_def;
builtin "Relation_Operators.clos_trans" ≔ TC;
builtin "TC_def" ≔ TC_def;
builtin "MEASURE" ≔ MEASURE;
builtin "MEASURE_def" ≔ MEASURE_def;

// unit type
builtin "unit" ≔ unit;
builtin "one_ABS" ≔ one_ABS;
builtin "one_REP" ≔ one_REP;
builtin "axiom_2" ≔ axiom_2;
builtin "axiom_3" ≔ axiom_3;
builtin "tt" ≔ one;
builtin "one_def" ≔ one_def;

// product type
builtin "mk_pair" ≔ mk_pair;
builtin "mk_pair_def" ≔ mk_pair_def;
builtin "prod" ≔ prod;
builtin "ABS_prod" ≔ ABS_prod;
builtin "REP_prod" ≔ REP_prod;
builtin "axiom_4" ≔ axiom_4;
builtin "axiom_5" ≔ axiom_5;
builtin "pair" ≔ ̦‚;
builtin "pair_def" ≔ ̦‚_def;
builtin "fst" ≔ FST;
builtin "FST_def" ≔ FST_def;
builtin "snd" ≔ SND;
builtin "SND_def" ≔ SND_def;

// infinite type ind
builtin "ind" ≔ ind;
builtin "ONE_ONE" ≔ ONE_ONE;
builtin "ONE_ONE_def" ≔ ONE_ONE_def;
builtin "ONTO" ≔ ONTO;
builtin "ONTO_def" ≔ ONTO_def;
builtin "axiom_6" ≔ axiom_6;
builtin "IND_SUC" ≔ IND_SUC;
builtin "IND_SUC_def" ≔ IND_SUC_def;
builtin "IND_0" ≔ IND_0;
builtin "IND_0_def" ≔ IND_0_def;

// type of natural numbers
builtin "N" ≔ num;
builtin "mk_num" ≔ mk_num;
builtin "dest_num" ≔ dest_num;
builtin "NUM_REP" ≔ NUM_REP;
builtin "NUM_REP_def" ≔ NUM_REP_def;
builtin "axiom_7" ≔ axiom_7;
builtin "axiom_8" ≔ axiom_8;
builtin "N0" ≔ _0;
builtin "_0_def" ≔ _0_def;
builtin "N.succ" ≔ SUC;
builtin "SUC_def" ≔ SUC_def;

// usual mathematical functions on natural numbers
builtin "NUMERAL" ≔ NUMERAL;
builtin "NUMERAL_def" ≔ NUMERAL_def;
builtin "BIT0" ≔ BIT0;
builtin "BIT0_def" ≔ BIT0_def;
builtin "BIT1" ≔ BIT1;
builtin "BIT1_def" ≔ BIT1_def;
builtin "N.pred" ≔ PRE;
builtin "PRE_def" ≔ PRE_def;
builtin "N.add" ≔ +;
builtin "add_def" ≔ +_def;
builtin "N.mul" ≔ *;
builtin "mul_def" ≔ *_def;
builtin "N.pow" ≔ EXP;
builtin "EXP_def" ≔ EXP_def;
builtin "N.le" ≔ <=;
builtin "le_def" ≔ <=_def;
builtin "N.lt" ≔ <;
builtin "lt_def" ≔ <_def;
builtin "N.ge" ≔ >=;
builtin "ge_def" ≔ >=_def;
builtin "N.gt" ≔ >;
builtin "gt_def" ≔ >_def;
builtin "N.max" ≔ MAX;
builtin "MAX_def" ≔ MAX_def;
builtin "N.min" ≔ MIN;
builtin "MIN_def" ≔ MIN_def;
builtin "N.sub" ≔ -;
builtin "minus_def" ≔ -_def;
builtin "fact" ≔ FACT;
builtin "FACT_def" ≔ FACT_def;
builtin "N.div" ≔ DIV;
builtin "DIV_def" ≔ DIV_def;
builtin "N.modulo" ≔ MOD;
builtin "MOD_def" ≔ MOD_def;
builtin "N.Even" ≔ EVEN;
builtin "EVEN_def" ≔ EVEN_def;
builtin "N.Odd" ≔ ODD;
builtin "ODD_def" ≔ ODD_def;

// wf
builtin "well_founded" ≔ WF;
builtin "WF_def" ≔ WF_def;
builtin "Acc" ≔ WFP;
builtin "WFP_def" ≔ WFP_def;

// indtypes
builtin "NUMPAIR" ≔ NUMPAIR;
builtin "NUMPAIR_def" ≔ NUMPAIR_def;
builtin "NUMFST" ≔ NUMFST;
builtin "NUMFST_def" ≔ NUMFST_def;
builtin "NUMSND" ≔ NUMSND;
builtin "NUMSND_def" ≔ NUMSND_def;
builtin "NUMSUM" ≔ NUMSUM;
builtin "NUMSUM_def" ≔ NUMSUM_def;
builtin "NUMLEFT" ≔ NUMLEFT;
builtin "NUMLEFT_def" ≔ NUMLEFT_def;
builtin "NUMRIGHT" ≔ NUMRIGHT;
builtin "NUMRIGHT_def" ≔ NUMRIGHT_def;
builtin "INJN" ≔ INJN;
builtin "INJN_def" ≔ INJN_def;
builtin "INJP" ≔ INJP;
builtin "INJP_def" ≔ INJP_def;
builtin "INJA" ≔ INJA;
builtin "INJA_def" ≔ INJA_def;
builtin "INJF" ≔ INJF;
builtin "INJF_def" ≔ INJF_def;
builtin "ZRECSPACE" ≔ ZRECSPACE;
builtin "ZRECSPACE_def" ≔ ZRECSPACE_def;
builtin "FCONS" ≔ FCONS;
builtin "FCONS_def" ≔ FCONS_def;
builtin "recspace" ≔ recspace;
builtin "_mk_rec" ≔ _mk_rec;
builtin "_dest_rec" ≔ _dest_rec;
builtin "axiom_9" ≔ axiom_9;
builtin "axiom_10" ≔ axiom_10;
builtin "ZBOT" ≔ ZBOT;
builtin "ZBOT_def" ≔ ZBOT_def;
builtin "ZCONSTR" ≔ ZCONSTR;
builtin "ZCONSTR_def" ≔ ZCONSTR_def;
builtin "BOTTOM" ≔ BOTTOM;
builtin "BOTTOM_def" ≔ BOTTOM_def;
builtin "CONSTR" ≔ CONSTR;
builtin "CONSTR_def" ≔ CONSTR_def;

// option
builtin "option" ≔ option;
builtin "_mk_option" ≔ _mk_option;
builtin "_dest_option" ≔ _dest_option;
builtin "axiom_13" ≔ axiom_13;
builtin "axiom_14" ≔ axiom_14;
builtin "None" ≔ NONE;
builtin "NONE_def" ≔ NONE_def;
builtin "Some" ≔ SOME;
builtin "SOME_def" ≔ SOME_def;

// sum
builtin "Datatypes.sum" ≔ Sum;
builtin "_mk_sum" ≔ _mk_sum;
builtin "_dest_sum" ≔ _dest_sum;
builtin "axiom_11" ≔ axiom_11;
builtin "axiom_12" ≔ axiom_12;
builtin "inl" ≔ INL;
builtin "INL_def" ≔ INL_def;
builtin "inr" ≔ INR;
builtin "INR_def" ≔ INR_def;

// lists
builtin "list" ≔ list;
builtin "_dest_list" ≔ _dest_list;
builtin "_mk_list" ≔ _mk_list;
builtin "axiom_15" ≔ axiom_15;
builtin "axiom_16" ≔ axiom_16;
builtin "nil" ≔ NIL;
builtin "NIL_def" ≔ NIL_def;
builtin "cons" ≔ CONS;
builtin "CONS_def" ≔ CONS_def;
builtin "app" ≔ APPEND;
builtin "APPEND_def" ≔ APPEND_def;
builtin "List.rev" ≔ REVERSE;
builtin "REVERSE_def" ≔ REVERSE_def;
builtin "lengthN" ≔ LENGTH;
builtin "LENGTH_def" ≔ LENGTH_def;
builtin "List.map" ≔ MAP;
builtin "MAP_def" ≔ MAP_def;
builtin "List.removelast" ≔ BUTLAST;
builtin "BUTLAST_def" ≔ BUTLAST_def;
builtin "List.Forall" ≔ ALL;
builtin "ALL_def" ≔ ALL_def;
builtin "List.ForallOrdPairs" ≔ PAIRWISE;
builtin "PAIRWISE_def" ≔ PAIRWISE_def;
builtin "FILTER" ≔ FILTER;
builtin "_FILTER_def" ≔ FILTER_def;
builtin "List.In" ≔ MEM;
builtin "MEM_def" ≔ MEM_def;
builtin "repeatN" ≔ REPLICATE;
builtin "REPLICATE_def" ≔ REPLICATE_def;
builtin "fold_right_with_perm_args" ≔ ITLIST;
builtin "ITLIST_def" ≔ ITLIST_def;
builtin "hd" ≔ HD;
builtin "HD_def" ≔ HD_def;
builtin "tl" ≔ TL;
builtin "TL_def" ≔ TL_def;
builtin "is_nil" ≔ NULL;
builtin "NULL_def" ≔ NULL_def;
builtin "List.Exists" ≔ EX;
builtin "EX_def" ≔ EX_def;
builtin "List.Forall2" ≔ ALL2;
builtin "ALL2_def" ≔ ALL2_def;
builtin "last" ≔ LAST;
builtin "LAST_def" ≔ LAST_def;
builtin "map2" ≔ MAP2;
builtin "MAP2_def" ≔ MAP2_def;
builtin "Nth" ≔ EL;
builtin "EL_def" ≔ EL_def;
builtin "assoc" ≔ ASSOC;
builtin "ASSOC_def" ≔ ASSOC_def;
builtin "zip" ≔ ZIP;
builtin "ZIP_def" ≔ ZIP_def;
builtin "Forallpairs" ≔ ALLPAIRS;
builtin "ALLPAIRS_def" ≔ ALLPAIRS_def;
builtin "list_of_Nseq" ≔ list_of_seq;
builtin "list_of_seq_def" ≔ list_of_seq_def;
builtin "fold_right2" ≔ ITLIST2;
builtin "ITLIST2_def" ≔ ITLIST2_def;

// char
builtin "Ascii.ascii" ≔ char;
builtin "_dest_char" ≔ _dest_char;
builtin "_mk_char" ≔ _mk_char;
builtin "axiom_17" ≔ axiom_17;
builtin "axiom_18" ≔ axiom_18;

// realax
builtin "dist" ≔ dist;
builtin "dist_def" ≔ dist_def;
builtin "is_nadd" ≔ is_nadd;
builtin "is_nadd_def" ≔ is_nadd_def;
builtin "nadd" ≔ nadd;
builtin "dest_nadd" ≔ dest_nadd;
builtin "mk_nadd" ≔ mk_nadd;
builtin "axiom_19" ≔ axiom_19;
builtin "axiom_20" ≔ axiom_20;

builtin "nadd_of_num" ≔ nadd_of_num;
builtin "nadd_of_num_def" ≔ nadd_of_num_def;
builtin "nadd_le" ≔ nadd_le;
builtin "nadd_le_def" ≔ nadd_le_def;
builtin "nadd_add" ≔ nadd_add;
builtin "nadd_add_def" ≔ nadd_add_def;
builtin "nadd_mul" ≔ nadd_mul;
builtin "nadd_mul_def" ≔ nadd_mul_def;
builtin "nadd_rinv" ≔ nadd_rinv;
builtin "nadd_rinv_def" ≔ nadd_rinv_def;
builtin "nadd_inv" ≔ nadd_inv;
builtin "nadd_inv_def" ≔ nadd_inv_def;
builtin "nadd_eq" ≔ nadd_eq;
builtin "nadd_eq_def" ≔ nadd_eq_def;

builtin "hreal" ≔ hreal;
builtin "mk_hreal" ≔ mk_hreal;
builtin "dest_hreal" ≔ dest_hreal;
builtin "axiom_21" ≔ axiom_21;
builtin "axiom_22" ≔ axiom_22;

builtin "hreal_of_num" ≔ hreal_of_num;
builtin "hreal_of_num_def" ≔ hreal_of_num_def;
builtin "hreal_add" ≔ hreal_add;
builtin "hreal_add_def" ≔ hreal_add_def;
builtin "hreal_mul" ≔ hreal_mul;
builtin "hreal_mul_def" ≔ hreal_mul_def;
builtin "hreal_le" ≔ hreal_le;
builtin "hreal_le_def" ≔ hreal_le_def;
builtin "hreal_inv" ≔ hreal_inv;
builtin "hreal_inv_def" ≔ hreal_inv_def;

builtin "treal_of_num" ≔ treal_of_num;
builtin "treal_of_num_def" ≔ treal_of_num_def;
builtin "treal_le" ≔ treal_le;
builtin "treal_le_def" ≔ treal_le_def;
builtin "treal_eq" ≔ treal_eq;
builtin "treal_eq_def" ≔ treal_eq_def;
builtin "treal_add" ≔ treal_add;
builtin "treal_add_def" ≔ treal_add_def;
builtin "treal_mul" ≔ treal_mul;
builtin "treal_mul_def" ≔ treal_mul_def;
builtin "treal_inv" ≔ treal_inv;
builtin "treal_inv_def" ≔ treal_inv_def;
builtin "treal_neg" ≔ treal_neg;
builtin "treal_neg_def" ≔ treal_neg_def;

builtin "R" ≔ Real;
builtin "mk_real" ≔ mk_real;
builtin "dest_real" ≔ dest_real;
builtin "axiom_23" ≔ axiom_23;
builtin "axiom_24" ≔ axiom_24;

builtin "Rle" ≔ real_le;
builtin "real_le_def" ≔ real_le_def;
builtin "Rplus" ≔ real_add;
builtin "real_add_def" ≔ real_add_def;
builtin "Rmult" ≔ real_mul;
builtin "real_mul_def" ≔ real_mul_def;
builtin "Rinv" ≔ real_inv;
builtin "real_inv_def" ≔ real_inv_def;
builtin "Ropp" ≔ real_neg;
builtin "real_neg_def" ≔ real_neg_def;
builtin "R_of_N" ≔ real_of_num;
builtin "real_of_num_def" ≔ real_of_num_def;
builtin "Rpow" ≔ real_pow;
builtin "real_pow_def" ≔ real_pow_def;
builtin "Rabs" ≔ real_abs;
builtin "real_abs_def" ≔ real_abs_def;
builtin "Rdiv" ≔ real_div;
builtin "real_div_def" ≔ real_div_def;
builtin "Rminus" ≔ real_sub;
builtin "real_sub_def" ≔ real_sub_def;
builtin "Rge" ≔ real_ge;
builtin "real_ge_def" ≔ real_ge_def;
builtin "Rgt" ≔ real_gt;
builtin "real_gt_def" ≔ real_gt_def;
builtin "Rlt" ≔ real_lt;
builtin "real_lt_def" ≔ real_lt_def;
builtin "Rmax" ≔ real_max;
builtin "real_max_def" ≔ real_max_def;
builtin "Rmin" ≔ real_min;
builtin "real_min_def" ≔ real_min_def;
builtin "Rsgn" ≔ real_sgn;
builtin "real_sgn_def" ≔ real_sgn_def;
builtin "Rmod_eq" ≔ real_mod;
builtin "real_mod_def" ≔ real_mod_def;

// integers
builtin "Z" ≔ int;
builtin "IZR" ≔ real_of_int;
builtin "int_of_real" ≔ int_of_real;
builtin "integer" ≔ integer;
builtin "integer_def" ≔ integer_def;
builtin "axiom_25" ≔ axiom_25;
builtin "axiom_26" ≔ axiom_26;
builtin "Z_of_N" ≔ int_of_num;
builtin "int_of_num_def" ≔ int_of_num_def;
builtin "Z.le" ≔ int_le;
builtin "int_le_def" ≔ int_le_def;
builtin "Z.lt" ≔ int_lt;
builtin "int_lt_def" ≔ int_lt_def;
builtin "Z.ge" ≔ int_ge;
builtin "int_ge_def" ≔ int_ge_def;
builtin "Z.gt" ≔ int_gt;
builtin "int_gt_def" ≔ int_gt_def;
builtin "Z.opp" ≔ int_neg;
builtin "int_neg_def" ≔ int_neg_def;
builtin "Z.add" ≔ int_add;
builtin "int_add_def" ≔ int_add_def;
builtin "Z.sub" ≔ int_sub;
builtin "int_sub_def" ≔ int_sub_def;
builtin "Z.mul" ≔ int_mul;
builtin "int_mul_def" ≔ int_mul_def;
builtin "Z.abs" ≔ int_abs;
builtin "int_abs_def" ≔ int_abs_def;
builtin "Z.sgn" ≔ int_sgn;
builtin "int_sgn_def" ≔ int_sgn_def;
builtin "Z.max" ≔ int_max;
builtin "int_max_def" ≔ int_max_def;
builtin "Z.min" ≔ int_min;
builtin "int_min_def" ≔ int_min_def;
builtin "Zpow" ≔ int_pow;
builtin "int_pow_def" ≔ int_pow_def;
builtin "Zdiv" ≔ div;
builtin "div_def" ≔ div_def;
builtin "Zrem" ≔ rem;
builtin "rem_def" ≔ rem_def;
builtin "Z.divide" ≔ int_divides;
builtin "int_divides_def" ≔ int_divides_def;
builtin "int_coprime" ≔ int_coprime;
builtin "int_coprime_def" ≔ int_coprime_def;
builtin "int_gcd" ≔ int_gcd;
builtin "int_gcd_def" ≔ int_gcd_def;
builtin "int_lcm" ≔ int_lcm;
builtin "int_lcm_def" ≔ int_lcm_def;

// sets
builtin "IN" ≔ IN;
builtin "IN_def" ≔ IN_def;
builtin "set0" ≔ EMPTY;
builtin "EMPTY_def" ≔ EMPTY_def;
builtin "INSERT" ≔ INSERT;
builtin "INSERT_def" ≔ INSERT_def;
builtin "UNIV_def" ≔ UNIV_def;
builtin "setT" ≔ UNIV;
builtin "GSPEC" ≔ GSPEC;
builtin "GSPEC_def" ≔ GSPEC_def;
builtin "SETSPEC" ≔ SETSPEC;
builtin "SETSPEC_def" ≔ SETSPEC_def;
builtin "subset" ≔ SUBSET;
builtin "SUBSET_def" ≔ SUBSET_def;
builtin "setU" ≔ UNION;
builtin "UNION_def" ≔ UNION_def;
builtin "setI" ≔ INTER;
builtin "INTER_def" ≔ INTER_def;
builtin "UNIONS" ≔ UNIONS;
builtin "UNIONS_def" ≔ UNIONS_def;
builtin "INTERS" ≔ INTERS;
builtin "INTERS_def" ≔ INTERS_def;
builtin "IMAGE" ≔ IMAGE;
builtin "IMAGE_def" ≔ IMAGE_def;
builtin "setD" ≔ DIFF;
builtin "DIFF_def" ≔ DIFF_def;
builtin "DELETE" ≔ DELETE;
builtin "DELETE_def" ≔ DELETE_def;
builtin "proper" ≔ PSUBSET;
builtin "PSUBSET_def" ≔ PSUBSET_def;
builtin "DISJOINT" ≔ DISJOINT;
builtin "DISJOINTdef" ≔ DISJOINT_def;
builtin "is_set1" ≔ SING;
builtin "SING_def" ≔ SING_def;
builtin "list_Union" ≔ LIST_UNION;
builtin "LIST_UNION_def" ≔ LIST_UNION_def;

// finite sets
builtin "finite_set" ≔ FINITE;
builtin "FINITE_def" ≔ FINITE_def;
builtin "fold_set" ≔ ITSET;
builtin "ITSET_def" ≔ ITSET_def;
builtin "card" ≔ CARD;
builtin "CARD_def" ≔ CARD_def;
builtin "dimindex" ≔ dimindex;
builtin "dimindex_def" ≔ dimindex_def;
builtin "set_of_list" ≔ set_of_list;
builtin "set_of_list_def" ≔ set_of_list_def;
builtin "list_of_set" ≔ list_of_set;
builtin "list_of_set_def" ≔ list_of_set_def;

// finite_image
builtin "Ninterval" ≔ …;
builtin "dotdot_def" ≔ …_def;
builtin "finite_image" ≔ finite_image;
builtin "finite_index" ≔ finite_index;
builtin "dest_finite_image" ≔ dest_finite_image;
builtin "axiom_27" ≔ axiom_27;
builtin "axiom_28" ≔ axiom_28;

// cart
builtin "cart" ≔ cart;
builtin "mk_cart" ≔ mk_cart;
builtin "dest_cart" ≔ dest_cart;
builtin "axiom_29" ≔ axiom_29;
builtin "axiom_30" ≔ axiom_30;

// finite_sum
builtin "finite_sum" ≔ finite_sum;
builtin "mk_finite_sum" ≔ mk_finite_sum;
builtin "dest_finite_sum" ≔ dest_finite_sum;
builtin "axiom_31" ≔ axiom_31;
builtin "axiom_32" ≔ axiom_32;

// finite_diff
builtin "finite_diff" ≔ finite_diff;
builtin "mk_finite_diff" ≔ mk_finite_diff;
builtin "dest_finite_diff" ≔ dest_finite_diff;
builtin "axiom_33" ≔ axiom_33;
builtin "axiom_34" ≔ axiom_34;

// finite_prod
builtin "finite_prod" ≔ finite_prod;
builtin "mk_finite_prod" ≔ mk_finite_prod;
builtin "dest_finite_prod" ≔ dest_finite_prod;
builtin "axiom_35" ≔ axiom_35;
builtin "axiom_36" ≔ axiom_36;

// tybit0
builtin "tybit0" ≔ tybit0;
builtin "_mk_tybit0" ≔ _mk_tybit0;
builtin "_dest_tybit0" ≔ _dest_tybit0;
builtin "axiom_37" ≔ axiom_37;
builtin "axiom_38" ≔ axiom_38;

// tybit1
builtin "tybit1" ≔ tybit1;
builtin "_mk_tybit1" ≔ _mk_tybit1;
builtin "_dest_tybit1" ≔ _dest_tybit1;
builtin "axiom_39" ≔ axiom_39;
builtin "axiom_40" ≔ axiom_40;

// topology
builtin "Topology" ≔ Topology;
builtin "topology" ≔ topology;
builtin "open" ≔ _open;
builtin "_mk_dest_Topology" ≔ axiom_41;
builtin "_dest_mk_Topology" ≔ axiom_42;

// Metric from Library/analysis.ml
builtin "ismet" ≔ ismet;
builtin "ismet_def" ≔ ismet_def;
builtin "Metric" ≔ Metric;
builtin "Metric_def" ≔ Metric_def;
builtin "mdist" ≔ mdist;
builtin "mdist_def" ≔ mdist_def;
builtin "metric" ≔ metric;
builtin "metric_def" ≔ metric_def;
builtin "_mk_dest_Metric" ≔ axiom_43;
builtin "_dest_mk_Metric" ≔ axiom_44;

// multiset
builtin "Multiset" ≔ Multiset;
builtin "multiset" ≔ multiset;
builtin "multiplicity" ≔ multiplicity;
builtin "_mk_dest_Multiset" ≔ axiom_45;
builtin "_dest_mk_Multiset" ≔ axiom_46;
builtin "mempty" ≔ mempty;
builtin "mempty_def" ≔ mempty_def;
builtin "mmember" ≔ mmember;
builtin "mmember_def" ≔ mmember_def;
builtin "msing" ≔ msing;
builtin "msing_def" ≔ msing_def;
builtin "munion" ≔ munion;
builtin "munion_def" ≔ munion_def;
builtin "mdiff" ≔ mdiff;
builtin "mdiff_def" ≔ mdiff_def;
builtin "morder" ≔ morder;
builtin "morder_def" ≔ morder_def;

// terms
builtin "term" ≔ term;
builtin "list_204637" ≔ list_204637;
builtin "_mk_list_204637" ≔ _mk_list_204637;
builtin "_dest_list_204637" ≔ _dest_list_204637;
builtin "_mk_term" ≔ _mk_term;
builtin "_dest_term" ≔ _dest_term;
builtin "_mk_dest_list_204637" ≔ axiom_47;
builtin "_dest_mk_list_204637" ≔ axiom_48;
builtin "_mk_dest_term" ≔ axiom_49;
builtin "_dest_mk_term" ≔ axiom_50;
builtin "V" ≔ _204638;
builtin "V_def" ≔ _204638_def;
builtin "Fn" ≔ _204639;
builtin "Fn_def" ≔ _204639_def;
builtin "tnil" ≔ _204640;
builtin "_204640_def" ≔ _204640_def;
builtin "tcons" ≔ _204641;
builtin "_204641_def" ≔ _204641_def;
builtin "Fn" ≔ _204757;
builtin "_204757_def" ≔ _204757_def;
builtin "V" ≔ V;
builtin "V_def'" ≔ V_def;
builtin "Fn" ≔ Fn;
builtin "Fn_def'" ≔ Fn_def;

//formulae
builtin "form" ≔ form;
builtin "_dest_form" ≔ _dest_form;
builtin "_mk_form" ≔ _mk_form;
builtin "_mk_dest_form" ≔ axiom_51;
builtin "_dest_mk_form" ≔ axiom_52;
builtin "FFalse" ≔ _204798;
builtin "FFalse_def" ≔ _204798_def;
builtin "Atom" ≔ _204799;
builtin "Atom_def" ≔ _204799_def;
builtin "FImp" ≔ _204800;
builtin "FImp_def" ≔ _204800_def;
builtin "FAll" ≔ _204801;
builtin "FAll_def" ≔ _204801_def;
builtin "FFalse" ≔ False;
builtin "FFalse_def'" ≔ False_def;
builtin "Atom" ≔ Atom;
builtin "Atom_def'" ≔ Atom_def;
builtin "FImp" ≔ ⟶;
builtin "FImp_def'" ≔ ⟶_def;
builtin "FAll" ≔ !!;
builtin "FAll_def'" ≔ !!_def;
builtin "Not" ≔ Not;
builtin "Not_def" ≔ Not_def;
builtin "FTrue" ≔ True;
builtin "FTrue_def" ≔ True_def;
builtin "FOr" ≔ ¦¦;
builtin "FOr_def" ≔ ¦¦_def;
builtin "FAnd" ≔ &&;
builtin "FAnd_def" ≔ &&_def;
builtin "FEquiv" ≔ ↔;
builtin "FEquiv_def" ≔ ↔_def;
builtin "FEx" ≔ ??;
builtin "FEx_def" ≔ ??_def;

// retval
builtin "retval" ≔ retval;
builtin "_mk_retval" ≔ _mk_retval;
builtin "_dest_retval" ≔ _dest_retval;
builtin "_mk_dest_retval" ≔ axiom_53;
builtin "_dest_mk_retval" ≔ axiom_54;
builtin "TT" ≔ _261630;
builtin "TT_def" ≔ _261630_def;
builtin "FF" ≔ _261631;
builtin "FF_def" ≔ _261631_def;
builtin "Exception" ≔ _261632;
builtin "Exception_def" ≔ _261632_def;
builtin "TT" ≔ TT;
builtin "TT_def'" ≔ TT_def;
builtin "FF" ≔ FF;
builtin "FF_def'" ≔ FF_def;
builtin "Exception" ≔ Exception;
builtin "Exception_def'" ≔ Exception_def;

// LOGIC library
builtin "functions_term" ≔ functions_term;
builtin "functions_term_def" ≔ functions_term_def;
builtin "functions_form" ≔ functions_form;
builtin "functions_form_def" ≔ functions_form_def;
builtin "predicates_form" ≔ predicates_form;
builtin "predicates_form_def" ≔ predicates_form_def;
builtin "functions" ≔ functions;
builtin "functions_def" ≔ functions_def;
builtin "predicates" ≔ predicates;
builtin "predicates_def" ≔ predicates_def;
builtin "language" ≔ language;
builtin "language_def" ≔ language_def;
builtin "Dom" ≔ Dom;
builtin "Dom_def" ≔ Dom_def;
builtin "Fun" ≔ Fun;
builtin "Fun_def" ≔ Fun_def;
builtin "Pred" ≔ Pred;
builtin "Pred_def" ≔ Pred_def;
builtin "free_variables_term" ≔ FVT;
builtin "FVT_def" ≔ FVT_def;
builtin "free_variables" ≔ FV;
builtin "FV_def" ≔ FV_def;
builtin "bound_variables" ≔ BV;
builtin "BV_def" ≔ BV_def;
builtin "valmod" ≔ valmod;
builtin "valmod_def" ≔ valmod_def;
builtin "valuation" ≔ valuation;
builtin "valuation_def" ≔ valuation_def;
builtin "termval" ≔ termval;
builtin "termval_def" ≔ termval_def;
builtin "holds" ≔ holds;
builtin "holds_def" ≔ holds_def;
builtin "hold" ≔ hold;
builtin "hold_def" ≔ hold_def;
builtin "satisfies" ≔ satisfies;
builtin "satisfies_def" ≔ satisfies_def;
builtin "satisfiable" ≔ satisfiable;
builtin "satisfiable_def" ≔ satisfiable_def;
builtin "valid" ≔ valid;
builtin "valid_def" ≔ valid_def;
builtin "entails" ≔ entails;
builtin "entails_def" ≔ entails_def;
builtin "equivalent" ≔ equivalent;
builtin "equivalent_def" ≔ equivalent_def;
builtin "interpretation" ≔ interpretation;
builtin "interpretation_def" ≔ interpretation_def;
builtin "termsubst" ≔ termsubst;
builtin "termsubst_def" ≔ termsubst_def;
builtin "SETMAX" ≔ SETMAX;
builtin "SETMAX_def" ≔ SETMAX_def;
builtin "VARIANT" ≔ VARIANT;
builtin "VARIANT_def" ≔ VARIANT_def;
builtin "formsubst" ≔ formsubst;
builtin "formsubst_def" ≔ formsubst_def;
builtin "qfree" ≔ qfree;
builtin "qfree_def" ≔ qfree_def;
builtin "PPAT" ≔ PPAT;
builtin "PPAT_def" ≔ PPAT_def;
builtin "prenex" ≔ prenex;
builtin "prenex_def" ≔ prenex_def;
builtin "universal" ≔ universal;
builtin "universal_def" ≔ universal_def;
builtin "sizeN" ≔ size;
builtin "size_def" ≔ size_def;
builtin "Prenex_right" ≔ Prenex_right;
builtin "Prenex_right_def" ≔ Prenex_right_def;
builtin "Prenex_left" ≔ Prenex_left;
builtin "Prenex_left_def" ≔ Prenex_left_def;
builtin "Prenex" ≔ Prenex;
builtin "Prenex_def" ≔ Prenex_def;
builtin "Skolem1" ≔ Skolem1;
builtin "Skolem1_def" ≔ Skolem1_def;
builtin "Skolems" ≔ Skolems;
builtin "Skolems_def" ≔ Skolems_def;
builtin "Skopre" ≔ Skopre;
builtin "Skopre_def" ≔ Skopre_def;
builtin "bumpmod" ≔ bumpmod;
builtin "bumpmod_def" ≔ bumpmod_def;
builtin "bumpterm" ≔ bumpterm;
builtin "bumpterm_def" ≔ bumpterm_def;
builtin "bumpform" ≔ bumpform;
builtin "bumpform_def" ≔ bumpform_def;
builtin "unbumpterm" ≔ unbumpterm;
builtin "unbumpterm_def" ≔ unbumpterm_def;
builtin "unbumpform" ≔ unbumpform;
builtin "unbumpform_def" ≔ unbumpform_def;
builtin "unbumpmod" ≔ unbumpmod;
builtin "unbumpmod_def" ≔ unbumpmod_def;
builtin "NUMLIST" ≔ NUMLIST;
builtin "NUMLIST_def" ≔ NUMLIST_def;
builtin "num_of_term" ≔ num_of_term;
builtin "num_of_term_def" ≔ num_of_term_def;
builtin "num_of_form" ≔ num_of_form;
builtin "num_of_form_def" ≔ num_of_form_def;
builtin "form_of_num" ≔ form_of_num;
builtin "form_of_num_def" ≔ form_of_num_def;
builtin "SKOLEMIZE" ≔ SKOLEMIZE;
builtin "SKOLEMIZE_def" ≔ SKOLEMIZE_def;
builtin "SKOMOD1" ≔ SKOMOD1;
builtin "SKOMOD1_def" ≔ SKOMOD1_def;
builtin "SKOMOD" ≔ SKOMOD;
builtin "SKOMOD_def" ≔ SKOMOD_def;
builtin "specialize" ≔ specialize;
builtin "specialize_def" ≔ specialize_def;
builtin "SKOLEM" ≔ SKOLEM;
builtin "SKOLEM_def" ≔ SKOLEM_def;
builtin "pholds" ≔ pholds;
builtin "pholds_def" ≔ pholds_def;
builtin "psatisfies" ≔ psatisfies;
builtin "psatisfies_def" ≔ psatisfies_def;
builtin "psatisfiable" ≔ psatisfiable;
builtin "psatisfiable_def" ≔ psatisfiable_def;
builtin "finsat" ≔ finsat;
builtin "finsat_def" ≔ finsat_def;
builtin "terms" ≔ terms;
builtin "terms_def" ≔ terms_def;
builtin "canonical" ≔ canonical;
builtin "canonical_def" ≔ canonical_def;
builtin "holds" ≔ prop_of_model;
builtin "prop_of_model_def" ≔ prop_of_model_def;
builtin "canon_of_prop" ≔ canon_of_prop;
builtin "canon_of_prop_def" ≔ canon_of_prop_def;
builtin "term_of_num" ≔ term_of_num;
builtin "term_of_num_def" ≔ term_of_num_def;
builtin "LOWMOD" ≔ LOWMOD;
builtin "LOWMOD_def" ≔ LOWMOD_def;
builtin "herbase" ≔ herbase;
builtin "herbase_def" ≔ herbase_def;
builtin "herbrand" ≔ herbrand;
builtin "herbrand_def" ≔ herbrand_def;
builtin "herbrand_of_prop" ≔ herbrand_of_prop;
builtin "herbrand_of_prop_def" ≔ herbrand_of_prop_def;
builtin "FEq" ≔ ===;
builtin "FEq_def" ≔ ===_def;
builtin "uclose" ≔ uclose;
builtin "uclose_def" ≔ uclose_def;
builtin "normal" ≔ normal;
builtin "normal_def" ≔ normal_def;
builtin "Varpairs" ≔ Varpairs;
builtin "Varpairs_def" ≔ Varpairs_def;
builtin "Eqaxiom_Func" ≔ Eqaxiom_Func;
builtin "Eqaxiom_Func_def" ≔ Eqaxiom_Func_def;
builtin "Eqaxiom_Pred" ≔ Eqaxiom_Pred;
builtin "Eqaxiom_Pred_def" ≔ Eqaxiom_Pred_def;
builtin "Eqaxioms" ≔ Eqaxioms;
builtin "Eqaxioms_def" ≔ Eqaxioms_def;
builtin "OCC" ≔ OCC;
builtin "OCC_def" ≔ OCC_def;
builtin "LOOPFREE" ≔ LOOPFREE;
builtin "LOOPFREE_def" ≔ LOOPFREE_def;
builtin "rightsubst" ≔ rightsubst;
builtin "rightsubst_def" ≔ rightsubst_def;
builtin "SOLVE" ≔ SOLVE;
builtin "SOLVE_def" ≔ SOLVE_def;
builtin "SOLVEC" ≔ SOLVEC;
builtin "SOLVEC_def" ≔ SOLVEC_def;
builtin "CONFLICTFREE" ≔ CONFLICTFREE;
builtin "CONFLICTFREE_def" ≔ CONFLICTFREE_def;
builtin "istriv" ≔ istriv;
builtin "istriv_def" ≔ istriv_def;
builtin "EQV" ≔ EQV;
builtin "EQV_def" ≔ EQV_def;
builtin "SUB1" ≔ SUB1;
builtin "SUB1_def" ≔ SUB1_def;
builtin "termcases" ≔ termcases;
builtin "termcases_def" ≔ termcases_def;
builtin "tpcases" ≔ tpcases;
builtin "tpcases_def" ≔ tpcases_def;
builtin "MLEFT" ≔ MLEFT;
builtin "MLEFT_def" ≔ MLEFT_def;
builtin "CRIGHT" ≔ CRIGHT;
builtin "CRIGHT_def" ≔ CRIGHT_def;
builtin "CALLORDER" ≔ CALLORDER;
builtin "CALLORDER_def" ≔ CALLORDER_def;
//builtin "diese" ≔ diese;
//builtin "diese_def" ≔ diese_def;
