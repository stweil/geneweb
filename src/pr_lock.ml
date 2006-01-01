(* camlp4r q_MLast.cmo pa_extfun.cmo *)
(* $Id: pr_lock.ml,v 5.1 2006-01-01 05:35:08 ddr Exp $ *)
(* Copyright (c) 1998-2006 INRIA *)

open Pcaml;
open Spretty;

value loc = (0, 0);

value expr e dg k = pr_expr.pr_fun "top" e dg k;
value patt e dg k = pr_patt.pr_fun "top" e dg k;

let lev = find_pr_level "top" pr_expr.pr_levels in
lev.pr_rules :=
  extfun lev.pr_rules with
  [ <:expr< match Lock.control $e1$ $e2$ (fun () -> $e3$) with
            [ Some x -> x
            | None -> $e4$ ] >> ->
      fun curr next _ k ->
        [: `Vbox
              [: `HVbox [: :];
                 `HVbox [: `S LR "lock"; `expr e1 "" [: `S LR "with" :] :];
                 `HVbox
                    [: `S LR "[";
                       `HVbox
                          [: `HVbox [: `S LR "Accept"; `S LR "->" :];
                             `expr e3 "" [: :] :] :];
                 `HVbox
                    [: `S LR "|";
                       `HVbox
                          [: `HVbox [: `S LR "Refuse"; `S LR "->" :];
                             `expr e4 "" [: `S LR "]"; k :] :] :] :] :] ];
