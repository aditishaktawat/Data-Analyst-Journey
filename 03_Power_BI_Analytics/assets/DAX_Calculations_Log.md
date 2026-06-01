# 🧠 Core DAX Reference Library & Semantic Modeling

## 🏢 Objective
Documenting the foundational DAX (Data Analysis Expressions) measures engineered for the enterprise semantic model. The focus is on transitioning from standard row-context aggregations to advanced filter-context manipulation.

---

## ⚙️ 1. Safe Aggregations & Base Metrics
Standard arithmetic operations were replaced with safe DAX functions to mitigate division-by-zero errors, alongside standard tracking metrics.

```dax
// Safe Division for Profit Margins
Profit_Margin_% = 
DIVIDE(
    [Total Profit], 
    [Total Revenue], 
    0
)

// Safe Division for Shipment Performance
Amount Per Shipment = 
DIVIDE(
    [Total Amount],
    [Shipment Count],
    0
)

// Base Volume Tracking
Average_Order_Value = AVERAGE(Sales[Revenue])
Total_Units_Sold = SUM(Sales[Quantity])

// Cross-Table Filtering for Specific Representative & Product Category
Barr Bar Amount = 
CALCULATE(
    [Total Amount],
    people[Sales_person] = "Barr Faughny",     
    products[Category] = "bars"
)

// Proportional Volume Analysis
Bar Ptage = 
DIVIDE(
    [Bar Amount],
    [Total Amount],
    0
)

// Multi-Axis Temporal and Product Filtering
Barr Bar March Amount = 
CALCULATE(
    [Total Amount],  
    people[Sales_person] = "Barr Faughny",
    products[Category] = "Bars",
    calendar[month_name] = "March"
)

// Set-Based Query Filtering using IN Operator
Total Amount Team V2 = 
CALCULATE(
    [Total Amount],
    people[Sales_person] IN {"Bar Faughny", "Ches Bonnell", "Gigi Bohling", "Dotty Strutley"}
)

// Binary Target Performance Evaluation
Target Comparison v1 = 
IF(
    [Total Amount] > [Sales Target],
    "Yes", 
    "No"
)

// Tiered Gamification & KPI Ranking (Optimized over nested IF statements)
Comparison Target = 
SWITCH(
    TRUE(),
    [Total Amount] > 2500000, "⭐⭐⭐",
    [Total Amount] > 2250000, "⭐⭐",
    [Total Amount] > 2000000, "⭐",
    "🔴"
)

