# Data-Analyst-Journey
Starting my journey to become a Data Analyst
Completed the SQLBOLT lectures 1-5 and learnt how the basic opearators are used with SELECT sentence.

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