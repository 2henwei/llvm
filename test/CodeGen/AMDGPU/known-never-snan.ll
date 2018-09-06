; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=fiji -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

; Mostly overlaps with fmed3.ll to stress specific cases of
; isKnownNeverSNaN.

define float @v_test_known_not_snan_fabs_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_fabs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, |v0|, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %known.not.snan = call float @llvm.fabs.f32(float %a.nnan.add)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fneg_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_fneg_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e64 v0, -v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %known.not.snan = fsub float -0.0, %a.nnan.add
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fpext_input_fmed3_r_i_i_f32(half %a) #0 {
; GCN-LABEL: v_test_known_not_snan_fpext_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f16_e32 v0, 1.0, v0
; GCN-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fadd nnan half %a, 1.0
  %known.not.snan = fpext half %a.nnan.add to float
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fptrunc_input_fmed3_r_i_i_f32(double %a) #0 {
; GCN-LABEL: v_test_known_not_snan_fptrunc_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f64 v[0:1], v[0:1], 1.0
; GCN-NEXT:    v_cvt_f32_f64_e32 v0, v[0:1]
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fadd nnan double %a, 1.0
  %known.not.snan = fptrunc double %a.nnan.add to float
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_copysign_input_fmed3_r_i_i_f32(float %a, float %sign) #0 {
; GCN-LABEL: v_test_known_not_snan_copysign_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    s_brev_b32 s6, -2
; GCN-NEXT:    v_bfi_b32 v0, s6, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %known.not.snan = call float @llvm.copysign.f32(float %a.nnan.add, float %sign)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

; Canonicalize always quiets, so nothing is necessary.
define float @v_test_known_canonicalize_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_canonicalize_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.canonicalize.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_minnum_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_test_known_not_snan_minnum_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    v_min_f32_e32 v0, v0, v1
; GCN-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %b.nnan.add = fadd nnan float %b, 1.0
  %known.not.snan = call float @llvm.minnum.f32(float %a.nnan.add, float %b.nnan.add)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_minnum_possible_nan_lhs_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_minnum_possible_nan_lhs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    v_min_f32_e32 v0, v0, v1
; GCN-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %b.nnan.add = fadd nnan float %b, 1.0
  %known.not.snan = call float @llvm.minnum.f32(float %a, float %b.nnan.add)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_minnum_possible_nan_rhs_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_minnum_possible_nan_rhs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_min_f32_e32 v0, v0, v1
; GCN-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %known.not.snan = call float @llvm.minnum.f32(float %a.nnan.add, float %b)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_maxnum_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_test_known_not_snan_maxnum_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    v_max3_f32 v0, v0, v1, 2.0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %b.nnan.add = fadd nnan float %b, 1.0
  %known.not.snan = call float @llvm.maxnum.f32(float %a.nnan.add, float %b.nnan.add)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_maxnum_possible_nan_lhs_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_maxnum_possible_nan_lhs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    v_max3_f32 v0, v0, v1, 2.0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %b.nnan.add = fadd nnan float %b, 1.0
  %known.not.snan = call float @llvm.maxnum.f32(float %a, float %b.nnan.add)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_maxnum_possible_nan_rhs_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_maxnum_possible_nan_rhs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_max3_f32 v0, v0, v1, 2.0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %known.not.snan = call float @llvm.maxnum.f32(float %a.nnan.add, float %b)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_select_input_fmed3_r_i_i_f32(float %a, float %b, i32 %c) #0 {
; GCN-LABEL: v_test_known_not_snan_select_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; GCN-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %b.nnan.add = fadd nnan float %b, 1.0
  %cmp = icmp eq i32 %c, 0
  %known.not.snan = select i1 %cmp, float %a.nnan.add, float %b.nnan.add
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_select_possible_nan_lhs_input_fmed3_r_i_i_f32(float %a, float %b, i32 %c) #0 {
; GCN-LABEL: v_select_possible_nan_lhs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; GCN-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc
; GCN-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %b.nnan.add = fadd nnan float %b, 1.0
  %cmp = icmp eq i32 %c, 0
  %known.not.snan = select i1 %cmp, float %a, float %b.nnan.add
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_select_possible_nan_rhs_input_fmed3_r_i_i_f32(float %a, float %b, i32 %c) #0 {
; GCN-LABEL: v_select_possible_nan_rhs_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; GCN-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc
; GCN-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %a.nnan.add = fdiv nnan float 1.0, %a
  %cmp = icmp eq i32 %c, 0
  %known.not.snan = select i1 %cmp, float %a.nnan.add, float %b
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fadd_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_test_known_not_snan_fadd_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v0, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = fadd float %a, %b
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fsub_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_test_known_not_snan_fsub_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = fsub float %a, %b
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fmul_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_test_known_not_snan_fmul_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f32_e32 v0, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = fmul float %a, %b
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_uint_to_fp_input_fmed3_r_i_i_f32(i32 %a) #0 {
; GCN-LABEL: v_test_known_not_snan_uint_to_fp_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = uitofp i32 %a to float
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_sint_to_fp_input_fmed3_r_i_i_f32(i32 %a) #0 {
; GCN-LABEL: v_test_known_not_snan_sint_to_fp_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_cvt_f32_i32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = sitofp i32 %a to float
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fma_input_fmed3_r_i_i_f32(float %a, float %b, float %c) #0 {
; GCN-LABEL: v_test_known_not_snan_fma_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fma_f32 v0, v0, v1, v2
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.fma.f32(float %a, float %b, float %c)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fmad_input_fmed3_r_i_i_f32(float %a, float %b, float %c) #0 {
; GCN-LABEL: v_test_known_not_snan_fmad_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mac_f32_e32 v2, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v2, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.fmuladd.f32(float %a, float %b, float %c)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}


define float @v_test_known_not_snan_sin_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_sin_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f32_e32 v0, 0.15915494, v0
; GCN-NEXT:    v_fract_f32_e32 v0, v0
; GCN-NEXT:    v_sin_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.sin.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_cos_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_cos_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f32_e32 v0, 0.15915494, v0
; GCN-NEXT:    v_fract_f32_e32 v0, v0
; GCN-NEXT:    v_cos_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.cos.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_exp2_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_exp2_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_exp_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.exp2.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_trunc_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_trunc_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_trunc_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.trunc.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_floor_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_floor_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_floor_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.floor.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_ceil_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_ceil_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_floor_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.floor.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_round_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_round_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_brev_b32 s6, -2
; GCN-NEXT:    v_trunc_f32_e32 v2, v0
; GCN-NEXT:    v_bfi_b32 v1, s6, 1.0, v0
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v2
; GCN-NEXT:    v_cmp_ge_f32_e64 vcc, |v0|, 0.5
; GCN-NEXT:    v_cndmask_b32_e32 v0, 0, v1, vcc
; GCN-NEXT:    v_add_f32_e32 v0, v2, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.round.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_rint_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_rint_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rndne_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.rint.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_nearbyint_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_nearbyint_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rndne_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.nearbyint.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fmul_legacy_input_fmed3_r_i_i_f32(float %a, float %b) #0 {
; GCN-LABEL: v_test_known_not_snan_fmul_legacy_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.fmul.legacy(float %a, float %b)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_ldexp_input_fmed3_r_i_i_f32(float %a, i32 %b) #0 {
; GCN-LABEL: v_test_known_not_snan_ldexp_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_ldexp_f32 v0, v0, v1
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.ldexp.f32(float %a, i32 %b)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fmed3_input_fmed3_r_i_i_f32(float %a, float %b, float %c) #0 {
; GCN-LABEL: v_test_known_not_snan_fmed3_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_med3_f32 v0, v0, v1, v2
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.fmed3.f32(float %a, float %b, float %c)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fmin3_input_fmed3_r_i_i_f32(float %a, float %b, float %c) #0 {
; GCN-LABEL: v_test_known_not_snan_fmin3_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_min3_f32 v0, v0, v1, v2
; GCN-NEXT:    v_max_f32_e32 v0, 2.0, v0
; GCN-NEXT:    v_min_f32_e32 v0, 4.0, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %min0 = call float @llvm.minnum.f32(float %a, float %b)
  %known.not.snan = call float @llvm.minnum.f32(float %min0, float %c)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_cvt_ubyte0_input_fmed3_r_i_i_f32(i8 %char) #0 {
; GCN-LABEL: v_test_known_not_snan_cvt_ubyte0_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %cvt = uitofp i8 %char to float
  %max = call float @llvm.maxnum.f32(float %cvt, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_not_known_frexp_mant_input_fmed3_r_i_i_f32(float %arg) #0 {
; GCN-LABEL: v_test_not_known_frexp_mant_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_frexp_mant_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.frexp.mant.f32(float %arg)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_frexp_mant_input_fmed3_r_i_i_f32(float %arg) #0 {
; GCN-LABEL: v_test_known_not_frexp_mant_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v0, 1.0, v0
; GCN-NEXT:    v_frexp_mant_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %add = fadd float %arg, 1.0
  %known.not.snan = call float @llvm.amdgcn.frexp.mant.f32(float %add)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_rcp_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_rcp_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rcp_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.rcp.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}
define float @v_test_known_not_snan_rsq_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_rsq_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_rsq_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.rsq.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_fract_input_fmed3_r_i_i_f32(float %a) #0 {
; GCN-LABEL: v_test_known_not_snan_fract_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_fract_f32_e32 v0, v0
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.fract.f32(float %a)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

define float @v_test_known_not_snan_cubeid_input_fmed3_r_i_i_f32(float %a, float %b, float %c) #0 {
; GCN-LABEL: v_test_known_not_snan_cubeid_input_fmed3_r_i_i_f32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_cubeid_f32 v0, v0, v1, v2
; GCN-NEXT:    v_med3_f32 v0, v0, 2.0, 4.0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %known.not.snan = call float @llvm.amdgcn.cubeid(float %a, float %b, float %c)
  %max = call float @llvm.maxnum.f32(float %known.not.snan, float 2.0)
  %med = call float @llvm.minnum.f32(float %max, float 4.0)
  ret float %med
}

declare float @llvm.fabs.f32(float) #1
declare float @llvm.sin.f32(float) #1
declare float @llvm.cos.f32(float) #1
declare float @llvm.exp2.f32(float) #1
declare float @llvm.trunc.f32(float) #1
declare float @llvm.floor.f32(float) #1
declare float @llvm.ceil.f32(float) #1
declare float @llvm.round.f32(float) #1
declare float @llvm.rint.f32(float) #1
declare float @llvm.nearbyint.f32(float) #1
declare float @llvm.canonicalize.f32(float) #1
declare float @llvm.minnum.f32(float, float) #1
declare float @llvm.maxnum.f32(float, float) #1
declare float @llvm.copysign.f32(float, float) #1
declare float @llvm.fma.f32(float, float, float) #1
declare float @llvm.fmuladd.f32(float, float, float) #1
declare float @llvm.amdgcn.ldexp.f32(float, i32) #1
declare float @llvm.amdgcn.fmul.legacy(float, float) #1
declare float @llvm.amdgcn.fmed3.f32(float, float, float) #1
declare float @llvm.amdgcn.frexp.mant.f32(float) #1
declare float @llvm.amdgcn.rcp.f32(float) #1
declare float @llvm.amdgcn.rsq.f32(float) #1
declare float @llvm.amdgcn.fract.f32(float) #1
declare float @llvm.amdgcn.cubeid(float, float, float) #0

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone speculatable }
