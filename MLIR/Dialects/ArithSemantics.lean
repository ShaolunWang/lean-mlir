/-
## `arith` dialect

This file formalises part of the `arith` dialect. The goal is to showcase
operations on multiple types (with overloading) and basic reasoning. `arith`
does not have new datatypes, but it supports operations on tensors and vectors,
which are some of the most complex builtin types.

TODO: This file uses shorter operation names (without "arith.") to work around
      a normalization performance issue that is affected by the string length
See https://leanprover.zulipchat.com/#narrow/stream/270676-lean4/topic/unfold.20essentially.20loops
-/

import MLIR.Semantics.Fitree
import MLIR.Semantics.Semantics
import MLIR.Semantics.SSAEnv
import MLIR.Semantics.UB
import MLIR.Dialects.BuiltinModel
import MLIR.Util.Metagen
import MLIR.AST
import MLIR.EDSL
open MLIR.AST

/-
### Dialect extensions

`arith` has no extended types or attributes.
-/

instance arith: Dialect Void Void (fun _ => Unit) where
  iα := inferInstance
  iε := inferInstance

/-
### Dialect operations

In order to support type overloads while keeping reasonably-strong typing on
operands and disallowing incorrect types in the operation arguments, we define
scalar, tensor, and vector overloads of each operation.
-/

inductive ComparisonPred :=
  | eq  | ne
  | slt | sle | sgt | sge
  | ult | ule | ugt | uge

def ComparisonPred.ofInt: Int → Option ComparisonPred
  | 0 => some eq
  | 1 => some ne
  | 2 => some slt
  | 3 => some sle
  | 4 => some sgt
  | 5 => some sge
  | 6 => some ult
  | 7 => some ule
  | 8 => some ugt
  | 9 => some uge
  | _ => none

inductive ArithE: Type → Type :=
  | CmpI: (sz: Nat) → (pred: ComparisonPred) → (lhs rhs: FinInt sz) →
          ArithE (FinInt 1)
  | AddI: (sz: Nat) → (lhs rhs: FinInt sz) →
          ArithE (FinInt sz)
  | AddT: (sz: Nat) → (D: DimList) → (lhs rhs: RankedTensor D (.int sgn sz)) →
          ArithE (RankedTensor D (.int sgn sz))
  | AddV: (sz: Nat) → (sc fx: List Nat) →
          (lhs rhs: Vector sc fx (.int sgn sz)) →
          ArithE (Vector sc fx (.int sgn sz))
  | SubI: (sz: Nat) → (lhs rhs: FinInt sz) →
          ArithE (FinInt sz)
  | NegI: (sz: Nat) → (op: FinInt sz) →
          ArithE (FinInt sz)
  | AndI: (sz: Nat) → (lhs rhs: FinInt sz) →
          ArithE (FinInt sz)
  | OrI: (sz: Nat) → (lhs rhs: FinInt sz) →
          ArithE (FinInt sz)
  | XorI: (sz: Nat) → (lhs rhs: FinInt sz) →
          ArithE (FinInt sz)

def unary_semantics_op (op: IOp Δ)
      (ctor: (sz: Nat) → FinInt sz → ArithE (FinInt sz)):
    Option (Fitree (RegionE Δ +' UBE +' ArithE) (BlockResult Δ)) :=
  match op with
  | IOp.mk name [⟨.int sgn sz, arg⟩] [] 0 _ _ => some do
      let r ← Fitree.trigger (ctor sz arg)
      return BlockResult.Next ⟨.int sgn sz, r⟩
  | IOp.mk _ _ _ _ _ _ => none

def binary_semantics_op (op: IOp Δ)
      (ctor: (sz: Nat) → FinInt sz → FinInt sz → ArithE (FinInt sz)):
    Option (Fitree (RegionE Δ +' UBE +' ArithE) (BlockResult Δ)) :=
  match op with
  | IOp.mk name [⟨.int sgn sz, lhs⟩, ⟨.int sgn' sz', rhs⟩] [] 0 _ _ => some do
      if EQ: sgn = sgn' /\ sz = sz' then
        let r ← Fitree.trigger (ctor sz lhs (EQ.2 ▸ rhs))
        return BlockResult.Next ⟨.int sgn sz, r⟩
      else
        Fitree.trigger <| UBE.DebugUB s!"{name}: incompatible operand types"
        return BlockResult.Ret []
  | IOp.mk _ _ _ _ _ _ => none

def arith_semantics_op (o: IOp Δ):
    Option (Fitree (RegionE Δ +' UBE +' ArithE) (BlockResult Δ)) :=
  match o with
  | IOp.mk "constant" [] [] 0 attrs (.fn (.tuple []) τ₁) => some <|
      match AttrDict.find attrs "value" with
      | some (.int value τ₂) =>
          if τ₁ = τ₂ then
            match τ₂ with
            | .int sgn sz => do
                -- TODO: Check range of constants
                let v := FinInt.ofInt sgn sz value
                return BlockResult.Next ⟨.int sgn sz, v⟩
            | _ => do
                Fitree.trigger $ UBE.DebugUB "non maching width of arith.const"
                return BlockResult.Ret []
          else do
                Fitree.trigger $ UBE.DebugUB "non maching type of arith.const"
                return BlockResult.Ret []
      | some _
      | none => do
            Fitree.trigger $ UBE.DebugUB "non maching type of arith.const"
            return BlockResult.Ret []

  | IOp.mk "cmpi" [ ⟨(.int sgn sz), lhs⟩, ⟨(.int sgn' sz'), rhs⟩ ] [] 0
    attrs _ => some <|
      if EQ: sgn = sgn' /\ sz = sz' then
            match attrs.find "predicate" with
            | some (.int n (.int .Signless 64)) => do
                match (ComparisonPred.ofInt n) with
                | some pred => do
                  let r ← Fitree.trigger (ArithE.CmpI sz pred lhs (EQ.2 ▸ rhs))
                  return BlockResult.Next ⟨.i1, r⟩
                | none =>
                  Fitree.trigger $ UBE.DebugUB "unable to create ComparisonPred"
                  return BlockResult.Ret []
            | some _
            | none => do
                Fitree.trigger $ UBE.DebugUB "unable to find predicate"
                return BlockResult.Ret []
      else do
        Fitree.trigger $ UBE.DebugUB "lhs, rhs, unequal sizes (cmp)"
        return BlockResult.Ret []

  | IOp.mk "negi" _ _ _ _ _ =>
      unary_semantics_op o ArithE.NegI
  | IOp.mk name _ _ _ _ _ =>
      if name = "addi" then
        binary_semantics_op o ArithE.AddI
      else if name = "subi" then
        binary_semantics_op o ArithE.SubI
      else if name = "andi" then
        binary_semantics_op o ArithE.AndI
      else if name = "ori" then
        binary_semantics_op o ArithE.OrI
      else if name = "xori" then
        binary_semantics_op o ArithE.XorI
      else
        none

def ArithE.handle {E}: ArithE ~> Fitree E := fun _ e =>
  match e with
  | AddI _ lhs rhs =>
      return lhs + rhs
  | AddT sz D lhs rhs =>
      -- TODO: Implementation of ArithE.AddT (tensor addition)
      return default
  | AddV sz sc fx lhs rhs =>
      -- TODO: Implementation of ArithE.AddV (vector addition)
      return default
  | CmpI _ pred lhs rhs =>
      let b: Bool :=
        match pred with
        | .eq  => lhs = rhs
        | .ne  => lhs != rhs
        | .slt => lhs.toSint <  rhs.toSint
        | .sle => lhs.toSint <= rhs.toSint
        | .sgt => lhs.toSint >  rhs.toSint
        | .sge => lhs.toSint >= rhs.toSint
        | .ult => lhs.toUint <  rhs.toUint
        | .ule => lhs.toUint <= rhs.toUint
        | .ugt => lhs.toUint >  rhs.toUint
        | .uge => lhs.toUint >= rhs.toUint
      return FinInt.ofInt .Signless 1 (if b then 1 else 0)
  | SubI _ lhs rhs =>
      return lhs - rhs
  | NegI _ op =>
      return -op
  | AndI _ lhs rhs =>
      return lhs &&& rhs
  | OrI _ lhs rhs =>
      return lhs ||| rhs
  | XorI _ lhs rhs =>
      return lhs ^^^ rhs

instance: Semantics arith where
  E := ArithE
  semantics_op := arith_semantics_op
  handle := ArithE.handle

/-
### Basic examples
-/

private def cst1: BasicBlock arith := [mlir_bb|
  ^bb:
    %true = "constant" () {value = 1: i1}: () -> i1
    %false = "constant" () {value = 0: i1}: () -> i1
    %r1 = "constant" () {value = 25: i32}: () -> i32
    %r2 = "constant" () {value = 17: i32}: () -> i32
    %r = "addi" (%r1, %r2): (i32, i32) -> i32
    %s = "subi" (%r2, %r): (i32, i32) -> i32
    %b1 = "cmpi" (%r, %r1) {predicate = 5 /- sge -/}: (i32, i32) -> i1
    %b2 = "cmpi" (%r2, %r) {predicate = 8 /- ugt -/}: (i32, i32) -> i1
]

#eval run (Δ := arith) ⟦cst1⟧ (SSAEnv.empty (δ := arith))


/-
### Rewriting heorems
-/

open FinInt(mod2)
private theorem mod2_equal: x = y → mod2 x n = mod2 y n :=
  fun | .refl _ => rfl

/-===  n+m  <-->  m+n  ===-/

private def th1_org: BasicBlockStmt arith := [mlir_bb_stmt|
  %r = "addi"(%n, %m): (i32, i32) -> i32
]
private def th1_out: BasicBlockStmt arith := [mlir_bb_stmt|
  %r = "addi"(%m, %n): (i32, i32) -> i32
]

/- private theorem th1:
  forall (n m: FinInt 32),
    run ⟦th1_org⟧ (SSAEnv.One [ ("n", ⟨.i32, n⟩), ("m", ⟨.i32, m⟩) ]) =
    run ⟦th1_out⟧ (SSAEnv.One [ ("n", ⟨.i32, n⟩), ("m", ⟨.i32, m⟩) ]) := by
  intros n m
  simp [Denote.denote]
  simp [run, th1_org, th1_out, denoteBBStmt, denoteOp]
  simp [interp_ub, SSAEnv.get]; simp_itree
  simp [interp_ssa, interp_state, SSAEnvE.handle, SSAEnv.get]; simp_itree
  simp [SSAEnv.get]; simp_itree
  simp [Semantics.handle, ArithE.handle, SSAEnv.get]; simp_itree
  simp [FinInt.add_comm] -/

/- LLVM InstCombine: `C-(X+C2) --> (C-C2)-X`
   https://github.com/llvm/llvm-project/blob/291e3a85658e264a2918298e804972bd68681af8/llvm/lib/Transforms/InstCombine/InstCombineAddSub.cpp#L1794 -/

theorem FinInt.sub_add_dist: forall (C X C2: FinInt sz),
    C - (X + C2) = (C - C2) - X := by
  intros C X C2
  apply eq_of_toUint_cong2
  simp [cong2, FinInt.sub_toUint, FinInt.add_toUint]
  apply mod2_equal
  simp [Int.sub_add_dist]
  sorry_arith -- rearrange terms

private def th2_org: BasicBlock arith := [mlir_bb|
  ^bb:
    %t = "addi"(%X, %C2): (i32, i32) -> i32
    %r = "subi"(%C, %t): (i32, i32) -> i32
]
private def th2_out: BasicBlock arith := [mlir_bb|
  ^bb:
    %t = "subi"(%C, %C2): (i32, i32) -> i32
    %r = "subi"(%t, %X): (i32, i32) -> i32
]
private def th2_input (C X C2: FinInt 32): SSAEnv arith := SSAEnv.One [
  ("C", ⟨.i32, C⟩), ("X", ⟨.i32, X⟩), ("C2", ⟨.i32, C2⟩)
]

/- private theorem th2:
  forall (C X C2: FinInt 32),
    (run (denoteBB _ th2_org) (th2_input C X C2) |>.snd.get "r" .i32) =
    (run (denoteBB _ th2_out) (th2_input C X C2) |>.snd.get "r" .i32) := by
  intros C X C2
  simp [th2_input, th2_org, th2_out]
  simp [run, denoteBB, denoteBBStmt, denoteOp]; simp_itree
  simp [interp_ub]; simp_itree
  simp [interp_ssa, interp_state, SSAEnvE.handle, SSAEnv.get]; simp_itree
  simp [SSAEnv.get]; simp_itree
  simp [Semantics.handle, ArithE.handle, SSAEnv.get]; simp_itree
  simp [SSAEnv.get]; simp_itree
  simp [SSAEnv.get]; simp_itree
  apply FinInt.sub_add_dist -/

/- LLVM InstCombine: `~X + C --> (C-1) - X`
   https://github.com/llvm/llvm-project/blob/291e3a85658e264a2918298e804972bd68681af8/llvm/lib/Transforms/InstCombine/InstCombineAddSub.cpp#L882 -/

theorem FinInt.comp_add: sz > 0 → forall (X C: FinInt sz),
    comp X + C = (C - FinInt.ofUint sz 1) - X := by
  intros h_sz X C
  apply eq_of_toUint_cong2
  simp [cong2, FinInt.add_toUint, FinInt.comp_toUint, FinInt.sub_toUint]
  simp [FinInt.toUint_ofUint]
  have h: mod2 1 sz = 1 := mod2_idem ⟨by decide, by sorry_arith⟩
  simp [h]
  sorry_arith -- eliminate 2^sz in lhs, then mod2_equal

private def th3_org: BasicBlock arith := [mlir_bb|
  ^bb:
    %o = "constant"() {value = 1: i32}: () -> i32
    %m = "negi"(%o): (i32) -> i32
    %r = "addi"(%m, %C): (i32, i32) -> i32
]

private abbrev th3_org_1: BasicBlockStmt arith := [mlir_bb_stmt|
    %o = "constant"() {value = 1: i32}: () -> i32
]

private abbrev th3_org_2: BasicBlockStmt arith := [mlir_bb_stmt|
    %m = "negi"(%o): (i32) -> i32
]

private abbrev th3_org_3: BasicBlockStmt arith := [mlir_bb_stmt|
    %r = "addi"(%m, %C): (i32, i32) -> i32
]

private def th3_out: BasicBlock arith := [mlir_bb|
  ^bb:
    %o = "constant"() {value = 1: i32}: () -> i32
    %t = "subi"(%C, %o): (i32, i32) -> i32
    %r = "subi"(%t, %X): (i32, i32) -> i32
]
private def th3_input (C X: FinInt 32): SSAEnv arith := SSAEnv.One [
    ("C", ⟨.i32, C⟩), ("X", ⟨.i32, X⟩)
]

theorem Fitree.bind_Ret: Fitree.bind (Fitree.Ret r) k = k r := rfl

theorem Fitree.bind_ret: Fitree.bind (Fitree.ret r) k = k r := rfl

theorem Fitree.bind_Vis: Fitree.bind (Fitree.Vis e k) k' =
  Fitree.Vis e (fun r => bind (k r) k') := rfl


private theorem semantics_constant_stmt : denoteBBStmt arith th3_org_1 =
  (Fitree.Vis (E := UBE +' SSAEnvE arith +' Semantics.E arith)
    (Sum.inr
      (Sum.inl
        (SSAEnvE.Set (MLIRType.int Signedness.Signless 32) (SSAVal.SSAVal "o")
          (FinInt.ofInt Signedness.Signless 32 1))))
    fun r =>
    Fitree.ret
      (BlockResult.Next (δ := arith) { fst := MLIRType.int Signedness.Signless 32, snd := FinInt.ofInt Signedness.Signless 32 1 })) := by
  simp [th3_org_1]
  simp [denoteBBStmt, denoteOp, Semantics.semantics_op]
  simp_itree
  simp [arith_semantics_op]
  simp [AttrDict.find, List.find?, AttrEntry.key, AttrEntry.value]
  simp [pure]
  simp_itree

private theorem semantics_neg_stmt : denoteBBStmt arith th3_org_2 = 
  (Fitree.Vis (E := UBE +' SSAEnvE arith +' Semantics.E arith) (Sum.inr (Sum.inl (SSAEnvE.Get (MLIRType.int Signedness.Signless 32) (SSAVal.SSAVal "o")))) fun r =>
    Fitree.Vis (Sum.inr (Sum.inr (ArithE.NegI 32 r))) fun r =>
      Fitree.Vis (Sum.inr (Sum.inl (SSAEnvE.Set (MLIRType.int Signedness.Signless 32) (SSAVal.SSAVal "m") r)))
        fun r_1 => Fitree.ret (BlockResult.Next { fst := MLIRType.int Signedness.Signless 32, snd := r })) := by 
  simp [th3_org_2]
  simp [denoteBBStmt, denoteOp, Semantics.semantics_op]
  simp_itree

private theorem semantics_addi_stmt : denoteBBStmt arith th3_org_3 = 
  (Fitree.Vis (E := UBE +' SSAEnvE arith +' Semantics.E arith) (Sum.inr (Sum.inl (SSAEnvE.Get (MLIRType.int Signedness.Signless 32) (SSAVal.SSAVal "m")))) fun r =>
    Fitree.Vis (Sum.inr (Sum.inl (SSAEnvE.Get (MLIRType.int Signedness.Signless 32) (SSAVal.SSAVal "C")))) fun r_1 =>
      Fitree.Vis (Sum.inr (Sum.inr (ArithE.AddI 32 r r_1))) fun r =>
        Fitree.Vis (Sum.inr (Sum.inl (SSAEnvE.Set (MLIRType.int Signedness.Signless 32) (SSAVal.SSAVal "r") r)))
          fun r_2 => Fitree.ret (BlockResult.Next { fst := MLIRType.int Signedness.Signless 32, snd := r })) := by
  simp [th3_org_3]
  simp [denoteBBStmt, denoteOp, Semantics.semantics_op]
  simp_itree

def state_res (C X: FinInt 32) : Option (BlockResult arith) × SSAEnv arith := ((some 
    (BlockResult.Next (δ := arith)
      { fst := MLIRType.int Signedness.Signless 32, snd := -FinInt.ofInt Signedness.Signless 32 1 + C })),
    SSAEnv.One (δ := arith)
      [(SSAVal.SSAVal "C", { fst := MLIRType.i32, snd := C }), (SSAVal.SSAVal "X", { fst := MLIRType.i32, snd := X }),
        (SSAVal.SSAVal "o",
          { fst := MLIRType.int Signedness.Signless 32, snd := FinInt.ofInt Signedness.Signless 32 1 }),
        (SSAVal.SSAVal "m",
          { fst := MLIRType.int Signedness.Signless 32, snd := -FinInt.ofInt Signedness.Signless 32 1 }),
        (SSAVal.SSAVal "r",
          { fst := MLIRType.int Signedness.Signless 32, snd := -FinInt.ofInt Signedness.Signless 32 1 + C })])

private theorem th3_left: forall (C X: FinInt 32),
    run (denoteBB _ th3_org) (th3_input C X) = state_res C X := by
  intros C X
  dsimp [th3_input, th3_org, th3_out, run]
  unfold denoteBB
  rw [semantics_constant_stmt]
  simp
  unfold denoteBB
  rw [semantics_neg_stmt]
  simp
  unfold denoteBB
  rw [semantics_addi_stmt]
  simp [interp_ub]
  simp [interp]
  simp_itree
  simp [interp_ssa]
  simp_itree
  simp [interp_state, interp]
  simp_itree
  simp [SSAEnvE.handle]
  rw [SSAEnv.get_set_eq]
  simp
  simp_itree
  rw [SSAEnv.get_set_eq]
  simp_itree
  rw [SSAEnv.get_set_ne_val] <;> (try intros _; contradiction)
  rw [SSAEnv.get_set_ne_val] <;> (try intros _; contradiction)
  simp [SSAEnv.get]
  simp [Fitree.bind]
  simp [interp]
  simp [Semantics.handle, ArithE.handle]
  simp_itree
  simp [Fitree.run, Fitree.ret]
  simp [SSAEnv.get, SSAEnv.set]
  unfold state_res
  rfl

