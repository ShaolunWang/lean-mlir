#map0 = affine_map<() -> (0)>
#map1 = affine_map<() -> (8)>
"builtin.module"() ({
  "func.func"() ({
    %0 = "test.foo"() : () -> i32
    %1 = "arith.constant"() {value = 4 : index} : () -> index
    "affine.for"() ({
    ^bb0(%arg0: index):
      "affine.yield"() : () -> ()
    }) {lower_bound = #map0, step = 1 : index, upper_bound = #map1} : () -> ()
    "affine.for"() ({
    ^bb0(%arg0: index):
      "affine.yield"() : () -> ()
    }) {lower_bound = #map0, step = 1 : index, upper_bound = #map1} : () -> ()
    "func.return"(%0) : (i32) -> ()
  }) {function_type = () -> i32, sym_name = "inline_notation"} : () -> ()
}) : () -> ()

// -----
