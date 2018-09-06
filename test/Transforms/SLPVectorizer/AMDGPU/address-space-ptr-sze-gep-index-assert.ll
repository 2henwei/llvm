; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -slp-vectorizer -slp-threshold=-18 < %s | FileCheck %s

; Make sure there's no SCEV assert when the indexes are for different
; sized address spaces

target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5"

define void @slp_scev_assert(i32 %idx, i64 %tmp3) #0 {
; CHECK-LABEL: @slp_scev_assert(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = addrspacecast i8 addrspace(5)* undef to i8*
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(5)* undef, i32 [[IDX:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, i8* [[TMP]], i64 [[TMP3:%.*]]
; CHECK-NEXT:    store i8 0, i8 addrspace(5)* [[TMP2]]
; CHECK-NEXT:    store i8 0, i8* [[TMP4]]
; CHECK-NEXT:    ret void
;
bb:
  %tmp = addrspacecast i8 addrspace(5)* undef to i8*
  %tmp2 = getelementptr inbounds i8, i8 addrspace(5)* undef, i32 %idx
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i64 %tmp3
  store i8 0, i8 addrspace(5)* %tmp2
  store i8 0, i8* %tmp4
  ret void
}

define void @multi_as_reduction_different_sized(i32 addrspace(3)* %lds, i32 %idx0, i64 %idx1) #0 {
; CHECK-LABEL: @multi_as_reduction_different_sized(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[FLAT:%.*]] = addrspacecast i32 addrspace(3)* [[LDS:%.*]] to i32*
; CHECK-NEXT:    [[ADD0:%.*]] = add i32 [[IDX0:%.*]], 2
; CHECK-NEXT:    [[ADD1:%.*]] = add i64 [[IDX1:%.*]], 1
; CHECK-NEXT:    [[LDS_1:%.*]] = getelementptr inbounds i32, i32 addrspace(3)* [[LDS]], i32 [[ADD0]]
; CHECK-NEXT:    [[FLAT_1:%.*]] = getelementptr inbounds i32, i32* [[FLAT]], i64 [[ADD1]]
; CHECK-NEXT:    [[LOAD_LDS_0:%.*]] = load i32, i32 addrspace(3)* [[LDS]], align 4
; CHECK-NEXT:    [[LOAD_LDS_1:%.*]] = load i32, i32 addrspace(3)* [[LDS_1]], align 4
; CHECK-NEXT:    [[LOAD_FLAT_0:%.*]] = load i32, i32* [[FLAT]], align 4
; CHECK-NEXT:    [[LOAD_FLAT_1:%.*]] = load i32, i32* [[FLAT_1]], align 4
; CHECK-NEXT:    [[SUB0:%.*]] = sub i32 [[LOAD_FLAT_0]], [[LOAD_LDS_0]]
; CHECK-NEXT:    [[SUB1:%.*]] = sub i32 [[LOAD_FLAT_1]], [[LOAD_LDS_1]]
; CHECK-NEXT:    store i32 [[SUB0]], i32* undef
; CHECK-NEXT:    store i32 [[SUB1]], i32* undef
; CHECK-NEXT:    ret void
;
bb:
  %flat = addrspacecast i32 addrspace(3)* %lds to i32*
  %add0 = add i32 %idx0, 2
  %add1 = add i64 %idx1, 1

  %lds.1 = getelementptr inbounds i32, i32 addrspace(3)* %lds, i32 %add0
  %flat.1 = getelementptr inbounds i32, i32* %flat, i64 %add1

  %load.lds.0 = load i32, i32 addrspace(3)* %lds, align 4
  %load.lds.1 = load i32, i32 addrspace(3)* %lds.1, align 4

  %load.flat.0 = load i32, i32* %flat, align 4
  %load.flat.1 = load i32, i32* %flat.1, align 4

  %sub0 = sub i32 %load.flat.0, %load.lds.0
  %sub1 = sub i32 %load.flat.1, %load.lds.1

  store i32 %sub0, i32* undef
  store i32 %sub1, i32* undef
  ret void
}

; This should vectorize if using GetUnderlyingObject
define void @multi_as_reduction_same_size(i32 addrspace(1)* %global, i64 %idx0, i64 %idx1) #0 {
; CHECK-LABEL: @multi_as_reduction_same_size(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[FLAT:%.*]] = addrspacecast i32 addrspace(1)* [[GLOBAL:%.*]] to i32*
; CHECK-NEXT:    [[ADD0:%.*]] = add i64 [[IDX0:%.*]], 2
; CHECK-NEXT:    [[ADD1:%.*]] = add i64 [[IDX1:%.*]], 1
; CHECK-NEXT:    [[GLOBAL_1:%.*]] = getelementptr inbounds i32, i32 addrspace(1)* [[GLOBAL]], i64 [[ADD0]]
; CHECK-NEXT:    [[FLAT_1:%.*]] = getelementptr inbounds i32, i32* [[FLAT]], i64 [[ADD1]]
; CHECK-NEXT:    [[LOAD_GLOBAL_0:%.*]] = load i32, i32 addrspace(1)* [[GLOBAL]], align 4
; CHECK-NEXT:    [[LOAD_GLOBAL_1:%.*]] = load i32, i32 addrspace(1)* [[GLOBAL_1]], align 4
; CHECK-NEXT:    [[LOAD_FLAT_0:%.*]] = load i32, i32* [[FLAT]], align 4
; CHECK-NEXT:    [[LOAD_FLAT_1:%.*]] = load i32, i32* [[FLAT_1]], align 4
; CHECK-NEXT:    [[SUB0:%.*]] = sub i32 [[LOAD_FLAT_0]], [[LOAD_GLOBAL_0]]
; CHECK-NEXT:    [[SUB1:%.*]] = sub i32 [[LOAD_FLAT_1]], [[LOAD_GLOBAL_1]]
; CHECK-NEXT:    store i32 [[SUB0]], i32* undef
; CHECK-NEXT:    store i32 [[SUB1]], i32* undef
; CHECK-NEXT:    ret void
;
bb:
  %flat = addrspacecast i32 addrspace(1)* %global to i32*
  %add0 = add i64 %idx0, 2
  %add1 = add i64 %idx1, 1

  %global.1 = getelementptr inbounds i32, i32 addrspace(1)* %global, i64 %add0
  %flat.1 = getelementptr inbounds i32, i32* %flat, i64 %add1

  %load.global.0 = load i32, i32 addrspace(1)* %global, align 4
  %load.global.1 = load i32, i32 addrspace(1)* %global.1, align 4

  %load.flat.0 = load i32, i32* %flat, align 4
  %load.flat.1 = load i32, i32* %flat.1, align 4

  %sub0 = sub i32 %load.flat.0, %load.global.0
  %sub1 = sub i32 %load.flat.1, %load.global.1

  store i32 %sub0, i32* undef
  store i32 %sub1, i32* undef
  ret void
}

; This should vectorize if using GetUnderlyingObject
; The add is done in the same width, even though the address space size is smaller
define void @multi_as_reduction_different_sized_noncanon(i32 addrspace(3)* %lds, i64 %idx0, i64 %idx1) #0 {
; CHECK-LABEL: @multi_as_reduction_different_sized_noncanon(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[FLAT:%.*]] = addrspacecast i32 addrspace(3)* [[LDS:%.*]] to i32*
; CHECK-NEXT:    [[ADD0:%.*]] = add i64 [[IDX0:%.*]], 2
; CHECK-NEXT:    [[ADD1:%.*]] = add i64 [[IDX1:%.*]], 1
; CHECK-NEXT:    [[LDS_1:%.*]] = getelementptr inbounds i32, i32 addrspace(3)* [[LDS]], i64 [[ADD0]]
; CHECK-NEXT:    [[FLAT_1:%.*]] = getelementptr inbounds i32, i32* [[FLAT]], i64 [[ADD1]]
; CHECK-NEXT:    [[LOAD_LDS_0:%.*]] = load i32, i32 addrspace(3)* [[LDS]], align 4
; CHECK-NEXT:    [[LOAD_LDS_1:%.*]] = load i32, i32 addrspace(3)* [[LDS_1]], align 4
; CHECK-NEXT:    [[LOAD_FLAT_0:%.*]] = load i32, i32* [[FLAT]], align 4
; CHECK-NEXT:    [[LOAD_FLAT_1:%.*]] = load i32, i32* [[FLAT_1]], align 4
; CHECK-NEXT:    [[SUB0:%.*]] = sub i32 [[LOAD_FLAT_0]], [[LOAD_LDS_0]]
; CHECK-NEXT:    [[SUB1:%.*]] = sub i32 [[LOAD_FLAT_1]], [[LOAD_LDS_1]]
; CHECK-NEXT:    store i32 [[SUB0]], i32* undef
; CHECK-NEXT:    store i32 [[SUB1]], i32* undef
; CHECK-NEXT:    ret void
;
bb:
  %flat = addrspacecast i32 addrspace(3)* %lds to i32*
  %add0 = add i64 %idx0, 2
  %add1 = add i64 %idx1, 1

  %lds.1 = getelementptr inbounds i32, i32 addrspace(3)* %lds, i64 %add0
  %flat.1 = getelementptr inbounds i32, i32* %flat, i64 %add1

  %load.lds.0 = load i32, i32 addrspace(3)* %lds, align 4
  %load.lds.1 = load i32, i32 addrspace(3)* %lds.1, align 4

  %load.flat.0 = load i32, i32* %flat, align 4
  %load.flat.1 = load i32, i32* %flat.1, align 4

  %sub0 = sub i32 %load.flat.0, %load.lds.0
  %sub1 = sub i32 %load.flat.1, %load.lds.1

  store i32 %sub0, i32* undef
  store i32 %sub1, i32* undef
  ret void
}
