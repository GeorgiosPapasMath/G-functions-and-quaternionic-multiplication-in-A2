(* Execute with: wolframscript -file run.wls
   or: WolframKernel -noinit -noprompt -script run.wls *)

computationRunOK = Check[
  Get[FileNameJoin[{DirectoryName[$InputFileName], "Computations.wl"}]];
  True, False];
If[!TrueQ[computationRunOK], Print["Computation emitted a message."]; Exit[1]];

verificationRunOK = Check[
  Get[FileNameJoin[{DirectoryName[$InputFileName], "Verification.wl"}]];
  True, False];
Print[calculationSummary];
Print["Exact algebra checks passed: ", Count[Values[verificationResults], True],
  "/", Length[verificationResults]];
If[!TrueQ[verificationPassed], Print[Select[verificationResults, !TrueQ[#] &]]];
Print["Quaternion argument: see docs/REPRODUCIBILITY.md."];
Exit[If[TrueQ[verificationRunOK] && TrueQ[verificationPassed], 0, 1]];
