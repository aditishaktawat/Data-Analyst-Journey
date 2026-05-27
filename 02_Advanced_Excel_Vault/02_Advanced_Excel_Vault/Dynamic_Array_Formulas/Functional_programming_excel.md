# 🧬 Functional Programming & Array Architecture in Excel

## 🏢 Project Overview
This module demonstrates the transition from standard cell-based spreadsheet calculations to **Functional Programming**. By utilizing Excel's modern calculation engine (`LET`, `LAMBDA`, `MAP`, `SCAN`), these models eliminate redundant calculations, cache variables in memory, and iterate through matrices without VBA.

* **Target Target Engine:** `Functional_Programming_Engine.xlsx`

---

## 💻 Core Architectural Implementations

### 1. Big-O Optimization using `LET` & Array Filtering
* **Business Problem:** Extracting Top 3 and Bottom 3 performing employees dynamically without triggering volatile recalculations across massive datasets.
* **Technical Approach:** Deployed the `LET` function combined with `TAKE` and `SORT`. 
* **Engineering Impact:** By declaring variables inside `LET`, the array is evaluated and cached in memory exactly *once*. This reduces the time complexity and processor overhead compared to legacy `LARGE`/`SMALL` nested arrays.

### 2. Algorithmic Accumulation using `SCAN` vs `MAP`
* **Technical Approach:** Modeled the difference between stateless and stateful array iteration.
* **Engineering Impact:** Utilized `MAP` for independent row-by-row logical transformations, and `SCAN` to maintain a running accumulator variable (memory) across the array structure. 

### 3. Dynamic Array Spilling 
* **Technical Approach:** Replaced legacy single-cell formulas with native array engines (`FILTER`, `SORT`, `TAKE`) that dynamically spill results into adjacent matrices based on boolean logic arrays.