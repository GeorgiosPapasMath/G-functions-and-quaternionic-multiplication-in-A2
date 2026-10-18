# Reproducibility notes

This repository contains the symbolic computations cited in Sections 4.1–4.3 of *G-functions and quaternionic multiplication in A₂*. The [correspondence table](CORRESPONDENCE.md) maps the code to the current manuscript. [Source fingerprints](SOURCE_MANIFEST.sha256) identify the 27-page manuscript and original notebooks.

## Execution and verification

The computations were executed with **Wolfram 14.3.0** in a fresh kernel; other versions have not been tested. All arithmetic is exact. The Gröbner basis is recomputed from the six explicit symplectic generators using the stated variable order and the default options of `GroebnerBasis`.

| Result | Observed size |
|---|---:|
| Gröbner basis | 16 polynomials |
| Archimedean evaluation: coefficient rules | 31 |
| Archimedean reduction: coefficient rows | 8 |
| Ordinary alpha reduction: coefficient rows | 119 |
| Mixed ordinary reduction: coefficient rows | 14 |

The runner passed **26/26 exact algebra checks** without Mathematica messages. These check the fixed matrix inverses, symplectic generator convention, adjugate identity, trace-polynomial correspondence, symplectic specialization, all quotient/remainder identities, reconstruction from coefficient lists, selected coefficient identities, the specialized ordinary-alpha remainder, and the mixed coefficient/commutator identity. No approximate real numbers occur in the retained results.

The polynomial constructions, substitutions, complete quotient/remainder pairs, and coefficient lists agree exactly with the original notebook calculations. The notebook contains 17 computational input cells corresponding to `Computations.wl`, followed by three cells displaying the summary, loading `Verification.wl`, and displaying the final Boolean. All input cells passed box-to-expression round-trip checks. The computational cells were executed in a fresh kernel and passed the same 26 checks. The runner also works from a different working directory. Interactive notebook appearance has not been visually verified.

A vanishing remainder after imposing conditions is a sufficiency check. The necessity of the ordinary conditions in Proposition 4.3 is read from the unrestricted 119-row coefficient list: six coefficients are signed squares of `b11`, `b22`, `b12+b21`, `a11-c11`, `a21-c12`, and `a12-c21`; after these vanish, the coefficient of `X22 X23 X42 X44` becomes `-(a22-c22)^2`. In characteristic zero these give exactly the lowercase conditions stated on p. 22. The uppercase conditions follow by the alpha/beta symmetry used in the paper. The mixed coefficient identity in `Verification.wl` establishes that vanishing of the selected remainder coefficients forces the specialized commutator to vanish.

These checks verify explicit algebraic outputs. The manuscript's quaternion, invertibility, faithfulness, and geometric hypotheses are required for the final non-triviality conclusions. They are not inferred from successful execution alone.

## Quaternion argument

The substitutions `b12->0` and `b21->0` in the archimedean reduction follow from the coefficient evaluation and the quaternion relation in Proposition 4.1, p. 18. Proposition 4.2, p. 20, reuses this argument.

Under simultaneous vanishing of the evaluation coefficients, the initial conditions give `b11=b22=0`, `a12=a21=c12=c21=0`, `c11=a11`, and `c22=a22`. With `b12,b21` still free, the remaining polynomial is

```wolfram
2 l n (b12 + (a11 - a22) r) (b21 - (a11 - a22) r) - t1
```

Its `l n r^2` coefficient is `-2(a11-a22)^2`. Thus `a11=a22=u` follows in characteristic zero before the reduction. The matrix then has the form

```text
M = u I4 + N,    N32 = b12,    N41 = b21,
```

with all other entries of `N` zero, so `N^2=0`. The chosen endomorphism is the standard quaternion generator `alpha_s=i_s`, whose square is a nonzero rational scalar `kappa` (Section 2.1). Consequently `M^2=kappa I4` gives `u^2=kappa!=0` on the diagonal and `2u b12=2u b21=0` in the lower-left block. Since `u!=0`, both entries vanish.

The equal-diagonal polynomial `2 b12 b21 l n - t1` by itself constrains only the product. `archimedeanDiagnostic` in `Verification.wl` checks this intermediate polynomial; the quaternion relation supplies the implication that both entries vanish. The subsequent reduction keeps `a11,a22` symbolic and independently yields equal diagonals, as described on p. 18.

## Conventions and scope

- **Ordinary matrix notation.** The code uses the conjugated matrices `tilde Z` defined in (24), consistently with Claim 4.4 and (25)–(27). See [the correspondence notes](CORRESPONDENCE.md#ordinary-case-notation).
- **Coverage.** There is no separate executable beta-only reduction, period-side `Delta`/Claim 4.4 case analysis, or construction of homogenized products over places. The supersingular argument reuses the archimedean trace calculation, as in Proposition 4.2.
- **Parameters and determinants.** Generic entries remain symbolic until the specified substitutions. No parameter denominators or numerical approximations are introduced. The determinant and nonvanishing assumptions needed to interpret the calculations are stated in the correspondence table and manuscript.

All implemented stages were executed. The repository is not a formal proof of the period-theoretic or arithmetic results.
