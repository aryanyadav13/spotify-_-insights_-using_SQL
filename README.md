# spotify-_-insights_-using_SQL
# 🎵 Spotify SQL Data Analysis

![Spotify Analytics](https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=900&auto=format&fit=crop&q=80)

> A comprehensive SQL-based analysis of Spotify track data — exploring streams, engagement metrics, audio features, and platform comparisons.

---

## 📁 Project Overview

This project performs exploratory and analytical queries on a Spotify dataset using **PostgreSQL**. The dataset includes metadata and audio features for tracks, albums, and artists — along with YouTube engagement metrics like views, likes, and comments.

---

## 🗄️ Dataset Schema

The `spotify` table contains the following columns:

| Column | Type | Description |
|---|---|---|
| `artist` | VARCHAR | Artist name |
| `track` | VARCHAR | Track title |
| `album` | VARCHAR | Album name |
| `album_type` | VARCHAR | Type: album / single / compilation |
| `danceability` | FLOAT | How suitable for dancing (0–1) |
| `energy` | FLOAT | Intensity and activity level (0–1) |
| `loudness` | FLOAT | Overall loudness in dB |
| `speechiness` | FLOAT | Presence of spoken words (0–1) |
| `acousticness` | FLOAT | Acoustic confidence score (0–1) |
| `instrumentalness` | FLOAT | Predicts no vocals (0–1) |
| `liveness` | FLOAT | Presence of live audience (0–1) |
| `valence` | FLOAT | Musical positiveness (0–1) |
| `tempo` | FLOAT | Beats per minute |
| `duration_min` | FLOAT | Track duration in minutes |
| `views` | FLOAT | YouTube views |
| `likes` | BIGINT | YouTube likes |
| `comments` | BIGINT | YouTube comments |
| `licensed` | BOOLEAN | Whether track is licensed |
| `official_video` | BOOLEAN | Whether official video exists |
| `stream` | BIGINT | Number of streams |
| `most_played_on` | VARCHAR | Platform: Spotify or Youtube |

---

## 🔍 Analysis Questions Covered

### 🟢 Basic Queries
- Retrieve tracks with more than 1 billion streams
- List all albums with their respective artists
- Get total comments for licensed tracks
- Find tracks belonging to `single` album type
- Count total tracks per artist

### 🟡 Intermediate Queries
- Calculate average danceability per album
- Find top 5 tracks by highest energy
- List tracks with views and likes where `official_video = TRUE`
- Calculate total views per album

### 🔴 Advanced Queries
- Find tracks streamed more on **Spotify than YouTube** (using subquery + CASE + COALESCE)
- Top 3 most-viewed tracks per artist using **window functions** (`DENSE_RANK`)
- Tracks where liveness score is **above average** (using subquery)
- Energy difference (max–min) per album using **CTE**

---

## 🧠 Key SQL Concepts Used

| Concept | Usage |
|---|---|
| `GROUP BY` + Aggregates | Count, Sum, Avg per artist/album |
| `CASE` + `COALESCE` | Platform comparison logic |
| Subqueries | Filtering by average values |
| Window Functions | `DENSE_RANK() OVER (PARTITION BY ...)` |
| CTEs (`WITH` clause) | Energy difference calculation |
| `BOOLEAN` filtering | Licensed and official video queries |

---

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 13+ (or any SQL-compatible engine)
- A Spotify dataset CSV loaded into the `spotify` table

### Setup

```sql
-- Step 1: Create the table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    ...
);

-- Step 2: Import your CSV data
-- Step 3: Run the analysis queries from spotify_analysis.sql
```

---

## 📊 Sample Query — Top 3 Tracks per Artist

```sql
WITH ranking_artist AS (
    SELECT
        artist,
        track,
        SUM(views) AS most_viewed,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY 1, 2
)
SELECT *
FROM ranking_artist
WHERE rank <= 3;
```

---

## 📈 Sample Query — Spotify vs YouTube Streams

```sql
SELECT * FROM (
    SELECT
        track,
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY 1
) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0;
```

---

## 📂 File Structure

```
📦 spotify-sql-analysis
 ┣ 📄 spotify_analysis.sql   ← All SQL queries
 ┗ 📄 README.md              ← Project documentation
```

---

## 🙌 Acknowledgements

- Dataset inspired by publicly available Spotify + YouTube track data
- Audio feature definitions from the [Spotify Web API Docs](https://developer.spotify.com/documentation/web-api)

---

*Built with 🎧 and SQL*
