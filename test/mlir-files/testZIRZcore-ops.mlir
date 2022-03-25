#map0 = affine_map<(d0) -> (d0 + 1)>
#map1 = affine_map<()[s0] -> (s0 + 1)>
#map2 = affine_map<(d0, d1, d2) -> (d0 * 64 + d1 * 4 + d2)>
#map3 = affine_map<(d0, d1, d2)[s0, s1, s2, s3] -> (d0 * s1 + s0 + d1 * s2 + d2 * s3)>
#map4 = affine_map<(d0) -> (d0)>
"builtin.module"() ({
  "func.func"() ({
  ^bb0(%arg0: f32):
    %0 = "getTensor"() : () -> tensor<4x4x?xf32>
    %1 = "arith.constant"() {value = 2 : index} : () -> index
    %2 = "tensor.dim"(%0, %1) : (tensor<4x4x?xf32>, index) -> index
    %3 = "arith.addf"(%arg0, %arg0) : (f32, f32) -> f32
    "func.return"() : () -> ()
  }) {function_type = (f32) -> (), sym_name = "func_with_ops"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: tensor<4x4x?xf32>, %arg1: f32, %arg2: i32, %arg3: index, %arg4: i64, %arg5: f16):
    %0 = "arith.constant"() {value = 2 : index} : () -> index
    %1 = "tensor.dim"(%arg0, %0) : (tensor<4x4x?xf32>, index) -> index
    %2 = "func.constant"() {value = @func_with_ops} : () -> ((f32) -> ())
    %3 = "func.constant"() {value = @affine_apply} : () -> (() -> ())
    %4 = "arith.addi"(%arg2, %arg2) : (i32, i32) -> i32
    %5 = "arith.addi"(%4, %arg2) : (i32, i32) -> i32
    %6 = "arith.addi"(%4, %5) : (i32, i32) -> i32
    %7 = "arith.addf"(%arg1, %arg1) : (f32, f32) -> f32
    %8 = "arith.addf"(%arg1, %7) : (f32, f32) -> f32
    %9 = "arith.constant"() {value = true} : () -> i1
    %10 = "arith.constant"() {value = dense<0> : tensor<42xi32>} : () -> tensor<42xi32>
    %11 = "arith.constant"() {value = dense<0> : vector<42xi32>} : () -> vector<42xi32>
    %12 = "arith.constant"() {value = dense<true> : tensor<42xi1>} : () -> tensor<42xi1>
    %13 = "arith.constant"() {value = dense<true> : vector<42xi1>} : () -> vector<42xi1>
    %14 = "arith.select"(%9, %arg3, %arg3) : (i1, index, index) -> index
    %15 = "arith.select"(%12, %10, %10) : (tensor<42xi1>, tensor<42xi32>, tensor<42xi32>) -> tensor<42xi32>
    %16 = "arith.select"(%13, %11, %11) : (vector<42xi1>, vector<42xi32>, vector<42xi32>) -> vector<42xi32>
    %17 = "arith.select"(%9, %arg3, %arg3) : (i1, index, index) -> index
    %18 = "arith.select"(%9, %10, %10) : (i1, tensor<42xi32>, tensor<42xi32>) -> tensor<42xi32>
    %19 = "arith.constant"() {value = dense<0.000000e+00> : vector<4xf32>} : () -> vector<4xf32>
    %20 = "arith.constant"() {value = dense<0.000000e+00> : tensor<42xf32>} : () -> tensor<42xf32>
    %21 = "arith.constant"() {value = dense<0.000000e+00> : vector<4xf32>} : () -> vector<4xf32>
    %22 = "arith.cmpf"(%7, %8) {predicate = 2 : i64} : (f32, f32) -> i1
    %23 = "arith.cmpf"(%7, %8) {predicate = 1 : i64} : (f32, f32) -> i1
    %24 = "arith.cmpf"(%21, %21) {predicate = 4 : i64} : (vector<4xf32>, vector<4xf32>) -> vector<4xi1>
    %25 = "arith.cmpf"(%21, %21) {predicate = 1 : i64} : (vector<4xf32>, vector<4xf32>) -> vector<4xi1>
    %26 = "arith.cmpf"(%20, %20) {predicate = 1 : i64} : (tensor<42xf32>, tensor<42xf32>) -> tensor<42xi1>
    %27 = "arith.cmpf"(%21, %21) {predicate = 1 : i64} : (vector<4xf32>, vector<4xf32>) -> vector<4xi1>
    %28 = "arith.constant"() {value = true} : () -> i1
    %29 = "arith.constant"() {value = false} : () -> i1
    %30 = "math.abs"(%arg1) : (f32) -> f32
    %31 = "math.abs"(%arg1) : (f32) -> f32
    %32 = "math.abs"(%21) : (vector<4xf32>) -> vector<4xf32>
    %33 = "math.abs"(%arg0) : (tensor<4x4x?xf32>) -> tensor<4x4x?xf32>
    %34 = "math.ceil"(%arg1) : (f32) -> f32
    %35 = "math.ceil"(%arg1) : (f32) -> f32
    %36 = "math.ceil"(%21) : (vector<4xf32>) -> vector<4xf32>
    %37 = "math.ceil"(%arg0) : (tensor<4x4x?xf32>) -> tensor<4x4x?xf32>
    %38 = "math.copysign"(%arg1, %arg1) : (f32, f32) -> f32
    %39 = "math.copysign"(%arg1, %arg1) : (f32, f32) -> f32
    %40 = "math.copysign"(%21, %21) : (vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    %41 = "math.copysign"(%arg0, %arg0) : (tensor<4x4x?xf32>, tensor<4x4x?xf32>) -> tensor<4x4x?xf32>
    %42 = "math.rsqrt"(%arg1) : (f32) -> f32
    %43 = "math.floor"(%arg1) : (f32) -> f32
    %44 = "math.floor"(%arg1) : (f32) -> f32
    %45 = "math.floor"(%21) : (vector<4xf32>) -> vector<4xf32>
    %46 = "math.floor"(%arg0) : (tensor<4x4x?xf32>) -> tensor<4x4x?xf32>
    "func.return"() : () -> ()
  }) {function_type = (tensor<4x4x?xf32>, f32, i32, index, i64, f16) -> (), sym_name = "standard_instrs"} : () -> ()
  "func.func"() ({
    %0 = "arith.constant"() {value = 0 : index} : () -> index
    %1 = "arith.constant"() {value = 1 : index} : () -> index
    %2 = "affine.apply"(%0) {map = #map0} : (index) -> index
    %3 = "affine.apply"(%0) {map = #map1} : (index) -> index
    "func.return"() : () -> ()
  }) {function_type = () -> (), sym_name = "affine_apply"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: memref<4x4xi32>, %arg1: index):
    %0 = "memref.load"(%arg0, %arg1, %arg1) : (memref<4x4xi32>, index, index) -> i32
    %1 = "memref.load"(%arg0, %arg1, %arg1) : (memref<4x4xi32>, index, index) -> i32
    "memref.prefetch"(%arg0, %arg1, %arg1) {isDataCache = true, isWrite = true, localityHint = 1 : i32} : (memref<4x4xi32>, index, index) -> ()
    "memref.prefetch"(%arg0, %arg1, %arg1) {isDataCache = false, isWrite = false, localityHint = 3 : i32} : (memref<4x4xi32>, index, index) -> ()
    "func.return"() : () -> ()
  }) {function_type = (memref<4x4xi32>, index) -> (), sym_name = "load_store_prefetch"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: memref<i32>, %arg1: memref<i32>, %arg2: memref<i32>):
    %0 = "memref.load"(%arg0) : (memref<i32>) -> i32
    "memref.store"(%0, %arg1) : (i32, memref<i32>) -> ()
    "func.return"() : () -> ()
  }) {function_type = (memref<i32>, memref<i32>, memref<i32>) -> (), sym_name = "zero_dim_no_idx"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32):
    "func.return"(%arg0) : (i32) -> ()
  }) {function_type = (i32) -> i32, sym_name = "return_op"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: i32):
    %0 = "func.call"(%arg0) {callee = @return_op} : (i32) -> i32
    %1 = "func.call"(%0) {callee = @return_op} : (i32) -> i32
    %2 = "func.call"(%0) {callee = @return_op} : (i32) -> i32
    %3 = "func.constant"() {value = @affine_apply} : () -> (() -> ())
    "func.call_indirect"(%3) : (() -> ()) -> ()
    %4 = "func.constant"() {value = @return_op} : () -> ((i32) -> i32)
    %5 = "func.call_indirect"(%4, %arg0) : ((i32) -> i32, i32) -> i32
    %6 = "func.call_indirect"(%4, %arg0) : ((i32) -> i32, i32) -> i32
    "func.return"() : () -> ()
  }) {function_type = (i32) -> (), sym_name = "calls"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: memref<4xf32>, %arg1: memref<?xf32>, %arg2: memref<64x16x4xf32, #map2>):
    %0 = "memref.cast"(%arg0) : (memref<4xf32>) -> memref<?xf32>
    %1 = "memref.cast"(%arg1) : (memref<?xf32>) -> memref<4xf32>
    %2 = "memref.cast"(%arg2) : (memref<64x16x4xf32, #map2>) -> memref<64x16x4xf32, #map3>
    %3 = "memref.cast"(%2) : (memref<64x16x4xf32, #map3>) -> memref<64x16x4xf32, #map2>
    %4 = "memref.cast"(%1) : (memref<4xf32>) -> memref<*xf32>
    %5 = "memref.cast"(%4) : (memref<*xf32>) -> memref<4xf32>
    "func.return"() : () -> ()
  }) {function_type = (memref<4xf32>, memref<?xf32>, memref<64x16x4xf32, #map2>) -> (), sym_name = "memref_cast"} : () -> ()
  "func.func"() ({
  }) {function_type = (memref<*xf32, 4>) -> (), sym_name = "unranked_memref_roundtrip", sym_visibility = "private"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: index, %arg1: index, %arg2: index):
    %0 = "memref.alloc"() {operand_segment_sizes = dense<0> : vector<2xi32>} : () -> memref<2048xi8>
    %1 = "memref.view"(%0, %arg2, %arg0, %arg1) : (memref<2048xi8>, index, index, index) -> memref<?x?xf32>
    %2 = "memref.view"(%0, %arg2, %arg1) : (memref<2048xi8>, index, index) -> memref<4x?xf32>
    %3 = "arith.constant"() {value = 0 : index} : () -> index
    %4 = "memref.view"(%0, %3) : (memref<2048xi8>, index) -> memref<64x4xf32>
    "func.return"() : () -> ()
  }) {function_type = (index, index, index) -> (), sym_name = "memref_view"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: tensor<4x4x?xf32>):
    %0 = "arith.constant"() {value = 2 : index} : () -> index
    %1 = "tensor.dim"(%arg0, %0) : (tensor<4x4x?xf32>, index) -> index
    %2 = "affine.apply"(%1) {map = #map4} : (index) -> index
    "func.return"() : () -> ()
  }) {function_type = (tensor<4x4x?xf32>) -> (), sym_name = "test_dimop"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: memref<4x4xi32>, %arg1: tensor<4x4xi32>):
    "memref.tensor_store"(%arg1, %arg0) : (tensor<4x4xi32>, memref<4x4xi32>) -> ()
    "func.return"() : () -> ()
  }) {function_type = (memref<4x4xi32>, tensor<4x4xi32>) -> (), sym_name = "tensor_load_store"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: memref<*xi32>, %arg1: tensor<*xi32>):
    "memref.tensor_store"(%arg1, %arg0) : (tensor<*xi32>, memref<*xi32>) -> ()
    "func.return"() : () -> ()
  }) {function_type = (memref<*xi32>, tensor<*xi32>) -> (), sym_name = "unranked_tensor_load_store"} : () -> ()
  "func.func"() ({
  ^bb0(%arg0: memref<4x4xf16>):
    "memref.assume_alignment"(%arg0) {alignment = 16 : i32} : (memref<4x4xf16>) -> ()
    "func.return"() : () -> ()
  }) {function_type = (memref<4x4xf16>) -> (), sym_name = "assume_alignment"} : () -> ()
}) : () -> ()

// -----
