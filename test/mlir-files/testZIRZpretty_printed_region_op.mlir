"builtin.module"() ({
^bb0:
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: f32, %arg1: f32):
    %0 = "test.pretty_printed_region"(%arg1, %arg0) ({
    ^bb0(%arg2: f32, %arg3: f32):
      %1 = "special.op"(%arg2, %arg3) : (f32, f32) -> f32
      "test.return"(%1) : (f32) -> ()
    }) : (f32, f32) -> f32
    "func.return"(%0) : (f32) -> ()
  }) {function_type = (f32, f32) -> f32, sym_name = "pretty_printed_region_op"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: f32, %arg1: f32):
    %0 = "test.pretty_printed_region"(%arg1, %arg0) ({
    ^bb0(%arg2: f32, %arg3: f32):
      %1 = "non.special.op"(%arg2, %arg3) : (f32, f32) -> f32
      "test.return"(%1) : (f32) -> ()
    }) : (f32, f32) -> f32
    "func.return"(%0) : (f32) -> ()
  }) {function_type = (f32, f32) -> f32, sym_name = "pretty_printed_region_op"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: f32, %arg1: f32):
    %0 = "test.pretty_printed_region"(%arg1, %arg0) ({
    ^bb0(%arg2: f32, %arg3: f32):
      %1 = "special.op"(%arg2, %arg3) : (f32, f32) -> f32
      "test.return"(%1) : (f32) -> ()
    }) : (f32, f32) -> f32
    "func.return"(%0) : (f32) -> ()
  }) {function_type = (f32, f32) -> f32, sym_name = "pretty_printed_region_op_deferred_loc"} : () -> ()
}) : () -> ()

// -----
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: i1):
    "test.block_names"() ({
      "cf.br"()[^bb1] : () -> ()
    ^bb1:  // pred: ^bb0
      "cf.br"()[^bb2] : () -> ()
    ^bb2:  // pred: ^bb1
      "test.return"() : () -> ()
    }) : () -> ()
    "func.return"() : () -> ()
  }) {function_type = (i1) -> (), sym_name = "block_names"} : () -> ()
}) : () -> ()

// -----
