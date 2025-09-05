import streamlit as st
import pandas as pd
import plotly.express as px

# ---------------------- PAGE CONFIG ----------------------
st.set_page_config(page_title='Netflix Content Analysis', layout='wide')
st.title('🎬 Netflix Content - SQL Analysis (Interactive)')
st.markdown('Upload `netflix_titles_synthetic.csv` or use the included dataset to explore content trends.')

# ---------------------- LOAD DATA ------------------------
@st.cache_data
def load_data(path):
    df = pd.read_csv(path, parse_dates=['date_added'])
    return df

uploaded = st.file_uploader('Upload CSV (optional)', type=['csv'])
if uploaded:
    df = load_data(uploaded)
else:
    df = load_data('dataset/netflix_titles_synthetic.csv')

# ---------------------- CLEAN DATA ------------------------
df['YearAdded'] = df['date_added'].dt.year
df['ReleaseYear'] = df['release_year']

# ---------------------- KPIs ------------------------
total_titles = len(df)
movies = df[df['type'] == 'Movie'].shape[0]
tv_shows = df[df['type'] == 'TV Show'].shape[0]
unique_directors = df['director'].nunique()

c1, c2, c3, c4 = st.columns(4)
c1.metric('Total Titles', f'{total_titles:,}')
c2.metric('Movies', f'{movies:,}')
c3.metric('TV Shows', f'{tv_shows:,}')
c4.metric('Unique Directors', f'{unique_directors:,}')

st.markdown('---')

# ---------------------- TITLES ADDED OVER TIME ------------------------
added_time = df.groupby('YearAdded').size().reset_index(name='added')
fig1 = px.line(added_time, x='YearAdded', y='added', title='Titles Added by Year')
st.plotly_chart(fig1, use_container_width=True)

# ---------------------- TOP COUNTRIES ------------------------
top_countries = (
    df['country']
    .dropna()
    .value_counts()
    .head(10)
    .reset_index()
)

top_countries.columns = ['Country', 'ContentCount']

fig2 = px.bar(
    top_countries,
    x='Country',
    y='ContentCount',
    title='Top 10 Countries by Content Count',
    color='ContentCount',
    color_continuous_scale='reds'
)
st.plotly_chart(fig2, use_container_width=True)

# ---------------------- TOP GENRES ------------------------
genres_series = df['listed_in'].str.split(', ').explode().dropna()
top_genres = genres_series.value_counts().head(10).reset_index()
top_genres.columns = ['Genre', 'GenreCount']

fig3 = px.pie(
    top_genres,
    names='Genre',
    values='GenreCount',
    title='Top 10 Genres'
)
st.plotly_chart(fig3, use_container_width=True)

# ---------------------- TOP DIRECTORS ------------------------
top_dirs = (
    df['director']
    .dropna()
    .value_counts()
    .head(15)
    .reset_index()
)
top_dirs.columns = ['Director', 'TitleCount']

st.subheader('Top 15 Directors by Title Count')
st.dataframe(top_dirs)

# ---------------------- NOTES ------------------------
st.markdown('---')
st.markdown('**Notes:** Use the SQL queries in `sql/queries.sql` to run server-side aggregations and power dashboards.')
