"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: index, %arg1: index, %arg2: index, %arg3: index, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: memref<i32>):
    %0 = "arith.addi"(%arg4, %arg5) {__test_sort_original_idx__ = 0 : i64} : (i32, i32) -> i32
    %1 = "arith.addi"(%arg0, %arg1) {__test_sort_original_idx__ = 3 : i64} : (index, index) -> index
    "scf.for"(%1, %arg2, %arg3) ({
    ^bb0(%arg8: index):
      %2 = "arith.addi"(%0, %arg5) : (i32, i32) -> i32
      %3 = "arith.subi"(%2, %arg6) {__test_sort_original_idx__ = 1 : i64} : (i32, i32) -> i32
      "memref.store"(%3, %arg7) : (i32, memref<i32>) -> ()
      "scf.yield"() : () -> ()
    }) {__test_sort_original_idx__ = 2 : i64} : (index, index, index) -> ()
    "func.return"() : () -> ()
  }) {function_type = (index, index, index, index, i32, i32, i32, memref<i32>) -> (), sym_name = "region"} : () -> ()
}) : () -> ()

// -----
