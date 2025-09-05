# Netflix Content SQL Analysis

## Project Overview
This project analyzes Netflix content metadata (synthetic dataset included) using SQL and visualizes trends using a Streamlit dashboard. It is designed to demonstrate SQL analytical skills and interactive dashboarding for portfolio presentation.

## Live Demo
*(Add deployed Streamlit app link here after deployment)*

## Dataset
- `dataset/netflix_titles_synthetic.csv` (~8,000 rows, synthetic for demo)
- Schema includes: show_id, type (Movie/TV Show), title, director, cast, country, date_added, release_year, rating, duration, listed_in (genres), description

## SQL Queries
- `sql/queries.sql` contains 15+ queries using grouping, window functions, and text-analysis placeholders to extract insights like top genres, top directors, content added per year, and more.

## Streamlit App
The Streamlit app (`streamlit_app/app.py`) provides:
- KPIs (Total Titles, Movies, TV Shows, Unique Directors)
- Titles added over time chart
- Top 10 countries by content count
- Top genres pie chart
- Top directors table

## Run locally
```bash
git clone https://github.com/saikirankasam2310/Netflix-SQL-Analysis.git
cd Netflix-SQL-Analysis/streamlit_app
pip install -r requirements.txt
streamlit run app.py
```

## Project Structure
```
Netflix-SQL-Analysis/
├── dataset/
│   └── netflix_titles_synthetic.csv
├── sql/
│   └── queries.sql
├── streamlit_app/
│   ├── app.py
│   └── requirements.txt
├── screenshots/
└── README.md
```

## Next Steps
- Deploy the Streamlit app to Streamlit Cloud and add the live link to README.
- Extend SQL queries for deeper analysis (actor-director co-occurrence, genre evolution).
- Add screenshots and insights to the README for portfolio presentation.

---
**Author:** Saikiran Kasam
