Here is one of most complex queries i wrote in this project



--  Get the following details for top 9 directors (based on number of movies)
--  Here i also evaluated average number of days taken by each director between two consecutive movies  (avg_inter_movie_days)
  

    WITH director_names              -- this cte is used to find director names and other relevant stats by joining director mapping table with names table
     AS (SELECT n.id AS director_id,
                n.NAME AS director_name,
                dm.movie_id AS movie_id
         FROM   director_mapping AS dm
                INNER JOIN names n
				ON n.id = dm.name_id),
     cte_next_date                     -- this cte is used to find director's movie date published and the next date published in one row details 
     AS (SELECT dn.director_id,
                dn.director_name,
                m.id,
                m.date_published,
                m.duration,
                LEAD (date_published, 1) OVER (partition BY director_name ORDER BY date_published ASC) AS next_date_published
         FROM   movie AS m
		 INNER JOIN director_names AS dn
		 ON m.id = dn.movie_id),
     cte_movie_director_rating         -- this cte is used to combine ratings table with previous CTE to find average inter movie days
     AS (SELECT cnd.director_id,
                cnd.director_name,
                Count(cnd.id) AS number_of_movies,
                Round(Avg(Datediff(cnd.next_date_published,cnd.date_published)), 0) AS avg_inter_movie_days,
                Round(Avg(r.avg_rating), 2) AS avg_rating,
                Sum(r.total_votes) AS total_votes,
                Min(r.avg_rating) AS min_rating,
                Max(r.avg_rating) AS max_rating,
                Sum(cnd.duration) AS total_duration,
                ROW_NUMBER () OVER (ORDER BY Count(cnd.id) DESC) AS rnk    
         FROM   cte_next_date AS cnd
                INNER JOIN ratings r
                        ON cnd.id = r.movie_id
         GROUP  BY director_id,
                   director_name
         ORDER  BY number_of_movies DESC)

SELECT director_id,                  -- finally, this part of query will find top 9 directors insight ranking based on highest number of movies
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   cte_movie_director_rating
WHERE  rnk <= 9; 




------------------------------------------------------------------------------

