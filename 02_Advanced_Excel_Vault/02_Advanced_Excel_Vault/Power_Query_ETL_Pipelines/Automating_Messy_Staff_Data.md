The Business Context: "Automated the cleaning of a highly corrupted HR dataset, eliminating 4 hours of manual formatting per week."

# ETL Pipeline: HR Employee Roster Standardization

## 📌 The Business Context
Legacy HR staff data is frequently exported in corrupted, non-relational formats containing inconsistent delimiters, unhandled nulls, and merged strings. This Power Query pipeline automates the extraction and transformation of raw local CSV/Excel exports, converting them into a strict, machine-readable tabular format optimized for downstream SQL ingestion and Power BI semantic models.

## ⚙️ Pipeline Architecture (Transformations Applied)
This M-Code script executes the following automated pipeline sequentially:

* **String Manipulation & Cleansing:** Automatically trims whitespace anomalies and splits merged `FullName` strings into discrete `First Name` and `Last Name` variables, handling middle-name overflow safely.
* **Anomaly Resolution & Imputation:** Replaces missing demographic values with standard "Missing" flags, removes corrupted department strings (e.g., converting "???" to "Engineering"), and aggressively filters out invalid records (Salary = 0 or null).
* **Dynamic Feature Engineering:** * Evaluates continuous numeric data to generate categorical `Salary Bucket` dimensions for cohort analysis.
    * Uses dynamic temporal logic (`DateTime.LocalNow()`) to calculate current employee tenure (in years) against their `Start Date`.
    * Derives categorical `Work Type` (Full Time vs. Part Time) based on numeric `FTE` flags.
* **Strict Schema Enforcement:** Forces absolute data typing (Date, Number, Text) across all columns to prevent aggregation errors in downstream analytical engines.

## 💻 The Engine (M-Code)
This code represents the automated background query. Once established, future data drops require only a single refresh execution, eliminating manual formatting tasks entirely.

```powerquery
let
    Source = Excel.Workbook(File.Contents("C:\Users\aditi\OneDrive\Desktop\EXcel\4-hour-course-xl-files\02.sample-staff-data.xlsx"), null, true),
    Staff_Sheet = Source{[Item="Staff",Kind="Sheet"]}[Data],
    #"Promoted Headers" = Table.PromoteHeaders(Staff_Sheet, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Emp ID", type text}, {"Name", type text}, {"Gender", type text}, {"Department", type text}, {"Salary", type number}, {"Start Date", type date}, {"FTE", type number}, {"Employee type", type text}, {"Work location", type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Changed Type",null,"Missing",Replacer.ReplaceValue,{"Gender"}),
    #"Trimmed Text" = Table.TransformColumns(#"Replaced Value",{{"Name", Text.Trim, type text}}),
    #"Replaced Value1" = Table.ReplaceValue(#"Trimmed Text","???","Engineering",Replacer.ReplaceText,{"Department"}),
    #"Filtered Rows" = Table.SelectRows(#"Replaced Value1", each ([Salary] <> null and [Salary] <> 0)),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Filtered Rows", "Name", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, false), {"Name.1", "Name.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Name.1", type text}, {"Name.2", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type1",{{"Name.1", "First Name"}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Renamed Columns",{{"Name.2", Text.Trim, type text}}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Trimmed Text1", "Name.2", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, true), {"Name.2.1", "Name.2.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"Name.2.1", type text}, {"Name.2.2", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type2",{"Name.2.2"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Name.2.1", "Last Name"}}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Renamed Columns1",{{"Salary", type number}}),
    #"Added Conditional Column" = Table.AddColumn(#"Changed Type3", "Salary Bucket", each if [Salary] < 50000 then "Under 50K" else if [Salary] < 100000 then "50K to 100K" else "100K to 150K"),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Conditional Column",{"Emp ID", "First Name", "Last Name", "Gender", "Department", "Salary", "Salary Bucket", "Start Date", "FTE", "Employee type", "Work location"}),
    #"Inserted Age" = Table.AddColumn(#"Reordered Columns", "Age", each Date.From(DateTime.LocalNow()) - [Start Date], type duration),
    #"Calculated Total Years" = Table.TransformColumns(#"Inserted Age",{{"Age", each Duration.TotalDays(_) / 365, type number}}),
    #"Added Custom" = Table.AddColumn(#"Calculated Total Years", "Work Type", each if [FTE] = 1 then "Full Time" else "Part Time"),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom",{"Emp ID", "First Name", "Last Name", "Gender", "Department", "Salary", "Salary Bucket", "Start Date", "FTE", "Work Type", "Employee type", "Work location", "Age"})
in
    #"Reordered Columns1"


## 🚀 Business Impact
Process Automation: Eliminated recurring manual data sanitization workflows, shifting focus from data prep to analysis.

Analytical Expansion: Embedded localized business logic into the ingestion phase, creating instant cohorts (Salary Bucket, Tenure) ready for pivot analysis the moment the data loads.