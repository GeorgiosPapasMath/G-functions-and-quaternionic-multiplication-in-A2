(* Run after Computations.wl. These are exact algebra and bookkeeping checks,
   not a verification of the geometric arguments or all manuscript inferences.
   The Proposition 4.1 quaternion argument is explained in the comments
   of Computations.wl and in docs/REPRODUCIBILITY.md. *)

If[!AssociationQ[calculationSummary],
  Print["Evaluate Computations.wl before Verification.wl."]; Abort[]];

zeroPolynomialQ[expr_] := TrueQ[Expand[expr] === 0];
zeroMatrixQ[expr_] := AllTrue[Flatten[expr], zeroPolynomialQ];
fromCoefficientRules[rules_, variables_] :=
  Total[(Last[#] Times @@ (variables^First[#])) & /@ rules];
fromCoefficientList[rows_] := Total[Times @@@ rows];
coefficientInList[rows_, monomial_] :=
  Last[SelectFirst[rows, First[#] === monomial &, {monomial, 0}]];
reductionIdentityQ[poly_, reduction_] :=
  zeroPolynomialQ[poly - First[reduction] . groebnerBasis - Last[reduction]];

symplecticForm = {{0, 0, 1, 0}, {0, 0, 0, 1},
                 {-1, 0, 0, 0}, {0, -1, 0, 0}};
symplecticDefect = Expand[Transpose[Y] . symplecticForm . Y - symplecticForm];
symplecticSample = Y /. valuesForXij;

(* Read coefficients of the mixed ordinary reduction. Their linear arrangement is
   checked against the commutator appearing on p. 22. No new ideal or
   elimination argument is introduced. *)
mixedCoefficients = coefficientInList[finalListRqm, #] & /@
  {X11 X13, X13 X21, X13 X31, X13 X41, X21 X23, X23 X31};
commutatorFromCoefficients = With[
  {u = mixedCoefficients[[1]], v = mixedCoefficients[[2]],
   w = mixedCoefficients[[3]], x = mixedCoefficients[[4]],
   y = mixedCoefficients[[5]], z = mixedCoefficients[[6]]},
  {{w, z, 0, 0}, {x, -w, 0, 0},
   {-2 u, -v, -w, -x}, {-v, -2 y, -z, w}}];

verificationResults = <|
  "J2 is the transpose/inverse of J1" ->
    (J2 === Transpose[J1] && J2 . J1 === IdentityMatrix[4]),
  "J0inv is the inverse of J0" -> (J0 . J0inv === IdentityMatrix[4]),
  "Symplectic ideal: generators match the symplectic form" ->
    zeroMatrixQ[{
      symplecticDefect[[1, 2]], symplecticDefect[[1, 3]],
      symplecticDefect[[1, 4]], symplecticDefect[[2, 3]],
      symplecticDefect[[2, 4]], symplecticDefect[[3, 4]]
    } - {f1, f2, f3, f4, f5, f6}],
  "Symplectic ideal: generators reduce to zero" ->
    AllTrue[{f1, f2, f3, f4, f5, f6},
      zeroPolynomialQ[Last[PolynomialReduce[#, groebnerBasis, vars]]] &],
  "Adjugate identity" -> zeroMatrixQ[AdjY . Y - Det[Y] IdentityMatrix[4]],
  "Archimedean polynomial is the stated block trace minus t1" ->
    zeroPolynomialQ[Rqmarch -
      Tr[Pmatrix[[1 ;; 2, 3 ;; 4]] . Pmatrix[[3 ;; 4, 1 ;; 2]]] + t1],
  "Collected archimedean polynomial is unchanged" ->
    zeroPolynomialQ[groupedRqma - Rqmarch],
  "Collected alpha polynomial is unchanged" ->
    zeroPolynomialQ[groupedRqmord0 - Rqmord0],
  "Collected mixed polynomial is unchanged" ->
    zeroPolynomialQ[groupedRqmord - Rqmord],
  "Archimedean evaluation: sample matrix is symplectic" ->
    zeroMatrixQ[Transpose[symplecticSample] . symplecticForm .
      symplecticSample - symplecticForm],
  "Archimedean evaluation: sample matrix has determinant one" ->
    zeroPolynomialQ[Det[symplecticSample] - 1],
  "Archimedean evaluation: coefficient rules reconstruct the polynomial" ->
    zeroPolynomialQ[expevalRqma -
      fromCoefficientRules[coeffMonomialsLista, {l, m, n, p, q, r}]],
  "Archimedean reduction: quotient-remainder identity" -> reductionIdentityQ[groupedRqmasub, redRqma],
  "Ordinary alpha reduction: quotient-remainder identity" -> reductionIdentityQ[groupedRqmord0, redRqm0],
  "Mixed ordinary reduction: quotient-remainder identity" -> reductionIdentityQ[evalRqmord, redRqm],
  "Archimedean reduction: factored list reconstructs the remainder" ->
    zeroPolynomialQ[remRqma - fromCoefficientList[finalListRqma]],
  "Ordinary alpha reduction: factored list reconstructs the remainder" ->
    zeroPolynomialQ[remRqm0 - fromCoefficientList[finalListRqm0]],
  "Mixed ordinary reduction: factored list reconstructs the remainder" ->
    zeroPolynomialQ[remRqm - fromCoefficientList[finalListRqm]],
  "Archimedean reduction: coefficient of X21 X23 X42 X44" ->
    zeroPolynomialQ[coefficientInList[finalListRqma, X21 X23 X42 X44] +
      2 (a11 - a22)^2],
  "Archimedean reduction: constant coefficient is -t1" ->
    zeroPolynomialQ[coefficientInList[finalListRqma, 1] + t1],
  "Ordinary alpha reduction: coefficient of X11 X12 X13^2" ->
    zeroPolynomialQ[coefficientInList[finalListRqm0, X11 X12 X13^2] - b11^2],
  "Ordinary alpha reduction: coefficient of X12 X13 X22 X24" ->
    zeroPolynomialQ[coefficientInList[finalListRqm0, X12 X13 X22 X24] +
      (b12 + b21)^2],
  "Ordinary alpha reduction: remainder vanishes after the stated ordinary conditions" ->
    zeroPolynomialQ[remRqm0 /. ordinaryRules],
  "Mixed ordinary reduction: coefficients reproduce the stated commutator" ->
    zeroMatrixQ[((M . Mprime - Mprime . M) /. ordinaryRules) -
      commutatorFromCoefficients],
  "No approximate real numbers in the retained results" ->
    FreeQ[{groupedRqma, groupedRqmord0, groupedRqmord, groebnerBasis,
      coeffMonomialsLista, redRqma, redRqm0, redRqm}, _Real]
|>;

(* After the initial Proposition 4.1 conditions and a22=a11,
   the residual polynomial constrains b12 b21. The l n r^2 coefficient
   of the preceding polynomial already forces a22=a11. The quaternion
   relation M^2=kappa I4, kappa!=0, then forces both b12 and b21 to vanish,
   as documented in the archimedean reduction section. This diagnostic alone does not impose that relation. *)
archimedeanDiagnostic = Expand[
  (expevalRqma /. DeleteCases[archimedeanRules,
      HoldPattern[Rule[b12 | b21, _]]]) /. a22 -> a11];
verificationResults = Append[verificationResults,
  "Archimedean evaluation: diagnostic specializes to 2 b12 b21 l n - t1" ->
    zeroPolynomialQ[archimedeanDiagnostic - (2 b12 b21 l n - t1)]];

verificationPassed = And @@ Values[verificationResults];
