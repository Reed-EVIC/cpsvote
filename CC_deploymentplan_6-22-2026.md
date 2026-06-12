# CPSVote Deployment Plan
## Merge add-2022 into master + Replace Travis CI with GitHub Actions
### Prepared: June 12, 2026

---

## Overview

The `add-2022` branch is ready to merge into `master`. It adds 2022 and 2024 CPS VRS data, fixes several bugs, updates all vignettes, and includes a validation report comparing our turnout estimates to Census Bureau figures. The branch has already been verified locally (0 errors, 0 warnings from `devtools::check()`).

This plan also replaces Travis CI (an outdated continuous integration service) with GitHub Actions, which is the current standard for R packages and is built directly into GitHub.


Do not proceed to a new phase until the previous one is complete and confirmed.

---

## Phase 1: Pre-merge checklist
**Who:** Frank

### Step 1.1 — Check the current CRAN version

In R, run:
```r
available.packages(repos = "https://cran.r-project.org")["cpsvote", "Version"]
```
Or visit: https://cran.r-project.org/package=cpsvote

- If CRAN shows `0.1.x` → the `0.2.0` version in DESCRIPTION is correct, no change needed.
- If CRAN shows `0.2.0` → bump the version to `0.3.0` (see Step 1.2).

### Step 1.2 — Bump the version number (only if needed)

In `DESCRIPTION`, find the line:
```
Version: 0.2.0
```
Change it to:
```
Version: 0.3.0
```

In `NEWS.md`, add a new section at the top:
```
# cpsvote 0.3.0
- Include new 2022 and 2024 CPS VRS data
- Add 2022 turnout validation report
- Replace Travis CI with GitHub Actions
```

### Step 1.3 — Pre-build vignettes and commit output to inst/doc/

**Why this is necessary:** The vignettes use `eval = NOT_CRAN` as a global chunk option, which means no code runs — including plot-generating code — on CRAN's servers. Without this step, the vignettes on CRAN will contain text but no figures. The fix is to build the vignettes locally with real data and commit the HTML output so CRAN serves the pre-built files rather than rebuilding them.

**This step requires the full CPS data files on Paul's machine.** Frank cannot do this step remotely.

**Paul does in RStudio:**

First, make sure the environment is set so all chunks evaluate:
```r
Sys.setenv(NOT_CRAN = "true")
```

Then build all vignettes:
```r
devtools::build_vignettes()
```

This will take several minutes — it loads and processes the full CPS dataset for each vignette. When it finishes, it creates an `inst/doc/` directory containing the built HTML files and `.R` script versions of each vignette.

Verify the output looks correct by opening the HTML files in `inst/doc/` in a browser and confirming figures appear in each vignette. Key things to check:
- `voting.html` — should show a turnout-by-race bar chart and a state map
- `vote_method_trends.html` — should show trend lines by vote method and regional breakdowns
- `background.html` — may have no figures (mostly text); that is fine
- `basics.html` — should show basic output tables

**Important:** after building, do NOT run `devtools::check()` before committing `inst/doc/` — check will delete the directory as part of its cleanup.

**Frank commits the output:**

```bash
git add inst/doc/
git commit -m "Add pre-built vignette output for CRAN"
```

**Future maintenance note:** Any time the vignette code or underlying data changes, Paul must re-run `devtools::build_vignettes()` and Frank must commit the updated `inst/doc/` before the next CRAN submission. This will happen naturally each time a new election year is added.

### Step 1.4 — Run a final local package check

In RStudio, run:
```r
devtools::check()
```

Expected result: **0 errors, 0 warnings.** NOTEs about large data files are normal and acceptable for CRAN. Write down any NOTEs for use in Step 1.5.

### Step 1.5 — Update cran-comments.md

Open `cran-comments.md` in the repo root and update it. This file is what you send to CRAN reviewers. A typical entry looks like:

```
## R CMD check results

0 errors | 0 warnings | 1 note

* NOTE: installed size is X Mb; sub-directories of 1Mb or more: data Xmb
  (Large data files are expected for this package.)

Tested on:
- macOS [your version], R 4.x.x
- [any other platforms you tested]

This submission adds 2022 and 2024 CPS VRS data, updates vignettes,
and replaces Travis CI with GitHub Actions.
```

### Step 1.6 — Confirm README coverage years

Open `README.md` and search for any mention of the data coverage range (e.g., "1994–2022"). If the branch now includes 2024, update any such references to "1994–2024".

**Signal to proceed:** Paul confirms all checklist items above are done before moving to Phase 2.

---

## Phase 2: Remove Travis CI
**Who:** Frank

Travis CI is a continuous integration service that has not worked reliably for open-source projects since ~2020. The file `.travis.yml` in the repo root is a leftover configuration. We are replacing it with GitHub Actions in Phase 3.

### Step 2.1 — Delete the Travis config file

In the terminal (or RStudio terminal):
```bash
git rm .travis.yml
git commit -m "Remove Travis CI configuration"
```

Confirm the file is gone:
```bash
ls .travis.yml   # should return "No such file or directory"
```

---

## Phase 3: Add GitHub Actions R CMD check workflow
**Who:** Claude created the file; Student adds and commits it

GitHub Actions runs automated checks directly on GitHub whenever code is pushed. For R packages, the standard is to use the `r-lib/actions` templates maintained by the R infrastructure team.

### Step 3.1 — Create the workflows directory

```bash
mkdir -p .github/workflows
```

This can also be created using the command interface on RStudio. 

### Step 3.2 — Create the workflow file

Claude will create `.github/workflows/R-CMD-check.yaml` with the following content. The workflow:
- Runs on every push to `master` and every pull request targeting `master`
- Tests on three platforms: macOS, Windows, and Ubuntu (all with the current release of R)
- Skips building vignettes during CI because some vignettes (`test_download.Rmd`) require downloading live CPS data from external servers, which is inappropriate in automated checks

**File:** `.github/workflows/R-CMD-check.yaml`
```yaml
on:
  push:
  pull_request:
  
name: R-CMD-check

jobs:
  R-CMD-check:
    runs-on: ${{ matrix.config.os }}
    name: ${{ matrix.config.os }} (${{ matrix.config.r }})
    strategy:
      fail-fast: false
      matrix:
        config:
          - {os: macos-latest,   r: 'release'}
          - {os: windows-latest, r: 'release'}
          - {os: ubuntu-latest,  r: 'release'}
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
      R_KEEP_PKG_SOURCE: yes
    steps:
      - uses: actions/checkout@v4
      - uses: r-lib/actions/setup-pandoc@v2
      - uses: r-lib/actions/setup-r@v2
        with:
          r-version: ${{ matrix.config.r }}
          use-public-rspm: true
      - uses: r-lib/actions/setup-r-dependencies@v2
        with:
          extra-packages: any::rcmdcheck
          needs: check
      - uses: r-lib/actions/check-r-package@v2
        with:
          build_args: 'c("--no-manual")'
          args: 'c("--no-manual", "--as-cran")'
      - uses: r-lib/actions/setup-r-dependencies@v2  

```

### Step 3.3 — Commit the workflow file

```bash
git add .github/workflows/R-CMD-check.yaml
git commit -m "Add GitHub Actions R CMD check workflow"
```

---

## Phase 4: Merge add-2022 into master
**Who:** Student (with Paul's approval)

### Step 4.1 — Push the add-2022 branch to GitHub

Make sure all commits from Phases 2 and 3 are on the remote:
```bash
git push origin add-2022
```

### Step 4.2 — Create a pull request

**Option A (recommended):** Create a PR via the GitHub web interface or with the `gh` CLI:
```bash
gh pr create \
  --base master \
  --head add-2022 \
  --title "Add 2022 and 2024 CPS VRS data" \
  --body "Adds support for 2022 and 2024 CPS VRS data, updates vignettes, adds validation report, replaces Travis CI with GitHub Actions."
```
This creates a permanent record of the merge and triggers the GitHub Actions check before merging.

**Option B:** Paul or Frank merges directly in RStudio using the Git pane (Pull Request → Merge), or via terminal:
```bash
git checkout master
git merge add-2022
git push origin master
```

### Step 4.3 — Confirm no merge conflicts

If git reports merge conflicts, do NOT force through. Stop and review each conflicted file. Most conflicts in this repo will be in `DESCRIPTION`, `NEWS.md`, or `README.md` and are straightforward to resolve by keeping the newer (add-2022) content.

### Step 4.4 — Delete the add-2022 branch (after merge is confirmed)

```bash
git branch -d add-2022                  # delete local branch
git push origin --delete add-2022       # delete remote branch
```

---

## Phase 5: Verification
**Who:** Paul and Student together

### Step 5.1 — Confirm GitHub Actions is running

Go to the repository on GitHub and click the **Actions** tab. You should see the "R-CMD-check" workflow listed. It will show three jobs running (macOS, Windows, Ubuntu). Wait for all three to show green checkmarks. This typically takes 10–20 minutes.

If a job fails, click on it to see the log. Common causes:
- A missing package dependency (fix: add to `Suggests` in DESCRIPTION)
- A test that requires internet access (fix: skip in CI using `skip_on_cran()`)

### Step 5.2 — Final local check on master

After merging, Frank runs in RStudio:
```r
devtools::check()
```
on the master branch. This is the final gate before CRAN submission.

### Step 5.3 — Confirm .travis.yml is gone

```bash
ls .travis.yml   # should return "No such file or directory"
```

---

## Phase 6: CRAN submission
**Who:** Paul (in RStudio); Student can assist with steps 6.1–6.3

CRAN is the official R package repository. Submitting there makes the package installable via `install.packages("cpsvote")` for all R users. CRAN reviewers are volunteers; be patient and respond promptly and politely to any feedback.

### Step 6.1 — Run extended pre-submission checks

These go beyond `devtools::check()` and catch issues CRAN reviewers commonly flag.

**Check on Windows with R-devel** (CRAN's most stringent environment):
```r
devtools::check_win_devel()
```
This submits your package to a remote Windows server and emails results to the maintainer address in DESCRIPTION. Wait for the email (usually 15–30 minutes) and resolve any new warnings or errors before proceeding.

**Check spelling in documentation:**
```r
devtools::spell_check()
```
Review the output. Legitimate technical terms (e.g., "VRS", "NBER", "reweight") can be added to `inst/WORDLIST` to suppress false positives.

**Check that all URLs in documentation are reachable:**
```r
# install if needed: install.packages("urlchecker")
urlchecker::url_check()
```
Fix or remove any broken links before submitting.

### Step 6.2 — Review DESCRIPTION for CRAN style rules

CRAN has specific formatting requirements for the `DESCRIPTION` file. Open it and verify:

- **Title:** Title case, no period at the end, no "A package for..." phrasing.
  - Bad: `A toolbox for using the CPS voting supplement.`
  - Good: `A Toolbox for Using the CPS Voting and Registration Supplement`
- **Description:** Full sentences. Do not start with "This package..." Start with the package name or a verb.
- **Authors:** Must include a person with role `cre` (maintainer) and a valid email address.
- **URL / BugReports:** If the GitHub repo is public, add these fields:
  ```
  URL: https://github.com/<owner>/CPSVote
  BugReports: https://github.com/<owner>/CPSVote/issues
  ```

### Step 6.3 — Update cran-comments.md one final time

Before submitting, update `cran-comments.md` with the results from Steps 6.1 and 6.2. This file is not read automatically — you paste its contents into the "Comments" field on the CRAN submission form. A complete example:

```
## R CMD check results

0 errors | 0 warnings | 1 note

* NOTE: installed size is 8.5 Mb; sub-directories of 1Mb or more: data 8.0 Mb
  Large data files are expected for this package; the data are the core
  deliverable and cannot be reduced further.

## Test environments

* local macOS, R 4.4.x
* win-builder (R-devel) — 0 errors, 0 warnings, 1 note (same as above)

## Submission notes

This is a resubmission of cpsvote. Changes since last CRAN release (0.1.x):
- Added 2022 and 2024 CPS Voting and Registration Supplement data
- Updated vignettes to reflect data coverage through 2024
- Added 10k-row sample datasets for 2022 and 2024
- Fixed factor recoding bug (fct_recode → fct_collapse for NULL levels)
- Replaced Travis CI with GitHub Actions
```

### Step 6.4 — Submit to CRAN

In RStudio:
```r
devtools::submit_cran()
```

This will:
1. Run `R CMD check` one final time locally
2. Build the package tarball (e.g., `cpsvote_0.2.0.tar.gz`)
3. Open a browser window to the CRAN submission form at https://cran.r-project.org/submit.html

On the submission form:
- Upload the `.tar.gz` file that `devtools` built (it will tell you the path)
- Paste the contents of `cran-comments.md` into the Comments field
- Submit

You will receive a confirmation email almost immediately. **You must click the link in that email** to complete the submission — if you don't, CRAN never receives it.

### Step 6.5 — Wait for CRAN's automated check

Within a few hours, CRAN's automated system will email you with check results across multiple platforms. If there are failures:
- Read the log carefully — the error message usually identifies the file and line
- Fix the issue locally, re-run `devtools::check()` and `devtools::check_win_devel()`
- Resubmit (go back to Step 6.4)

### Step 6.6 — Respond to human reviewer feedback (if any)

If a CRAN reviewer requests changes, you will receive an email from `CRAN@R-project.org`. Common requests:

| Reviewer comment | Likely fix |
|---|---|
| "Please add `\dontrun{}` around examples that access the internet" | Wrap `cps_download_data()` examples in `\dontrun{}` in the `.Rd` files or roxygen blocks |
| "Package size exceeds CRAN limit" | Contact CRAN to request an exemption, explaining why the data files are necessary |
| "Please do not write to the user's home directory in examples" | Add `tempdir()` usage in examples that write files |
| "Title/Description does not follow CRAN policy" | See Step 6.2 |

Respond within **14 days** or the submission is automatically archived. Reply directly to the reviewer's email, cc'ing `CRAN@R-project.org`, with a summary of what you changed.

### Step 6.7 — Confirm the package is live

Once accepted (usually 1–5 business days from reviewer approval), verify:
```r
install.packages("cpsvote")  # in a fresh R session
packageVersion("cpsvote")    # should show the new version number
```

Also check the CRAN page: https://cran.r-project.org/package=cpsvote
