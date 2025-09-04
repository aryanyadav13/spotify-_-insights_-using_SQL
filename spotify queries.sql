-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify;
select count(*) from spotify;


-- 15 Practice Questions

--Retrieve the names of all tracks that have more than 1 billion streams.
select 
track, stream
from spotify
where stream > 1000000000

--List all albums along with their respective artists.

select 
album, artist
from spotify
order by album , artist

--Get the total number of comments for tracks where licensed = TRUE.

select
sum(comments) as total_comments
from spotify
where 
    licensed = 'true'

	
--Find all tracks that belong to the album type single.
select *
from spotify
where album_type = 'single'

--Count the total number of tracks by each artist.
select
artist, count(track) as total_tracks
from spotify
group by 1
order by 2 desc



--Calculate the average danceability of tracks in each album.
select 
album,
avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc




--Find the top 5 tracks with the highest energy values.
select
track,
max(energy) as highest_energy
from spotify
group by 1
order by 2 desc
limit 5

--List all tracks along with their views and likes where official_video = TRUE.

select 
track,
sum(views) as total_views,
sum(likes) as  total_likes
from spotify
group by 1
order by 2 desc 
limit 5




--For each album, calculate the total views of all associated tracks.
select 
album , track,
sum(views) as total_views
from spotify
group by 1,2
order by 3 desc



--Retrieve the track names that have been streamed on Spotify more than YouTube.se
 select * from (select 
track,
coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_Youtube,
coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_Spotify
from spotify
group by 1
)as t1


where 
  streamed_on_Spotify > streamed_on_Youtube
  and 
  streamed_on_Youtube <> 0




--Find the top 3 most-viewed tracks for each artist using window functions.

select* from spotify

with cte as (select
artist ,
track,
sum(views) as total_views,
dense_rank() over(partition by artist order by sum(views) desc ) as rank 
from spotify
group by 1,2
order by 1,3 desc)

select 
* from cte
where rank <= 3






--Write a query to find tracks where the liveness score is above the average.
select 
track,
artist
from spotify
where liveness > (select avg(liveness) from spotify)


--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


with a1 as(
select
album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by 1
)

select 
album,
highest_energy - lowest_energy as energy_diff
from a1
order by 2 desc

















































