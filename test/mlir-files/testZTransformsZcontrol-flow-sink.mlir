"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32, %arg2: i32):
    %0 = "arith.subi"(%arg1, %arg2) : (i32, i32) -> i32
    %1 = "arith.subi"(%arg2, %arg1) : (i32, i32) -> i32
    %2 = "arith.addi"(%arg1, %arg1) : (i32, i32) -> i32
    %3 = "arith.addi"(%arg2, %arg2) : (i32, i32) -> i32
    %4 = "test.region_if"(%arg0) ({
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%0) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      %5 = "arith.addi"(%1, %2) : (i32, i32) -> i32
      "test.region_if_yield"(%5) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      %5 = "arith.addi"(%3, %1) : (i32, i32) -> i32
      "test.region_if_yield"(%5) : (i32) -> ()
    }) : (i32) -> i32
    "func.return"(%4) : (i32) -> ()
  }) {function_type = (i32, i32, i32) -> i32, sym_name = "test_simple_sink"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32, %arg2: i32):
    %0 = "arith.subi"(%arg1, %arg2) : (i32, i32) -> i32
    %1 = "test.region_if"(%arg0) ({
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%arg1) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%0) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%arg2) : (i32) -> ()
    }) : (i32) -> i32
    %2 = "test.region_if"(%arg0) ({
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%1) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%arg1) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%arg2) : (i32) -> ()
    }) : (i32) -> i32
    "func.return"(%2) : (i32) -> ()
  }) {function_type = (i32, i32, i32) -> i32, sym_name = "test_region_sink"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32, %arg2: i32):
    %0 = "arith.addi"(%arg1, %arg2) : (i32, i32) -> i32
    %1 = "arith.subi"(%arg1, %arg2) : (i32, i32) -> i32
    %2 = "arith.subi"(%arg2, %arg1) : (i32, i32) -> i32
    %3 = "arith.muli"(%0, %1) : (i32, i32) -> i32
    %4 = "arith.muli"(%2, %2) : (i32, i32) -> i32
    %5 = "arith.addi"(%3, %4) : (i32, i32) -> i32
    %6 = "test.region_if"(%arg0) ({
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%5) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%arg1) : (i32) -> ()
    }, {
    ^bb0(%arg3: i32):
      "test.region_if_yield"(%arg2) : (i32) -> ()
    }) : (i32) -> i32
    "func.return"(%6) : (i32) -> ()
  }) {function_type = (i32, i32, i32) -> i32, sym_name = "test_subgraph_sink"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32, %arg2: i32):
    %0 = "arith.addi"(%arg1, %arg2) : (i32, i32) -> i32
    %1 = "arith.addi"(%0, %arg2) : (i32, i32) -> i32
    %2 = "arith.addi"(%1, %arg1) : (i32, i32) -> i32
    %3 = "test.any_cond"() ({
      "cf.br"(%2)[^bb1] : (i32) -> ()
    ^bb1(%5: i32):  // pred: ^bb0
      %6 = "arith.addi"(%5, %2) : (i32, i32) -> i32
      "test.yield"(%6) : (i32) -> ()
    }) : () -> i32
    %4 = "arith.addi"(%0, %3) : (i32, i32) -> i32
    "func.return"(%4) : (i32) -> ()
  }) {function_type = (i32, i32, i32) -> i32, sym_name = "test_multiblock_region_sink"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32, %arg1: i32):
    %0 = "arith.addi"(%arg1, %arg1) : (i32, i32) -> i32
    %1 = "test.region_if"(%arg0) ({
    ^bb0(%arg2: i32):
      %2 = "test.region_if"(%arg0) ({
      ^bb0(%arg3: i32):
        "test.region_if_yield"(%0) : (i32) -> ()
      }, {
      ^bb0(%arg3: i32):
        "test.region_if_yield"(%arg1) : (i32) -> ()
      }, {
      ^bb0(%arg3: i32):
        "test.region_if_yield"(%arg1) : (i32) -> ()
      }) : (i32) -> i32
      "test.region_if_yield"(%2) : (i32) -> ()
    }, {
    ^bb0(%arg2: i32):
      "test.region_if_yield"(%arg1) : (i32) -> ()
    }, {
    ^bb0(%arg2: i32):
      "test.region_if_yield"(%arg1) : (i32) -> ()
    }) : (i32) -> i32
    "func.return"(%1) : (i32) -> ()
  }) {function_type = (i32, i32) -> i32, sym_name = "test_nested_region_sink"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32):
    %0 = "arith.addi"(%arg0, %arg0) : (i32, i32) -> i32
    %1 = "test.any_cond"() ({
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // pred: ^bb0
      "test.yield"(%0) : (i32) -> ()
    }) : () -> i32
    "func.return"(%1) : (i32) -> ()
  }) {function_type = (i32) -> i32, sym_name = "test_not_sunk_deeply"} : () -> ()
}) : () -> ()

// -----
