"builtin.module"() ({
  "func.func"() ({
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "func_empty"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32):
    "cf.br"()[^bb1] : () -> ()
  ^bb1:  // pred: ^bb0
    %0 = "arith.addi"(%arg0, %arg1) : (i32, i32) -> i32
    "func.return"(%0) : (i32) -> ()
  }) {function_type = (i32, i32) -> i32, sym_name = "func_simpleBranch"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: i1, %arg1: i32, %arg2: i32):
    "cf.cond_br"(%arg0)[^bb1, ^bb2] {operand_segment_sizes = dense<[1, 0, 0]> : vector<3xi32>} : (i1) -> ()
  ^bb1:  // pred: ^bb0
    "cf.br"()[^bb3] : () -> ()
  ^bb2:  // pred: ^bb0
    "cf.br"()[^bb3] : () -> ()
  ^bb3:  // 2 preds: ^bb1, ^bb2
    %0 = "arith.addi"(%arg1, %arg2) : (i32, i32) -> i32
    "func.return"(%0) : (i32) -> ()
  }) {function_type = (i1, i32, i32) -> i32, sym_name = "func_condBranch"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32):
    %0 = "arith.constant"() {value = 0 : i32} : () -> i32
    "cf.br"(%0, %arg0)[^bb1] : (i32, i32) -> ()
  ^bb1(%1: i32, %2: i32):  // 2 preds: ^bb0, ^bb2
    %3 = "arith.cmpi"(%1, %arg1) {predicate = 2 : i64} : (i32, i32) -> i1
    "cf.cond_br"(%3, %2, %2)[^bb2, ^bb3] {operand_segment_sizes = dense<1> : vector<3xi32>} : (i1, i32, i32) -> ()
  ^bb2(%4: i32):  // pred: ^bb1
    %5 = "arith.constant"() {value = 1 : i32} : () -> i32
    %6 = "arith.addi"(%4, %5) : (i32, i32) -> i32
    %7 = "arith.addi"(%1, %5) : (i32, i32) -> i32
    "cf.br"(%6, %7)[^bb1] : (i32, i32) -> ()
  ^bb3(%8: i32):  // pred: ^bb1
    %9 = "arith.addi"(%8, %arg1) : (i32, i32) -> i32
    "func.return"(%9) : (i32) -> ()
  }) {function_type = (i32, i32) -> i32, sym_name = "func_loop"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: i1, %arg1: i32, %arg2: i32, %arg3: i32):
    %0 = "arith.addi"(%arg1, %arg2) : (i32, i32) -> i32
    %1 = "arith.constant"() {value = 1 : i32} : () -> i32
    %2 = "arith.addi"(%1, %arg2) : (i32, i32) -> i32
    %3 = "arith.addi"(%1, %arg3) : (i32, i32) -> i32
    %4 = "arith.muli"(%0, %2) : (i32, i32) -> i32
    %5 = "arith.muli"(%4, %3) : (i32, i32) -> i32
    %6 = "arith.addi"(%5, %1) : (i32, i32) -> i32
    "cf.cond_br"(%arg0)[^bb1, ^bb2] {operand_segment_sizes = dense<[1, 0, 0]> : vector<3xi32>} : (i1) -> ()
  ^bb1:  // pred: ^bb0
    %7 = "arith.constant"() {value = 4 : i32} : () -> i32
    %8 = "arith.muli"(%5, %7) : (i32, i32) -> i32
    "cf.br"(%8)[^bb3] : (i32) -> ()
  ^bb2:  // pred: ^bb0
    %9 = "arith.muli"(%5, %6) : (i32, i32) -> i32
    %10 = "arith.addi"(%5, %arg2) : (i32, i32) -> i32
    "cf.br"(%10)[^bb3] : (i32) -> ()
  ^bb3(%11: i32):  // 2 preds: ^bb1, ^bb2
    %12 = "arith.addi"(%11, %arg2) : (i32, i32) -> i32
    "func.return"(%12) : (i32) -> ()
  }) {function_type = (i1, i32, i32, i32) -> i32, sym_name = "func_ranges"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: index, %arg1: index, %arg2: index, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: memref<i32>):
    %0 = "arith.addi"(%arg3, %arg4) : (i32, i32) -> i32
    %1 = "arith.addi"(%arg4, %arg5) : (i32, i32) -> i32
    "scf.for"(%arg0, %arg1, %arg2) ({
    ^bb0(%arg7: index):
      %2 = "arith.addi"(%0, %arg5) : (i32, i32) -> i32
      %3 = "arith.addi"(%2, %0) : (i32, i32) -> i32
      "memref.store"(%3, %arg6) : (i32, memref<i32>) -> ()
      "scf.yield"() : () -> ()
    }) : (index, index, index) -> ()
    "func.return"(%1) : (i32) -> ()
  }) {function_type = (index, index, index, i32, i32, i32, memref<i32>) -> i32, sym_name = "nested_region"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: index, %arg1: index, %arg2: index, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: memref<i32>):
    %0 = "arith.addi"(%arg3, %arg4) : (i32, i32) -> i32
    %1 = "arith.addi"(%arg4, %arg5) : (i32, i32) -> i32
    "scf.for"(%arg0, %arg1, %arg2) ({
    ^bb0(%arg7: index):
      %2 = "arith.addi"(%0, %arg5) : (i32, i32) -> i32
      "scf.for"(%arg0, %arg1, %arg2) ({
      ^bb0(%arg8: index):
        %3 = "arith.addi"(%2, %0) : (i32, i32) -> i32
        "memref.store"(%3, %arg6) : (i32, memref<i32>) -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "scf.yield"() : () -> ()
    }) : (index, index, index) -> ()
    "func.return"(%1) : (i32) -> ()
  }) {function_type = (index, index, index, i32, i32, i32, memref<i32>) -> i32, sym_name = "nested_region2"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: index, %arg1: index, %arg2: index, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: memref<i32>):
    %0 = "arith.addi"(%arg3, %arg4) : (i32, i32) -> i32
    %1 = "arith.addi"(%arg4, %arg5) : (i32, i32) -> i32
    "scf.for"(%arg0, %arg1, %arg2) ({
    ^bb0(%arg7: index):
      %2 = "arith.addi"(%0, %arg5) : (i32, i32) -> i32
      "memref.store"(%2, %arg6) : (i32, memref<i32>) -> ()
      "scf.yield"() : () -> ()
    }) : (index, index, index) -> ()
    "cf.br"()[^bb1] : () -> ()
  ^bb1:  // pred: ^bb0
    "scf.for"(%arg0, %arg1, %arg2) ({
    ^bb0(%arg7: index):
      %2 = "arith.addi"(%0, %1) : (i32, i32) -> i32
      "memref.store"(%2, %arg6) : (i32, memref<i32>) -> ()
      "scf.yield"() : () -> ()
    }) : (index, index, index) -> ()
    "func.return"(%1) : (i32) -> ()
  }) {function_type = (index, index, index, i32, i32, i32, memref<i32>) -> i32, sym_name = "nested_region3"} : () -> ()
}) : () -> ()

// -----
