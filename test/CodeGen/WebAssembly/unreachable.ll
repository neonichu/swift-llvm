; RUN: llc < %s -asm-verbose=false | FileCheck %s
; RUN: llc < %s -asm-verbose=false -fast-isel | FileCheck %s

; Test that LLVM unreachable instruction and trap intrinsic are lowered to
; wasm unreachable

target datalayout = "e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

declare void @llvm.trap()
declare void @llvm.debugtrap()
declare void @abort()

; CHECK-LABEL: f1:
; CHECK: call $abort
; CHECK: unreachable
define i32 @f1() {
  call void @abort()
  unreachable
}

; CHECK-LABEL: f2:
; CHECK: unreachable
define void @f2() {
  call void @llvm.trap()
  ret void
}

; CHECK-LABEL: f3:
; CHECK: unreachable
define void @f3() {
  call void @llvm.debugtrap()
  ret void
}
