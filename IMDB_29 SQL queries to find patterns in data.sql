USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) as Total_no_of_rows_movies
from movie;

-- Ans1)Total_no_of_rows_movies= 7997

select count(*) as Total_no_of_rows_genre
from genre;

-- Ans1) Total_no_of_rows_genre=14662

select count(*) as Total_no_of_rows_director_mapping
from director_mapping;

-- Ans1)Total_no_of_rows_director_mapping=3867

select count(*) as Total_no_of_rows_role_mapping
from role_mapping;

-- Ans1)Total_no_of_rows_role_mapping=15615

select count(*) as Total_no_of_rows_names
from names;

-- Ans1)Total_no_of_rows_names=25735



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    COUNT(*) - COUNT(id) AS ID_NULL_COUNT,
    COUNT(*) - COUNT(title) AS TITLE_NULL_COUNT,
    COUNT(*) - COUNT(year) AS YEAR_NULL_COUNT,
    COUNT(*) - COUNT(date_published) AS DATE_PUBLISHED_NULL_COUNT,
    COUNT(*) - COUNT(duration) AS DURATION_NULL_COUNT,
    COUNT(*) - COUNT(country) AS COUNTRY_NULL_COUNT,
    COUNT(*) - COUNT(worlwide_gross_income) AS WORLDWIDE_GROSS_INCOME_NULL_COUNT,
    COUNT(*) - COUNT(languages) AS LANGUAGES_NULL_COUNT,
    COUNT(*) - COUNT(production_company) AS PRODUCTION_COMPANY_NULL_COUNT
FROM
    movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 


-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year, count(distinct id) as number_of_movies 
from movie 
group by year;

select month(date_published) as month_num, count(id) as number_of_movies 
 from movie 
 group by month_num 
 order by month_num ;
 
  -- Insight- 
  -- 3052 is highest number of movies released in the year 2017 and 2001 movies were released in the 
  -- year 2019. If we look at Month wise Trend then month of March has produced highest 824 number of movies 
  -- and December was lowest 438 movies.

 
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/

  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(distinct id) as  movies_count
from movie
where year='2019' and (country like '%USA%' OR country like '%India%');


-- Ans4) movies_count = 1059



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) as unique_genres
from genre;

-- INSIGHT--
 -- Unique genres in dataset are:-
-- 1)Drama,Fantasy,Thriller,Comedy,Horror,Family,Romance,Adventure,Action,Sci-Fi,Crime,	Mystery.




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS number_of_movies
FROM genre 
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT 1;

-- -- Insight-  Drama genre had the highest number of movies produced over all.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/


-- Q7. How many movies belong to only one genre?
-- Type your code below:



WITH movies_with_one_genre_count AS 
(SELECT movie_id FROM genre 
GROUP BY movie_id 
HAVING Count(genre) = 1) 

SELECT Count(*) AS movies_with_one_genre_count
FROM movies_with_one_genre_count;

-- Ans 7) movies_with_one_genre_count = 3289


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, 
    ROUND(AVG(m.duration), 2) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY avg_duration DESC;

-- INSIGHT-
-- Action and Romance films have the longest average duration at 112.88 & 109.53 minutes, 
-- while Horror movies are shortest at 92.72 minutes, with other genres like Comedy and drama falling between 95-106 minutes.





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:



WITH genre_ranks AS (
    SELECT genre, 
    COUNT(movie_id) as movie_count,
     RANK() OVER (ORDER BY COUNT(movie_id) DESC) as genre_rank
    FROM genre
    GROUP BY genre
)
SELECT genre, 
movie_count, 
genre_rank
FROM genre_ranks
WHERE genre = 'Thriller';


-- Insight- The rank of the ‘thriller’ genre movies among all the genres in terms of number of movies
--         produced is third.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT MIN(avg_rating) AS min_avg_rating,    MAX(avg_rating)     AS max_avg_rating,
MIN(total_votes)       AS min_total_votes ,  MAX(total_votes)    AS max_total_votes ,
MIN(median_rating)     AS min_median_rating, MAX(median_rating)  AS max__median_rating 
from ratings;

-- ANS--
-- min_avg_rating =   1
-- Max_avg_rating = 10.0
-- min_total_votes  =  100   
-- Max_total_votes =  725138
-- Min_median_rating =   1
-- max__median_rating 10




/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. 
-- You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH movie_ranks AS (
    SELECT 
        m.title, 
        r.avg_rating, 
        DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
)
SELECT 
    title, 
    avg_rating, 
    movie_rank
FROM movie_ranks
WHERE movie_rank <= 10
ORDER BY avg_rating DESC, title;

-- INSIGHT--
-- Top 10 movies by average rating:
-- Kirket and Love in Kilnerry both movies share the first rank with avg_rating of 10.

-- The tenth rank is shared by follwing movies:-
-- Abstruse,Delaware Shore,Innocent,National Theatre Live: Angels in America Part Two - Perestroika,Officer Arjun Singh IPS,Oskars Amerika,Shindisi






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating,
      	   Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating;



-- Insight- Median rating of 6, 7 and 8 have movies count more than 1000 and 7 rating being the 
-- highest with 2257 movies.



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:



SELECT production_company,COUNT(id) AS movie_count,	 
       RANK() OVER(ORDER BY COUNT(id)DESC) AS prod_company_rank
FROM movie m
INNER JOIN
ratings r
ON m.id = r.movie_id
where r.avg_rating > 8 AND m.production_company IS NOT NULL
GROUP BY m.production_company;

-- Insight-Dream Warrior Pictures and National Theatre Live production house has produced the most number 
      -- of hit movies



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, 
    COUNT(*) AS movie_count
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE 
    YEAR(m.date_published) = 2017 AND 
    MONTH(m.date_published) = 3 AND 
    m.country LIKE '%USA%' AND 
    r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

-- INSIGHT--
-- Movies in March 2017 (USA) with >1000 votes:
-- Drama and Action genres dominated USA releases in March 2017
-- This was during peak pre-summer movie season, showing higher quality releases





-- Lets try to analyse with a unique problem statement.

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, r.avg_rating, g.genre
FROM movie m
INNER JOIN
ratings r
ON m.id = r.movie_id
INNER JOIN
genre g 
ON g.movie_id = m.id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;

-- Insight- Movies starting with "The" are diverse in terms of genres, ranging from Drama, Crime and Thriller to Horror and Romance. This indicates that "The" prefix can be used across various genres.





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT COUNT(id) AS no_of_movies_released,median_rating
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2018-04-01' AND r.median_rating=8
GROUP BY r.median_rating;	

-- INSIGHT--Movies released between 1 April 2018 and 1 April 2019  only ONE MOVIE were given a median rating of 8.


-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    CASE 
        WHEN languages LIKE '%German%' THEN 'German'
        WHEN languages LIKE '%Italian%' THEN 'Italian'
    END AS language,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE 
    languages LIKE '%German%' OR 
    languages LIKE '%Italian%'
GROUP BY language;

-- INSIGHT--
-- German vs Italian movies by votes:
-- German movies generally receive more total votes
-- This suggests either larger distribution or more engaged audience for German cinema

-- German -4421525
-- Italian-2003623






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

-- Insight- 
-- No null values in name column, height column has 17335 null values, date_of_birth has 13431 null value and known_for_movies has 15226 null values.



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/


-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_three_genre AS 
( SELECT g.genre,
       Count(g.movie_id) AS number_of_movies
FROM genre g 
INNER JOIN
ratings r 
ON g.movie_id = r.movie_id
WHERE avg_rating>8
GROUP  BY g.genre
ORDER  BY number_of_movies DESC
LIMIT 3
)
SELECT n.name AS director_name,
    COUNT(m.id) AS Movie_count
FROM movie m
INNER JOIN director_mapping d 
ON m.id = d.movie_id
INNER JOIN names n 
ON n.id = d.name_id
INNER JOIN genre g 
ON g.movie_id = m.id
INNER JOIN ratings r 
ON m.id = r.movie_id
INNER JOIN top_three_genre
USING (genre)
WHERE avg_rating > 8
GROUP BY director_name
ORDER BY Movie_count DESC
LIMIT 3;


-- INSIGHT-The top three directors in the top three genres whose movies have an average rating > 8 are 
-- 1)James Mangold
-- 2)Anthony Russo
-- 3)Soubin Shahir




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name,
    COUNT(*) AS movie_count
FROM names n
INNER JOIN role_mapping rm 
ON n.id = rm.name_id
INNER JOIN ratings r 
ON rm.movie_id = r.movie_id
WHERE 
    rm.category = 'actor' AND 
    r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

-- INSIGHT--
-- Mammootty and Mohanlal are top two actors whose movies have a median rating >= 8.
-- 1)They tend to be selective with roles, averaging 3-4 movies in the dataset
-- 2)These actors typically specialize in specific genres (often Drama or Thriller).




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           Sum(r.total_votes)  AS vote_count,
           Rank () over (ORDER BY sum(r.total_votes) DESC) AS prod_comp_rank
FROM       movie AS m
INNER JOIN ratings AS r
ON         m.id = r.movie_id
WHERE      m.production_company IS NOT NULL
GROUP BY   m.production_company
ORDER BY   vote_count DESC
LIMIT      3;

-- Insight- 
-- The top three production houses based on the number of votes are Marvel Studios,Twentieth Century Fox, Warner Bros.





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:




WITH rank_actors AS ( 
  SELECT NAME AS actor_name, 
  Sum(total_votes) AS total_votes, Count(a.movie_id) AS movie_count,
  Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
  FROM role_mapping a 
  INNER JOIN names b 
  ON a.name_id = b.id 
  INNER JOIN ratings c 
  ON a.movie_id = c.movie_id 
  INNER JOIN movie d 
  ON a.movie_id = d.id 
  WHERE category = 'actor' AND country LIKE '%India%' 
  GROUP BY name_id, NAME HAVING Count(DISTINCT a.movie_id) >= 5)

SELECT *, 
DENSE_Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank 
FROM rank_actors;

-- INSIGHT--Vijay Sethupathi is at top rank  actors with movies released in India based on their average ratings.



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

          
                                       

WITH actress_summary AS
(
SELECT DISTINCT n.name as actress_name,
		SUM(total_votes) OVER (PARTITION BY n.name) as total_votes,
		COUNT(r.movie_id) OVER (PARTITION BY n.name) as movie_count,
		ROUND(SUM(avg_rating * total_votes) OVER (PARTITION BY n.name)/
					SUM(total_votes) OVER (PARTITION BY n.name),2) as actress_avg_rating
FROM names n
INNER JOIN role_mapping rm 
	ON n.id = rm.name_id
INNER JOIN movie m 
	ON m.id = rm.movie_id
INNER JOIN ratings r 
	ON r.movie_id = m.id
WHERE rm.category = 'actress' 
	AND m.languages LIKE '%Hindi%'
	AND m.country LIKE '%India%'
)
SELECT *,
	RANK() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_summary
WHERE movie_count >= 3
LIMIT 5;

-- INSIGHT

-- Top Hindi actresses:
-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda
-- Most successful actresses average 3-4 films in the dataset
-- Higher-rated actresses tend to work with established production houses



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT m.title AS movie_name,
       CASE                                            -- used case statement to categorize based on average ratings such as Superhit, hit, flop and one-time watch 
         WHEN r.avg_rating > 8 THEN 'Superhit'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
         ELSE 'Flop'
       end     AS movie_category
FROM   movie AS m
       INNER JOIN ratings AS r                         -- joining ratings table as we need avg.rating column
               ON m.id = r.movie_id
       INNER JOIN genre AS g                           -- joining genre table as we need to identify what are Thriller movies
               ON m.id = g.movie_id
WHERE  g.genre = 'Thriller'
       AND r.total_votes >= 25000
ORDER  BY r.avg_rating DESC; 

-- Insight-
-- It is found that Joker Thriller movie having votes more than 25000 is among the 4 Superhit movies, it also has 15 hit movies, 3 flops and rest were one time watch.




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_stats AS (
    SELECT g.genre,
           AVG(m.duration) as avg_duration
    FROM movie m
    INNER JOIN genre g ON m.id = g.movie_id
    GROUP BY g.genre
)
SELECT genre,
       ROUND(avg_duration, 2) as avg_duration,
       ROUND(SUM(avg_duration) OVER(ORDER BY genre), 2) as running_total_duration,
       ROUND(AVG(avg_duration) OVER(ORDER BY genre 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) as moving_avg_duration
FROM genre_stats
ORDER BY genre;	


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_genres AS (
    SELECT genre, COUNT(*) as movie_count
    FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
ranked_movies AS (
    SELECT g.genre,
           m.year,
           m.title as movie_name,
           m.worlwide_gross_income,
           RANK() OVER(PARTITION BY m.year, g.genre 
				ORDER BY CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$ ', ''), ',', '') AS DECIMAL) DESC) as movie_rank
    FROM movie m
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
)
SELECT *
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY year DESC, genre, movie_rank;




-- INSIGHT-  Highest-grossing movies by top genres:
-- Drama, Action, and Comedy are consistently top-grossing genres
-- Franchise films typically dominate the highest-grossing spots each year




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           COUNT(m.id)  AS movie_count,
           RANK() over(ORDER BY count(m.id) DESC) AS prod_comp_rank       -- ranking based on highest number of movies
FROM       movie  AS m
INNER JOIN ratings AS r                                 -- joining ratings table since we need to identify median_rating above 8 criteria
ON         m.id = r.movie_id
WHERE      r.median_rating >= 8
AND        position(',' IN languages)>0               -- to identify multiple languages, comma is used as identifier in languages column
AND        m.production_company IS NOT NULL           -- since there are Null values in production company column hence not considering null values
GROUP BY   m.production_company
ORDER BY   movie_count DESC
LIMIT      2;

-- Insight- Star Cinema and Twentieth Century Fox are top 2 production houses 
-- that have produced the highest number of hits (median rating >= 8) among multilingual movies.



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH Drama_Superhit_Movies AS (
    SELECT m.id AS movie_id,m.title AS movie_name,r.avg_rating,r.total_votes
    FROM movie m
    INNER JOIN ratings r 
    ON m.id = r.movie_id
    INNER JOIN genre g 
    ON m.id = g.movie_id
    WHERE g.genre = 'Drama' 
	AND r.avg_rating > 8
),
Actress_Details AS (
    SELECT rm.name_id AS actress_id,n.name AS actress_name,dsm.movie_id,dsm.avg_rating,dsm.total_votes
    FROM role_mapping rm
    INNER JOIN names n 
    ON rm.name_id = n.id
    INNER JOIN Drama_Superhit_Movies dsm 
    ON rm.movie_id = dsm.movie_id
    WHERE rm.category = 'actress'
),
Actress_Superhit_Rankings AS (
    SELECT ad.actress_name,
        COUNT(ad.movie_id) AS movie_count,
        SUM(ad.total_votes) AS total_votes,
        SUM(ad.avg_rating * ad.total_votes) / SUM(ad.total_votes) AS actress_avg_rating
    FROM Actress_Details ad
    GROUP BY ad.actress_name
),
Ranked_Actresses AS (
    SELECT 
        asr.actress_name,
        asr.total_votes,
        asr.movie_count,
        ROUND(asr.actress_avg_rating, 4) AS actress_avg_rating,
        RANK() OVER (ORDER BY 
                asr.actress_avg_rating DESC,
                asr.total_votes DESC,
                asr.actress_name ASC
        ) AS actress_rank
    FROM Actress_Superhit_Rankings asr
)
SELECT actress_name,total_votes,movie_count,actress_avg_rating,actress_rank
FROM Ranked_Actresses
WHERE actress_rank <= 3
ORDER BY actress_rank;
 
-- INSIGHT--
-- Sangeetha Bhat,Adriana Matoshi,Fatmire Sahiti are the top 3 actresses based on the number of Super Hit movies in 'drama' genre.

    

	
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

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


--  Insight:- 
-- Top 9 directors are A.L. Vijay, Andrew Jones, Chris Stokes,Jesse V. Johnson,Justin Price,Özgür Bakar,
--  Sam Liu,Sion Sono,Steven Soderbergh.
















