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

---

## 📈 Applied Business Use Cases

### Case Study 1: Algorithmic Target Tracking (Leads Per Day)
* **Business Problem:** Tracking real-time representative performance telemetry to identify the exact date a "500 Lead" threshold was breached, alongside daily average velocity.
* **Functional Solution:** Used the `SCAN` function to iterate through the dataset and generate a dynamic running total array. Combined this with `FILTER` and `TAKE` to extract the exact milestone date without requiring manual helper columns.

### Case Study 2: Iterative Multi-Currency Conversions (FX Converter)
* **Business Problem:** Executing historical foreign exchange conversions across mixed currency ledgers (USD, AUD, EUR, INR) using varying daily exchange rates.
* **Functional Solution:** Deployed `MAP` and `LAMBDA` to pass arrays through custom logic blocks, applying strict row-level arithmetic transformations to calculate the normalized NZD amounts dynamically.

### Case Study 3: Cross-Column Dynamic Search Engine
* **Business Problem:** Creating a fast, user-facing lookup tool that scans the entire employee database regardless of whether the user inputs an Employee ID, Name, or Job Title.
* **Functional Solution:** Engineered a dynamic spilling array using `FILTER` combined with `ISNUMBER` and `SEARCH` across multiple columns. This bypasses the strict left-to-right limitations of `VLOOKUP` and the single-column constraints of basic `XLOOKUP`.