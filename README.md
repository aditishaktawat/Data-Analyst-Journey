# Data-Analyst-Journey
Starting my journey to become a Data Analyst
Completed the SQLBOLT lectures 1-5 and learnt how the basic opearators are used with SELECT sentence.

## 📊 Phase 1: SQL


### 7. Materialized Views (The Performance Booster)

The Problem: Standard Views run the underlying query every single time someone looks at them. If a dashboard relies on a View that processes 10 million rows, the dashboard will take 5 minutes to load every morning.

The Solution: A Materialized View actually runs the query and saves the physical results to the hard drive.

Business Insight: "Implemented Materialized Views to cache complex aggregations. In a production environment, this reduces compute costs and allows BI dashboards (like Tableau) to load instantly, requiring only a nightly REFRESH MATERIALIZED VIEW command rather than querying raw data live."

### 8. Recursive CTEs (WITH RECURSIVE)

The Problem: Standard SQL is bad at "hierarchies" or "trees" (e.g., finding the CEO, then the VPs under the CEO, then the Directors under the VPs, then the Managers...).

The Solution: Recursive queries loop over themselves until they hit the bottom of the tree.

Business Insight: "Utilized Recursive CTEs to navigate hierarchical data structures. This technique is essential for HR analytics (mapping employee-manager reporting lines), Supply Chain (Bill of Materials/parts explosions), and identifying multi-tier referral networks."

### 3. Stored Procedures (The Process Automator)

The Problem: In a retail database, a single customer purchase requires multiple steps: checking if the item is in stock, inserting a new record into the sales table, and updating the products table to reduce inventory. If done manually, human error can lead to selling out-of-stock items or corrupting the database.

The Solution: Encapsulate the entire business workflow into a reusable Stored Procedure.

Business Insight: "Developed parameterized Stored Procedures to handle real-world e-commerce transactions. The procedure automatically validates product availability against requested quantities. If sufficient stock exists, it executes a multi-table update (logging the sale and deducting inventory), ensuring absolute data integrity and preventing costly out-of-stock sales errors."

---

## 📊 Phase 2: Enterprise Excel Architecture

**Objective:** Transitioning from foundational syntax to treating Microsoft Excel as a scalable, relational data engine capable of automated ETL, vector-based logic, and multi-dimensional modeling.

### 1. Power Query ETL Pipelines (`02_Advanced_Excel_Vault/Power_Query_ETL_Pipelines/`)
Built automated ETL pipelines to handle unstructured data ingestion and structural mutations without manual interference.
**Live Web-Scraping Engine:** Abstracted static Wikipedia data for the 2020 Summer Olympics into a cloud-refreshable pipeline.
**Algorithmic Exception Handling:** Resolved complex HTML row-spans using look-ahead tools natively in M-Code (`Table.FillUp`).
**Feature Engineering:** Engineered a custom `Weighted_Performance_Index` to normalize athletic dominance for accurate reporting.
**Automated HR Data Cleansing:** Deployed a zero-touch refresh pipeline to clean highly corrupted staff datasets, enforcing strict data typing and eliminating legacy manual formatting.

### 2. Dynamic Array Logic (`02_Advanced_Excel_Vault/Dynamic_Array_Formulas/`)
Engineered a fully automated HR reporting suite using solely modern Excel dynamic arrays, bypassing legacy `VLOOKUP` logic entirely.
**Spill-Anchored Scaling:** Implemented dynamic arrays via nested `SORT(FILTER())` logic.
 **Multi-Criteria Vectors:** Executed targeted cohort isolation utilizing Boolean `*` operators for conditional matrix filtering.
**Automated Dashboards:** Integrated dynamic medians and female representation ratios with live conditional data bars mapping percentage drift
**🧬 Functional Programming Engine (LET, LAMBDA, MAP, SCAN): Memory-optimized array calculations and custom recursive logic.


### 3. Multi-Dimensional Pivot Models (`02_Advanced_Excel_Vault/Multi_Dimensional_Pivot_Models/`)
Transitioned from flat-file formulas to semantic aggregation layers to track operational metrics.
**Volumetric Analysis:** Analyzed customer segments, volumes, and QA performance matrices for enterprise call centre operations (`call_centre_volumetric_analysis.xlsx`)
**Temporal Aggregations:** Modeled continuous grouping intervals, chronological trends, and cumulative YTD matrices (`call_centre_temporal_aggregations.xlsx`).
**Operational Telemetry:** Documented key metrics and logic in `Operational_Telemetry.md` to bridge raw telemetry with executive presentation layers.

### 📞 Enterprise Call Centre Telemetry (Capstone Dashboard)
* **The Objective:** Transformed 1,000 raw operational call records into a single-pane executive tracking interface to monitor resource allocation and customer lifetime value.
* **The Architecture:** 
  * Built a macro-free interactive UI using High-Signal Minimalism (muted canvas, Segoe UI typography).
  * Engineered dynamic slicers mapping Representative efficiency against CSAT and revenue generation.
  * Deployed sorted arrays isolating top-tier high-value accounts from operational time-wasters.
* **[Link to Dashboard Documentation & UI Asset](./02_Advanced_Excel_Vault/Call_Centre_Analytics/Call_Centre_Telemetry_Dashboard.md)**

---

## 📊 Phase 3: Power BI & Semantic Data Modeling
Transitioning from in-memory arrays to enterprise-scale semantic models, utilizing DAX, Star Schemas, and interactive UI design.

### 🌍 Global Revenue Telemetry
* **Status:** Completed & Deployed
* **The Objective:** Built a dynamic tracking interface to monitor $27.72M in global sales, segmenting product performance and regional market share.
* **The Architecture:** 
  * Deployed geographical Treemaps to isolate high-value international markets (UK & USA).
  * Engineered a time-series trajectory model to track monthly revenue cyclicality.
  * Built a workforce velocity matrix to identify top-performing sales representatives.
* **[View Full Power BI Documentation & Dashboard UI](./03_Power_BI_Analytics/Global_Revenue_Telemetry.md)**

### 🧠 Advanced DAX Reference Library & Filter Context
* **Status:** Completed
* **The Objective:** Developed a semantic layer tracking advanced sales vectors, implementing strict filter override behaviors and conditional logic.
* **The Architecture:**
  * Mitigated runtime division faults using safe execution layers (`DIVIDE`).
  * Engineered complex context overrides via `CALCULATE` mapping cross-table constraints (Salesperson, Category, and Temporal matrices).
  * Built tiered performance ranking matrices using optimized `SWITCH(TRUE())` engines.
* **[View Full DAX Repository Logic](./03_Power_BI_Analytics/DAX_Calculations_Logs.md)**

---

## 🐍 Phase 4: Python Data Analytics & In-Memory Processing

## 📌 Architectural Overview
This phase marks the transition from standard relational databases (SQL) and cell-based logic (Excel) to programmatic, multidimensional data manipulation using Python.

### 🧮 Core Module: NumPy (`numpy.ipynb`)
The first deployment in this environment focuses on **NumPy (Numerical Python)**, the foundational engine for high-speed scientific computing.