# Stress Level Analysis — SQL Capstone Project

## 📌 Overview
This project analyzes a dataset of 5,000 employee records to uncover patterns between stress levels and factors such as stress sources, physical/emotional symptoms, coping mechanisms, sleep quality, and demographics. SQL Server Management Studio (SSMS) was used to clean and explore the data, with the cleaned dataset brought into Excel for visualization.

## 🎯 Business Problem
Organizations often struggle to identify what's driving employee stress and which interventions actually help. This project explores: What factors are most strongly associated with higher stress levels, and which coping mechanisms appear most effective?

## 📊 Dataset
- Size: 5,000 records
- Description: Each record includes demographic information (age, gender), stress source, physical and emotional symptoms, coping mechanism, stress duration, severity, sleep quality, mood, heart rate, cortisol level, and an overall stress level score.

## 🛠️ Tools Used
- SQL Server Management Studio (SSMS) — data cleaning, exploration, and querying
- Excel — pivot tables and charts for visualization

## 🔍 Approach
1. Cleaned and explored the raw dataset in SSMS (checked for duplicates, nulls, and data type issues)
2. Wrote SQL queries to group and aggregate data by stress source, symptoms, coping mechanism, severity, and demographics
3. Exported the cleaned data to Excel and built pivot tables and charts to visualize the findings

## 💡 Key Findings
- Work, financial issues, and family issues were the most common stress sources reported by employees
- Fatigue, insomnia, and back pain were the most frequently reported physical symptoms
- Exercise, meditation, and food-related coping were the most commonly used strategies, while walking and gardening were associated with the lowest average stress scores
- Stress severity was roughly split across the workforce: about 40% mild, 40% moderate, and 20% severe
- Employees aged 17-25 reported the highest average stress level scores, while older age groups reported comparatively lower scores.
- Check the documentation files for more key findings and recommendations.

## 📁 Repository Structure
Stress-Level-Analysis---SQL-capstone-project/
├── README.md
├── queries/        → SQL scripts used for data cleaning and analysis
├── data/           → dataset (or note on source)
└── visuals/        → Excel file with pivot tables, charts, and screenshots

## 🖼️ Dashboard Preview

<img width="975" height="481" alt="image" src="https://github.com/user-attachments/assets/fa09b168-b9b2-4620-b6b6-da5fdbe78577" />
