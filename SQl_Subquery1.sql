-- Database of movie-rating website
/* Delete the tables if they already exist */
create database if not exists movie_DB;
use movie_DB;
drop table if exists Movie;
drop table if exists Reviewer;
drop table if exists Rating;

/* Create the schema for our tables */
create table Movie(mID int, title text, year int, director text);
create table Reviewer(rID int, name text);
create table Rating(rID int, mID int, stars int, ratingDate date);

/* Populate the tables with our data */
insert into Movie values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into Movie values(102, 'Star Wars', 1977, 'George Lucas');
insert into Movie values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into Movie values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into Movie values(105, 'Titanic', 1997, 'James Cameron');
insert into Movie values(106, 'Snow White', 1937, null);
insert into Movie values(107, 'Avatar', 2009, 'James Cameron');
insert into Movie values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into Reviewer values(201, 'Sarah Martinez');
insert into Reviewer values(202, 'Daniel Lewis');
insert into Reviewer values(203, 'Brittany Harris');
insert into Reviewer values(204, 'Mike Anderson');
insert into Reviewer values(205, 'Chris Jackson');
insert into Reviewer values(206, 'Elizabeth Thomas');
insert into Reviewer values(207, 'James Cameron');
insert into Reviewer values(208, 'Ashley White');

insert into Rating values(201, 101, 2, '2011-01-22');
insert into Rating values(201, 101, 4, '2011-01-27');
insert into Rating values(202, 106, 4, null);
insert into Rating values(203, 103, 2, '2011-01-20');
insert into Rating values(203, 108, 4, '2011-01-12');
insert into Rating values(203, 108, 2, '2011-01-30');
insert into Rating values(204, 101, 3, '2011-01-09');
insert into Rating values(205, 103, 3, '2011-01-27');
insert into Rating values(205, 104, 2, '2011-01-22');
insert into Rating values(205, 108, 4, null);
insert into Rating values(206, 107, 3, '2011-01-15');
insert into Rating values(206, 106, 5, '2011-01-19');
insert into Rating values(207, 107, 5, '2011-01-20');
insert into Rating values(208, 104, 3, '2011-01-02');

##################################################################
-- find minimum rating and maximum rating earned by the moviews directed by 'Steven Spielberg'.
	 
	       
        
        select title,director,max(stars),min(stars)
        from movie join rating using (mid)
        where director in (select director from movie where director= 'steven spielberg')
        group by title;
     

-- 1. Find the titles of all movies that have no ratings. 

	select title from movie
    where mid not in (select mid from rating );

-- 2. Find the titles of all movies not reviewed by Chris Jackson. 

	select title 
		from movie
        where mid not in (select mid from rating
        where rid in (select rid from reviewer where name  like 'Chris Jackson'));
        
		
-- 3. find director name, movie title of the movies reviewed by reviewer with name ending with 'son'

	select Director,Title 
		from movie
        where mid in (select mid from rating
        where rid in (select rid from reviewer where name  like '%son%'));
    
    
-- 4. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

	select name,mid,title,stars
		from (select * from rating
        where stars in (select min(stars) from rating)) as m
        join movie  using(mid)
        join reviewer  using (rid); 


-- 5. Display movie name, reviewer name rated more than avg ratings of movies reviewed before '20-01-2011'

	select title,name 
		from movie join rating
        using (mid) join reviewer
        using (rid)
        where stars>(select avg(stars) from rating where ratingDate<'2011-01-20');
        
        
        
-- 6. Display title of the movies and reviewer name earning lower ratings than any of the average ratings realeased in the year 1975-1985
       
       select title,name,stars 
		from movie join rating
        using (mid) join reviewer
        using (rid)
        where stars< any(select avg(stars) from rating 
        join movie using(mid) where year between 1975 and 1985
        group by mid);
        
       
       
-- 7 . Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

	
-- 8. Find the names of all reviewers who have contributed three or more ratings.

	     
     SELECT name from reviewer rw 
where (
		select count(*) from rating r 
		where r.rid = rw.rid) >=3;

-- 9. At least 3 ratings to different movies

	SELECT Name from reviewer rw 
where (
		select count(distinct(mid)) from rating r 
		where r.rid = rw.rid) >=3;

-- 10. some of the director worked as reviewer also . Dispaly their names and the movies they directed 

	select Director,Mid,Title,Rid,Name
		from movie left join rating
        using(mid) join reviewer
        using (rid)
        where name in (select director from movie);
        
        
#using where exist


## 11. find out the director who reviewed his own movie and rating given by him

		select Director,Mid,Title,Stars,Rid,Name
		from movie left join rating
        using(mid) join reviewer
        using (rid)
        where exists(select director from movie where director=name);

-- 12. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.

        select Director,Title
        from movie m1
        where exists(select m2.director from movie m2 where m2.director=m1.director 
        group by director
        having count(director)>1)
        order by director,title ;
-- 13. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.

		select Title,Avg(Stars)
			from movie join rating
            using (mid)
            group by title
            having avg(stars) = (select max(Avg_stars)
								from (select Title,avg(stars) as Avg_Stars
                                from movie join rating 
                                using(mid) 
                                group by mid) as Rating_Avgs);
                     
                     
		
        select Title,max(Avg_Stars)
        from(
        select Title,avg(stars) as Avg_stars
			from movie join rating
            using (mid)
            group by title)as AvgStars;

-- 14. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.

-- 15. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.


		delete from rating
        where mid in (select mid from movie 
		where year <1970 or year>2000) and stars<4;
        
	select * from rating;