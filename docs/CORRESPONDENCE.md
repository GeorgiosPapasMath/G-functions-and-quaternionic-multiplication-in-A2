# Manuscript correspondence

References are to the 27-page *G-functions and quaternionic multiplication in A₂* by Georgios Papas, identified in [the source manifest](SOURCE_MANIFEST.sha256). Printed and PDF page numbers agree. The numbered sections below are sections of `Computations.wl` and `Computations.nb`.

## Computational arguments

| Current manuscript | Code and output | Scope |
|---|---|---|
| Lemma 2.7, (3), pp. 7–8; Proposition 4.1, (19)–(20), p. 17 | §1: `Y`, `M`, `AdjY`, `Zalpha`, `J1`, `J2`, `Pmatrix` | Defines the generic Hodge-block endomorphism matrix and archimedean conjugation. The period-theoretic lemma is not implemented. |
| Corollary 2.10, (17), p. 12; Proposition 4.3, (23)–(24), p. 21 | §1: `J0`, `J0inv`, `Rmatrix`, `Qmatrix` | Defines the conjugated alpha and beta matrices. See the notation below. |
| Proposition 4.1, pp. 17–18 | §1: `Rqmarch`, `groupedRqma` | Constructs `R'_s-t_(0,v)`, the polynomial explicitly named `Rqmarch` on p. 18. The constant is represented by `t1`. |
| Ideal `I(Sp4)` in Propositions 4.1–4.3, pp. 18, 20, 22 | §2: `f1`–`f6`, `groebnerBasis` | The six generators are the independent entries of `Transpose[Y].Omega.Y-Omega`, with `Omega={{0,I2},{-I2,0}}`. The basis is recomputed on each run. |
| Proposition 4.1, p. 18: symplectic-family coefficient test | §3: `valuesForXij`, `expevalRqma`, `coeffMonomialsLista` | Evaluates at the six-parameter matrix named in the proof and returns all 31 coefficient rules. Ideal membership implies their simultaneous vanishing; the converse is not asserted. |
| Proposition 4.1, p. 18: reduction after the displayed conditions and `b12=b21=0` | §4: `archimedeanRules`, `redRqma`, `remRqma`, `finalListRqma` | Applies the ten stated substitutions and returns 8 coefficient rows. The quaternion argument justifies the off-diagonal substitutions before this reduction. `a11,a22` remain symbolic, as required for the independent equal-diagonal deduction described in the paper. |
| Proposition 4.2, pp. 18–20; (21), p. 19 | §§1, 3–4: the same archimedean trace polynomial and coefficient arguments | The proof explicitly reuses the non-triviality argument of Proposition 4.1. No distinct supersingular polynomial routine is required for this reuse. Field extensions, normalization of period bases, and products over places are not computed. |
| Proposition 4.3 / Claim 4.4, (25), p. 22 | §1: `Rqmord0`, `groupedRqmord0` | Constructs the alpha polynomial using the conjugated entries from (24). The period-side cases in Claim 4.4 are not executable routines in this repository. |
| Proposition 4.3, (26), p. 22 | §1 defines `Qmatrix`; §5 treats the analogous alpha polynomial | The paper applies the same calculation to beta by replacing lowercase matrix entries by uppercase entries. There is no separate beta-only polynomial construction or reduction in the repository. |
| Proposition 4.3, (27), p. 22 | §1: `Rqmord`, `groupedRqmord` | Constructs the mixed polynomial using the same conjugated-entry convention. |
| Proposition 4.3, p. 22: conditions from `R_alpha` | §5: `redRqm0`, `remRqm0`, `finalListRqm0` | Unrestricted alpha reduction and all 119 coefficient rows. The ordinary conditions are not imposed in this reduction. |
| Proposition 4.3, p. 22: mixed reduction after both sets of conditions | §6: `ordinaryRules`, `redRqm`, `remRqm`, `finalListRqm` | Applies the 14 lowercase/uppercase substitutions and returns 14 coefficient rows. `Verification.wl` reconstructs the specialized commutator from six of these coefficients. |

## Ordinary-case notation

On p. 21, (23) defines the un-conjugated `Z`, and the following sentence defines `tilde Z=J0.Z.J0inv`. Formula (24), Claim 4.4 and its proof, and equations (25)–(27) on p. 22 consistently use the conjugated entries `tilde Z`.

The code uses `Rmatrix=J0.Adjugate[Y].M.Y.J0inv` and the beta analogue `Qmatrix`. Thus `Rqmord0` is the polynomial in (25), and `Rqmord` is the mixed polynomial in (27). Equation (26) is the analogous beta relation. These conjugations agree with the manuscript's notation.

## Symbols and assumptions

| Code | Meaning or convention |
|---|---|
| `X11`, …, `X44` | Entries of `Y`, in row-major order. This order is used for every basis and reduction. |
| `aij`, `bij`, `cij` | Entries of the nonzero blocks of `[alpha_s]_dR`. |
| `Aij`, `Bij`, `Cij` | Corresponding entries of `[beta_s]_dR`; capitalization is significant. |
| `Pmatrix` | `Transpose[J1].Adjugate[Y].M.Y.J1`, the archimedean conjugated matrix. |
| `Rmatrix`, `Qmatrix` | `J0.Adjugate[Y].M.Y.J0inv` and its beta analogue; entries of `tilde Z` in (24). |
| `t1` | The trace constant `t_(0,v)`, with no imposed numerical value or nonvanishing assumption. |
| `valuesForXij` | The symplectic family in Proposition 4.1; `l,m,n,p,q,r` are unrestricted. |
| `archimedeanRules` | The ten conditions applied in §4. |
| `ordinaryRules` | The 14 alpha/beta conditions applied only in §6. |

The calculations use a characteristic-zero coefficient field. The matrix `Y` is generic during construction; symplectic conditions are imposed by specialization or reduction. The adjugate introduces no denominators and agrees with the inverse on `Sp4`, where `det(Y)=1`. This is the normalization used in (20)–(21). The six generators use the standard symplectic form above.

The endomorphism matrices have zero upper-right blocks because of the Hodge filtration. In the manuscript their diagonal blocks are invertible. For Proposition 4.1, `alpha_s=i_s` is noncentral and satisfies `alpha_s^2=kappa` for nonzero rational `kappa`. For Proposition 4.3, both generators have nonzero rational squares and satisfy `alpha_s beta_s=-beta_s alpha_s`. In characteristic zero, invertibility makes the commutativity conclusion incompatible with this anticommutation relation. Faithfulness of the endomorphism action is also used in the manuscript. These conditions interpret the algebraic outputs; the source does not impose them silently on the generic entries.

For the ordinary period argument, `d0=det(pi_ij)!=0`. Claim 4.4, Case 1, allows zero entries. The division step in Case 2 assumes all four `pi_ij` are nonzero, `d11!=e22`, and `d12!=e21`, after the equal-eigenvalue subcases have been treated. For supersingular periods, Proposition 2.13 gives invertible blocks `Mv,Mvprime` with `det(Mv)det(Mvprime)=1`. These period conditions are not substitutions on the generic polynomial parameters.

The [quaternion argument](REPRODUCIBILITY.md#quaternion-argument) explains the implication `b12=b21=0` used in §4.

## Dependencies and coverage

Run the source in order. Section 1 supplies all matrices and polynomials; §2 supplies the common basis; §3 uses §1; §4 uses §§1–2 and conditions justified by §3 and the quaternion relation; §5 uses §§1–2; §6 uses §§1–2 and the ordinary conditions for both matrices. `Verification.wl` requires the completed source. There are no cache dependencies.

The following arguments have no separate routine in the repository:

- Lemma 2.7, (10)–(11), pp. 9–10; Lemma 2.9, (16), p. 11; Corollary 2.10, (17), p. 12; Proposition 2.13, pp. 13–14: period-matrix and normalization arguments, apart from the fixed change-of-basis matrices used later.
- Remarks 2.8 and 2.11: further relations and transcendence-degree bounds.
- Propositions 4.1–4.2: construction of `H`, the homogeneous factor `R'_s-t_(0,v)(1-H)^4`, field extensions, and products over places. `Rqmarch` is the congruent ideal-membership test polynomial, as stated explicitly on p. 18.
- Claim 4.4: the period-side `Delta` formula, zero-entry cases, equal-eigenvalue cases, and ratio argument. The beta reduction is invoked by symmetry, as on p. 22.
- Sections 3, 4.4, and 5: analytic G-functions, covers, arithmetic height bounds, and place enumeration.

## Source provenance

The original notebook calculations are `1.qmpolynomials.nb` (§1), `3.qmsubstitution.nb` (§3), `4.qmgrobnertest.nb` (§4), `5.qmordgrob1.nb` (§5), and `6.qmgrobtestordfinal.nb` (§6). Their fingerprints are recorded in the source manifest. The symplectic generators in §2 are given explicitly in the source and checked against the matrix equation defining `Sp4`.
