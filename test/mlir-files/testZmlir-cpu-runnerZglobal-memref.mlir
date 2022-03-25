"builtin.module"() ({
  "func.func"() ({
  }) {function_type = (memref<*xf32>) -> (), llvm.emit_c_interface, sym_name = "print_memref_f32", sym_visibility = "private"} : () -> ()
  "func.func"() ({
  }) {function_type = (memref<*xi32>) -> (), llvm.emit_c_interface, sym_name = "print_memref_i32", sym_visibility = "private"} : () -> ()
  "func.func"() ({
  }) {function_type = () -> (), sym_name = "printNewline", sym_visibility = "private"} : () -> ()
  "memref.global"() {initial_value = dense<[0.000000e+00, 1.000000e+00, 2.000000e+00, 3.000000e+00]> : tensor<4xf32>, sym_name = "gv0", sym_visibility = "private", type = memref<4xf32>} : () -> ()
  "func.func"() ({
    %0 = "memref.get_global"() {name = @gv0} : () -> memref<4xf32>
    %1 = "memref.cast"(%0) : (memref<4xf32>) -> memref<*xf32>
    "func.call"(%1) {callee = @print_memref_f32} : (memref<*xf32>) -> ()
    "func.call"() {callee = @printNewline} : () -> ()
    %2 = "arith.constant"() {value = 0 : index} : () -> index
    %3 = "arith.constant"() {value = 2 : index} : () -> index
    %4 = "arith.constant"() {value = 4.000000e+00 : f32} : () -> f32
    %5 = "arith.constant"() {value = 5.000000e+00 : f32} : () -> f32
    "memref.store"(%4, %0, %2) : (f32, memref<4xf32>, index) -> ()
    "memref.store"(%5, %0, %3) : (f32, memref<4xf32>, index) -> ()
    "func.call"(%1) {callee = @print_memref_f32} : (memref<*xf32>) -> ()
    "func.call"() {callee = @printNewline} : () -> ()
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "test1DMemref"} : () -> ()
  "memref.global"() {constant, initial_value = dense<[[0, 1], [2, 3], [4, 5]]> : tensor<3x2xi32>, sym_name = "gv1", type = memref<3x2xi32>} : () -> ()
  "func.func"() ({
    %0 = "memref.get_global"() {name = @gv1} : () -> memref<3x2xi32>
    %1 = "memref.cast"(%0) : (memref<3x2xi32>) -> memref<*xi32>
    "func.call"(%1) {callee = @print_memref_i32} : (memref<*xi32>) -> ()
    "func.call"() {callee = @printNewline} : () -> ()
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "testConstantMemref"} : () -> ()
  "memref.global"() {initial_value = dense<[[0.000000e+00, 1.000000e+00], [2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00], [6.000000e+00, 7.000000e+00]]> : tensor<4x2xf32>, sym_name = "gv2", sym_visibility = "private", type = memref<4x2xf32>} : () -> ()
  "func.func"() ({
    %0 = "memref.get_global"() {name = @gv2} : () -> memref<4x2xf32>
    %1 = "memref.cast"(%0) : (memref<4x2xf32>) -> memref<*xf32>
    "func.call"(%1) {callee = @print_memref_f32} : (memref<*xf32>) -> ()
    "func.call"() {callee = @printNewline} : () -> ()
    %2 = "arith.constant"() {value = 0 : index} : () -> index
    %3 = "arith.constant"() {value = 1 : index} : () -> index
    %4 = "arith.constant"() {value = 1.000000e+01 : f32} : () -> f32
    "memref.store"(%4, %0, %2, %3) : (f32, memref<4x2xf32>, index, index) -> ()
    "func.call"(%1) {callee = @print_memref_f32} : (memref<*xf32>) -> ()
    "func.call"() {callee = @printNewline} : () -> ()
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "test2DMemref"} : () -> ()
  "memref.global"() {initial_value = dense<11> : tensor<i32>, sym_name = "gv3", type = memref<i32>} : () -> ()
  "func.func"() ({
    %0 = "memref.get_global"() {name = @gv3} : () -> memref<i32>
    %1 = "memref.cast"(%0) : (memref<i32>) -> memref<*xi32>
    "func.call"(%1) {callee = @print_memref_i32} : (memref<*xi32>) -> ()
    "func.call"() {callee = @printNewline} : () -> ()
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "testScalarMemref"} : () -> ()
  "func.func"() ({
    "func.call"() {callee = @test1DMemref} : () -> ()
    "func.call"() {callee = @testConstantMemref} : () -> ()
    "func.call"() {callee = @test2DMemref} : () -> ()
    "func.call"() {callee = @testScalarMemref} : () -> ()
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "main"} : () -> ()
}) : () -> ()

// -----
