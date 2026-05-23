# 📈 Enterprise Operational Telemetry & Multi-Dimensional Pivot Modeling

## 🏢 Project Overview
This repository contains two parallel multi-dimensional analytical layers targeting corporate telecom metrics from an enterprise Call Centre database. The analysis is programmatically split into operational volume segmentations and temporal analytics.

---

## 📊 Phase I: Volumetric Modeling & Quality Segmentations (Milestones 1–4)
* **Target Workbook Engine:** `call_centre_volumetric_analysis.xlsx`

### 1. Corporate Customer Interaction Mapping
* **Objective:** Map transactional workload distributions across customer classifications.
* **Technical Architecture:** Pivoted raw dimensional tables to calculate the explicit share of call count variables per customer segment.

### 2. Quality Assurance (QA) Customer Satisfaction Drift
* **Objective:** Identify skew and deviations in recorded client sentiment.
* **Technical Architecture:** Altered pivot aggregation functions to isolate mean vs. median values, exposing gaps where customer satisfaction drifted below target service levels.

### 3. Top-N High-Value Customer Profiling
* **Objective:** Isolate priority user cohorts driving network traffic.
* **Technical Architecture:** Applied a programmatic Top-10 value filter constraint directly to the pivot data cache, bypassing manual sorting protocols.

### 4. Cross-Dimensional Representative Performance Index
* **Objective:** Track individual agent throughput across customer categories.
* **Technical Architecture:** Unified standalone filter dimensions with independent Slicer caching to evaluate representative performance across different customer tiers.

---

## ⏱️ Phase II: Temporal Dynamics & Advanced Accumulation Layers (Milestones 5–7)
* **Target Workbook Engine:** `call_centre_temporal_aggregations.xlsx`

### 5. Numerical Duration Interval Binning (Data Bucketing)
* **Objective:** Group raw, continuous call length variables into discrete performance blocks.
* **Technical Architecture:** Implemented automated numeric grouping parameters, segmenting call durations into fixed frequency histograms to locate processing bottlenecks.

### 6. Temporal Volatility & Capacity Optimization Trends
* **Objective:** Expose peak network stress spikes across structural dates.
* **Technical Architecture:** Engineered rolling time-series pivot structures mapped to conditional trend charts to spot performance volatility across specific months and hours.

### 7. Cumulative YTD Financial Accumulation
* **Objective:** Calculate compounding performance totals across the fiscal timeline.
* **Technical Architecture:** Applied advanced "Show Values As" execution properties to calculate continuous Year-to-Date (YTD) running sum vectors over the dataset.

---

## 🧑‍💻 Phase III: Resource Allocation & Behavioral Correlation (Milestones 8–10)
* **Target Workbook Engine:** `call_centre_resource_allocation.xlsx`

### 8. Weekly Volatility Index & Capacity Planning
* **Business Objective:** Identify weekly peak volume days to optimize agent scheduling.
* **Technical Architecture:** Deployed a cross-tabular pivot matrix utilizing `% of Row Total` calculation layers. This normalized workload distributions across individual representatives (R01-R05), bypassing raw volume bias to reveal true percentage-based workload stress on weekends vs. weekdays.

### 9. CSAT vs. Handling Time (Correlation Matrix)
* **Business Objective:** Determine the statistical relationship between prolonged Call Duration and Customer Satisfaction (CSAT) degradation.
* **Technical Architecture:** Intersected dimensional duration buckets against ordinal CSAT scales (0-5). The resulting distribution matrix exposed negative sentiment drift during high-duration interactions, providing actionable proof for stricter call-resolution time targets.

### 10. Predictive Staffing & Prescriptive Headcount Modeling
* **Business Objective:** Generate data-backed hiring recommendations for the upcoming fiscal cycle based on historical burnout trends.
* **Technical Architecture:** Constructed a chronologically mapped workload matrix (Jan-Dec) filtering for volume thresholds per representative. 
* **Business Impact:** Translated raw pivot counts directly into prescriptive business logic (e.g., triggering explicit headcount acquisition signals for Agent R02 in Q2 and Agent R03 in Q4).

---

## 🎯 Phase IV: Customer Segmentation & Agent Training
* **Target Workbook:** `call_centre_customer_insights.xlsx`

### 11. Identifying "Time Waster" Customers (Scatter Plot Analysis)
* **Goal:** Find out which customers take up a lot of support time but spend very little money.
* **How I did it:** I built a pivot table summarizing the total number of calls and the total purchase amount for each customer (C0001 - C0015). 
* **Visual Insight:** I used a **Scatter Graph** to plot Call Volume against Purchase Amount. This made it incredibly easy to visually segment customers into groups like "Ideal" (high spend, low calls) and "Low Value / Time Wasters" (high calls, low spend).

### 12. Identifying Agents for CSAT Training
* **Goal:** Figure out which customer service representatives need additional training based on their Customer Satisfaction (CSAT) scores.
* **How I did it:** I created a cross-tab pivot table showing the average CSAT rating for each representative (R01 to R05), broken down month-by-month. 
* **Business Impact:** Instead of looking at overall averages which can hide bad months, this monthly breakdown makes it easy to spot reps who are consistently scoring poorly or dropping in performance over time.
