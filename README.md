# 📊 RFM Customer Segmentation Analysis: Online Retail

This project focuses on analyzing customer purchasing behavior to identify high-value segments and provide actionable marketing strategies. By applying the **RFM (Recency, Frequency, Monetary)** framework, I categorized the customer base into distinct groups to optimize retention and maximize **Lifetime Value (LTV)**.

---
## 🎯 Project Goals
1.  **Define Customer Segments:** Categorize customers into actionable groups (e.g., Champions, Loyal, At-Risk).
2.  **Optimize Marketing Budget:** Identify high-ROI segments to streamline advertising spend.
3.  **Micro-Strategy Dashboard:** Develop a dynamic dashboard for granular, data-driven decision-making.
4.  **Increase Retention:** Implement targeted re-engagement campaigns for segments showing signs of churn.

---

## 💾 Data Source and Schema
The analysis is performed on the **Online Retail Dataset**, which contains all transactions occurring between 01/12/2010 and 09/12/2011, non-store online retail.

* **Source:** [Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail) 
  
* **Key Attributes:** `InvoiceNo`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `UnitPrice`, `CustomerID`, `Country`.

---

## 🛠️ Methodology: The RFM Framework
To segment the customers, I calculated three key metrics:
* **Recency (R):** Days since the last purchase.
* **Frequency (F):** Total number of purchases.
* **Monetary (M):** Total money spent.
---

## 📁 Repository Structure

| File | Description |
| :--- | :--- |
| 🧹 **`DataCleaning.sql`** | SQL script for handling missing values, filtering out returns (negative quantities), and formatting dates. |
| 🔢 **`RFM_Segmentation.sql`** | The core logic using CTEs and `NTILE` functions to score and label customer segments. |
| 📈 **`RFM Analysis Outcomes.pdf`** | A final report summarizing key findings and marketing recommendations. |

---
## 🔗 Live Interactive Dashboard
You can explore the visual analysis and drill down into specific customer segments here:
[**View Looker Studio Dashboard**](https://lookerstudio.google.com/reporting/5802457d-05a9-4b51-b372-235dad678c37)

### 🏗️ Dashboard Architecture
The interactive report is structured to guide users from high-level business health metrics down to specific, actionable customer lists.

| Page | Functionality |
| :--- | :--- |
| 📊 **Executive Performance Summary** | Provides a high-level overview featuring performance scorecards, Top 10 KPIs, and sales trends to monitor business health at a glance. |
| 🧩 **Global Segment Breakdown** | Analyzes the distribution and scale of RFM segments by number of customers and revenue, while clearly defining the scoring thresholds for each category. |
| 🗺️ **Regional Customer Dynamics** | Enables comparative analysis of geographic performance, specifically monitoring Average Order Value (AOV) across segments to identify regional market strengths. |
| 🔬 **The Microscope** | A granular tactical tool designed for micro-segmentation, allowing stakeholders to identify and export precise customer lists for targeted marketing campaigns. |

 <img width="802" height="1149" alt="at a glance" src="https://github.com/user-attachments/assets/f94a92aa-338b-4066-8375-895a8d903e2c" />
 <img width="801" height="1250" alt="global segment breakdown" src="https://github.com/user-attachments/assets/89bf4819-65dd-4ae3-a8f0-b0c2d0cdf7e9" />
<img width="799" height="746" alt="regional  customer dynamics" src="https://github.com/user-attachments/assets/f12e8371-1225-456a-ac63-a8f8e6506b01" />
<img width="799" height="978" alt="the microscope" src="https://github.com/user-attachments/assets/bfbca850-e1a7-45c5-b972-56d25b0ba8a2" />


