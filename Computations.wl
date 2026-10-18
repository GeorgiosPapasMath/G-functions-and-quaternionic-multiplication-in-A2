(* ::Title:: *)
(* Companion computations for G-functions and quaternionic multiplication in A₂ *)

(* ::Text:: *)
(* Run this file in a fresh kernel, from top to bottom. It clears Global`.
   Section and equation numbers below refer to the manuscript.
   All arithmetic is exact. No external data files or packages are needed.
   See docs/CORRESPONDENCE.md for provenance and the limits of coverage. *)

(* ::Section:: *)
(* Initialization and common coefficient-list routine *)

ClearAll["Global`*"];
$HistoryLength = 0;
$Assumptions = True;

vars = {
  X11, X12, X13, X14, X21, X22, X23, X24,
  X31, X32, X33, X34, X41, X42, X43, X44
};

(* Parameters not in the variable list are symbolic coefficients.
   Factor each coefficient while preserving the monomial order.
   Each row is {monomial, factored coefficient}; no coefficients are dropped. *)
factoredCoefficientList[poly_, variables_List] :=
  Table[{Times @@ (variables^rule[[1]]), Factor[rule[[2]]]},
    {rule, CoefficientRules[poly, variables]}];

(* ::Section:: *)
(* 1. Matrices and relation polynomials *)

(* Source: 1.qmpolynomials.nb. M and Mprime represent [alpha_s]_dR
   and [beta_s]_dR. Their upper-right blocks are zero (Hodge filtration).
   No quaternion, invertibility or nonvanishing constraints are imposed
   on their symbolic entries by these polynomial calculations.
   Adjugate[Y] is retained; it equals Inverse[Y] only on Sp4, where det Y=1. *)
Y = {{X11, X12, X13, X14}, {X21, X22, X23, X24},
     {X31, X32, X33, X34}, {X41, X42, X43, X44}};
M = {{a11, a12, 0, 0}, {a21, a22, 0, 0},
     {b11, b12, c11, c12}, {b21, b22, c21, c22}};
Mprime = {{A11, A12, 0, 0}, {A21, A22, 0, 0},
          {B11, B12, C11, C12}, {B21, B22, C21, C22}};

AdjY = Adjugate[Y];
Zalpha = AdjY . M . Y;
Zbeta = AdjY . Mprime . Y;

(* J1 = J'_(2,4), J2 = Transpose[J1] in Lemma 2.7, equation (3).
   J0 and J0inv are those of Corollary 2.10, equation (17). *)
J1 = {{1, 0, 0, 0}, {0, 0, 0, -1}, {0, 0, 1, 0}, {0, 1, 0, 0}};
J2 = {{1, 0, 0, 0}, {0, 0, 0, 1}, {0, 0, 1, 0}, {0, -1, 0, 0}};
J0 = {{1, 0, 0, 0}, {0, 0, 0, 1}, {0, 1, 0, 0}, {0, 0, 1, 0}};
J0inv = {{1, 0, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}, {0, 1, 0, 0}};

Pmatrix = Simplify[J2 . Zalpha . J1];
Qmatrix = Simplify[J0 . Zbeta . J0inv];
Rmatrix = Simplify[J0 . Zalpha . J0inv];

P13 = Pmatrix[[1, 3]]; P14 = Pmatrix[[1, 4]];
P23 = Pmatrix[[2, 3]]; P24 = Pmatrix[[2, 4]];
P31 = Pmatrix[[3, 1]]; P32 = Pmatrix[[3, 2]];
P41 = Pmatrix[[4, 1]]; P42 = Pmatrix[[4, 2]];
Q12 = Qmatrix[[1, 2]]; Q21 = Qmatrix[[2, 1]];
R12 = Rmatrix[[1, 2]]; R14 = Rmatrix[[1, 4]];
R21 = Rmatrix[[2, 1]]; R23 = Rmatrix[[2, 3]];

(* Proposition 4.1, pp. 16-18: R'_s - t_(0,v), with t1 = t_(0,v).
   This is the ideal-membership test polynomial, not the homogenized
   R_(s,v) or its product over places. Proposition 4.2 reuses this test. *)
Rqmarch = P13 P31 + P14 P41 + P23 P32 + P24 P42 - t1;
groupedRqma = Collect[Expand[Rqmarch], vars];

(* Proposition 4.3 / Claim 4.4, equation (25): R_alpha.
   Entries are from J0.Zalpha.J0inv, the tilde matrix in (24),
   consistently used in equations (25)-(27). *)
Rqmord0 = R12 R23 - R14 R21;
groupedRqmord0 = Collect[Expand[Rqmord0], vars];

(* Proposition 4.3, equation (27): R_(alpha beta). *)
Rqmord = R12 Q21 - R21 Q12;
groupedRqmord = Collect[Expand[Rqmord], vars];

(* ::Section:: *)
(* 2. Symplectic ideal and Groebner basis *)

(* Ideal I(Sp4) used in Propositions 4.1-4.3, pp. 18, 20, 22.
   GroebnerBasis uses the explicit variable
   order in vars and its default options. The six equations express
   Transpose[Y].Omega.Y == Omega
   for Omega = {{0,I2},{-I2,0}}. *)
f1 = -X31 X12 - X41 X22 + X11 X32 + X21 X42;
f2 = -X31 X13 - X41 X23 + X11 X33 + X21 X43 - 1;
f3 = -X31 X14 - X41 X24 + X11 X34 + X21 X44;
f4 = -X32 X13 - X42 X23 + X12 X33 + X22 X43;
f5 = -X32 X14 - X42 X24 + X12 X34 + X22 X44 - 1;
f6 = -X33 X14 - X43 X24 + X13 X34 + X23 X44;
groebnerBasis = GroebnerBasis[{f1, f2, f3, f4, f5, f6}, vars];

(* ::Section:: *)
(* 3. Archimedean coefficient evaluation *)

(* Source: 3.qmsubstitution.nb. Proposition 4.1, p. 18.
   Evaluate at S(l,m,n,p,q,r), denoted valuesForXij in the proof.
   Its six parameters are unrestricted.
   coeffMonomialsLista contains exponent-vector -> coefficient rules.
   The manuscript interprets their simultaneous vanishing; the calculation
   does not apply Solve or impose additional assumptions. *)
valuesForXij = {
  X11 -> 1, X12 -> 0, X13 -> n, X14 -> m,
  X21 -> 0, X22 -> 1, X23 -> m, X24 -> l,
  X31 -> p, X32 -> r, X33 -> 1 + p n + r m, X34 -> p m + r l,
  X41 -> r, X42 -> q, X43 -> r n + q m, X44 -> 1 + q l + r m
};
expevalRqma = Expand[groupedRqma /. valuesForXij];
coeffMonomialsLista = CoefficientRules[expevalRqma, {l, m, n, p, q, r}];

(* ::Section:: *)
(* 4. Archimedean reduction *)

(* Source: 4.qmgrobnertest.nb. Proposition 4.1, p. 18; also used in 4.2.
   The substitutions use the coefficient conditions of Proposition 4.1
   together with the
   quaternion hypothesis. After the initial conditions other than
   b12=b21=0, the polynomial is
     2 l n (b12+(a11-a22)r)(b21-(a11-a22)r)-t1.
   Its l n r^2 coefficient is -2(a11-a22)^2, so vanishing gives
   a11=a22=u before this reduction. Then M=u I4+N with N^2=0.
   Since alpha_s=i_s has square kappa in Q\{0}, M^2=kappa I4 gives
   u^2=kappa and 2u b12=2u b21=0; hence b12=b21=0.
   This deduction precedes the reduction. The reduction keeps a11,a22
   symbolic. The replacement rules do not assign values to the parameters. *)
archimedeanRules = {
  b11 -> 0, b22 -> 0, b12 -> 0, b21 -> 0,
  a12 -> 0, a21 -> 0, c12 -> 0, c21 -> 0,
  c11 -> a11, c22 -> a22
};
groupedRqmasub = groupedRqma /. archimedeanRules;
redRqma = PolynomialReduce[groupedRqmasub, groebnerBasis, vars];
remRqma = Last[redRqma];
finalListRqma = factoredCoefficientList[remRqma, vars];

(* ::Section:: *)
(* 5. Ordinary alpha reduction *)

(* Source: 5.qmordgrob1.nb. Proposition 4.3, p. 22.
   No ordinary specialization conditions are imposed at this stage. *)
redRqm0 = PolynomialReduce[groupedRqmord0, groebnerBasis, vars];
remRqm0 = Last[redRqm0];
finalListRqm0 = factoredCoefficientList[remRqm0, vars];

(* ::Section:: *)
(* 6. Mixed ordinary reduction *)

(* Source: 6.qmgrobtestordfinal.nb. Proposition 4.3, p. 22.
   The manuscript assumes R_alpha and R_beta lie in I(Sp4) and imposes
   the following conditions on both matrices. Uppercase names belong
   to beta; lowercase names belong to alpha. The transpose convention is
   a21 -> c12, a12 -> c21; the sign conditions are b12 -> -b21 and B12 -> -B21. *)
ordinaryRules = {
  b11 -> 0, b22 -> 0, b12 -> -b21,
  a11 -> c11, a21 -> c12, a12 -> c21, a22 -> c22,
  B11 -> 0, B22 -> 0, B12 -> -B21,
  A11 -> C11, A21 -> C12, A12 -> C21, A22 -> C22
};
evalRqmord = groupedRqmord /. ordinaryRules;
redRqm = PolynomialReduce[evalRqmord, groebnerBasis, vars];
remRqm = Last[redRqm];
finalListRqm = factoredCoefficientList[remRqm, vars];

(* ::Section:: *)
(* Results *)

(* Inspect these values directly; large polynomial output is not printed.
   redRqma, redRqm0 and redRqm retain {quotients, remainder}, allowing
   the exact reconstruction checks in Verification.wl. *)
calculationSummary = <|
  "GroebnerBasisLength" -> Length[groebnerBasis],
  "ArchimedeanEvaluationCoefficientCount" -> Length[coeffMonomialsLista],
  "ArchimedeanReductionCoefficientCount" -> Length[finalListRqma],
  "OrdinaryAlphaCoefficientCount" -> Length[finalListRqm0],
  "OrdinaryMixedCoefficientCount" -> Length[finalListRqm]
|>;
