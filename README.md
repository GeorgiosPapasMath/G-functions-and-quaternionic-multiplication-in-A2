# Mathematica computations for G-functions and quaternionic multiplication in A₂

Companion code for Georgios Papas's *G-functions and quaternionic multiplication in A₂*, cited as [Pap26] in the manuscript. References use the 27-page manuscript identified in [the source manifest](docs/SOURCE_MANIFEST.sha256).

The code computes the polynomial expansions and Gröbner-basis reductions used in the non-triviality arguments of Propositions 4.1–4.3. It constructs the archimedean trace polynomial and two ordinary-case polynomials. Proposition 4.2 uses the same trace polynomial and non-triviality argument at supersingular places.

## Contents and correspondence

| File or source section | Purpose | Manuscript |
|---|---|---|
| `Computations.wl`, §1 | Matrices and the three relation polynomials | Lemma 2.7; Corollary 2.10; Propositions 4.1 and 4.3 |
| `Computations.wl`, §2 | Six-generator ideal of `Sp4` and its Gröbner basis | Propositions 4.1–4.3 |
| `Computations.wl`, §§3–4 | Archimedean coefficient evaluation and reduction | Proposition 4.1, p. 18; reused in Proposition 4.2, p. 20 |
| `Computations.wl`, §§5–6 | Ordinary alpha and mixed reductions | Proposition 4.3, p. 22 |
| `Computations.nb` | Notebook containing the same calculations | Same correspondence as the source |
| `Verification.wl` | 26 exact identity and coefficient checks | Algebraic outputs of the preceding calculations |
| `run.wls` | Command-line execution and verification | Runs the source and checks in order |
| `docs/CORRESPONDENCE.md` | Detailed paper/code map and assumptions | Current manuscript numbering |
| `docs/REPRODUCIBILITY.md` | Expected results, quaternion argument, and limitations | Scope of the symbolic verification |
| `docs/SOURCE_MANIFEST.sha256` | Manuscript and source-notebook fingerprints | Provenance |

The ordinary-case polynomials use the conjugated entries `tilde Z` defined in (24), as in Claim 4.4 and equations (25)–(27). See the [correspondence notes](docs/CORRESPONDENCE.md#ordinary-case-notation).

## Requirements and execution

A working Mathematica or Wolfram Engine kernel is required. The code was tested with **Wolfram 14.3.0**; other versions have not been tested. No third-party packages, network access, binary caches, or external data are required.

Use a fresh kernel. The initialization clears the Global context and resets `$Assumptions=True`. Evaluate the complete source in order.

Open `Computations.nb` in Mathematica and choose **Evaluation → Evaluate Notebook**. Alternatively, from a Mathematica notebook saved in the repository directory, evaluate:

```wolfram
Get[FileNameJoin[{NotebookDirectory[], "Computations.wl"}]];
Get[FileNameJoin[{NotebookDirectory[], "Verification.wl"}]];
calculationSummary
verificationResults
verificationPassed
```

From a terminal in the repository directory:

```sh
wolframscript -file run.wls
```

If `WolframKernel` is on the system search path, it can also be used directly:

```sh
WolframKernel -noinit -noprompt -script run.wls
```

The runner finds its source files relative to its own location and writes no files. Exit status `0` means the computations completed without messages and all 26 checks passed; status `1` indicates a message or failed check.

## Results and scope

`calculationSummary` reports a basis of length **16**, and coefficient-list lengths **31**, **8**, **119**, and **14** for the archimedean evaluation, archimedean reduction, ordinary alpha reduction, and mixed ordinary reduction, respectively. The corresponding lists are `coeffMonomialsLista`, `finalListRqma`, `finalListRqm0`, and `finalListRqm`. The complete quotient/remainder pairs are `redRqma`, `redRqm0`, and `redRqm`.

All arithmetic is exact. The source uses the explicit variable order and default options of `GroebnerBasis` and `PolynomialReduce`. The checks verify polynomial identities, coefficient reconstruction, reductions, and the mixed-remainder/commutator correspondence. The non-triviality conclusions also use the manuscript's quaternion, invertibility, and faithfulness assumptions.

The repository does not construct products over places, evaluate numerical G-functions, or implement the geometric proofs. The beta-only reduction is used by symmetry in the paper and has no separate routine here. The manuscript PDF is not included.

## License

MIT License. Copyright © 2026 Georgios Papas. See [LICENSE](LICENSE).
