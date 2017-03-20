###################################
PREPARE


####################################
$ ssh grieg
$ cd /srvr/YOU
$ source /srvr/YOU/env
$ initdb
$ edit $PGDATA/postgresql.conf
... set unix_socket_directories = 'name of PGDATA directory' ...
... set max_connections = 5 ...
... set listen_addresses = '' ...
$ pg_ctl start -l $PGDATA/log
$ psql -l

$createdb  proj1
$ psql  proj1  -f  /home/cs9311/web/17s1/proj/proj1/mymyunsw.dump
$ psql  proj1
... run some checks to make sure the database is ok

proj1=# \d
... look at the schema ...
proj1=# select * from Students;
... look at the Students table ...
proj1=# select p.unswid,p.name from People p join Students s on (p.id=s.id);
... lookat the names and UNSW ids of all students ...
proj1=# select p.unswid,p.name,s.phone from People p join Staff s on (p.id=s.id);
... look at the names, staff ids, and phone #s of all staff ...
proj1=# select count(*) from Course_Enrolments;
... how many course enrolment records ...
proj1=# select * from dbpop();
... how many records in all tables ...
proj1=# select * from transcript(3197893);
... transcript for student with ID 3197893
...
proj1=# ... etc. etc. etc.
proj1=# \q


$ mkdir  Project1Directory
... make a working directory for Project 1
$ cp  /home/cs9311/web/17s1/proj/proj1/proj1.sql  Project1Directory




##########################################################
project1 question1 

Define a SQL view Q1(unswid,name)that gives all the buildings that have more than 30 rooms. 
Each tuple in the view should contain the following:
the id of the building (Buildings.unswidfield) 
the name of the building (Buildings.namefield)
##########################################################
proj1=# select building,count(*) from rooms group by building having count(building)>30;

                           building | count 
                          ----------+-------
                                112 |    41
                                115 |    47
                                107 |    51
                                121 |    40
                                101 |    39
                                213 |    55
                                117 |    49
                                111 |    56
                                100 |    78
                                116 |    42
                                102 |    35
                                105 |    35
                          (12 rows)
                          
proj1=# select unswid,name from buildings where id in (select building from rooms group by building having count(building)>30);
                             unswid |              name               
                            --------+---------------------------------
                             K17    | Computer Science Building
                             MECH   | Mechanical Engineering Building
                             CHEMSC | Chemical Sciences Building
                             ASB    | Australian School of Business
                             EE     | Electrical Engineering Building
                             MAT    | Mathews Building
                             MB     | Morven Brown Building
                             OMB    | Old Main Building
                             QUAD   | Quadrangle
                             RC     | Red Centre
                             WEB    | Robert Webster Building
                             F      | Building F
                            (12 rows)
      
 proj1=# create view Q1 as select unswid,name from buildings where id in 
        (select building from rooms group by building having count(building)>30);
 
 
 
 
####################################################################################################################
project1 question2

Define a SQL view Q2(name,faculty,phone,starting)which gives the details about 
all of the current Dean of Faculty. Each tuple in the view should contain the following:

his/her name (use the name field from the People table)

the faculty (use the longname field from the OrgUnits table)

his/her phone number (use the phone field from Staff table)

the date when he/she was a ppointed (use the starting field from the Affiliations table)
Since there is some dirty-looking data in the Affiliations table,
you will need to ensure that you return only legitimate Deans of Faculty. Apply the following filters together:

only choose people whose role is exactly ‘Dean’

only choose organisational units whose type is actually ‘Faculty'

Every current Dean has null value in the Affiliations.ending field;;;;;;;;;;;;;;;;;;;;;;;;;;
####################################################################################################################



proj1=# select * from orgunits where utype =1;

  id  | utype |                name                 |                  longname                   | unswid |  phone   |         email         | website |  starting  |   ending   
------+-------+-------------------------------------+---------------------------------------------+--------+----------+-----------------------+---------+------------+------------
    2 |     1 | Board Studies Sci & Math            | Board of Studies in Science and Mathematics | BSSM   |          |                       |         | 1990-01-01 | 2000-01-01
    3 |     1 | Faculty of Life Sciences            | Faculty of Life Sciences                    | LIFE   |          |                       |         | 2000-01-01 | 2005-01-01
   31 |     1 | Faculty of Arts and Social Sciences | Faculty of Arts and Social Sciences         | ARTSC  |          |                       |         | 2000-01-01 | 
   38 |     1 | UNSW Canberra at ADFA               | UNSW Canberra at ADFA                       | UNICL  |          |                       |         | 2000-01-01 | 
   52 |     1 | Faculty of Science                  | Faculty of Science                          | SCI    |          |                       |         | 2000-01-01 | 
   64 |     1 | Faculty of Built Environment        | Faculty of Built Environment                | BLTEN  | 93854799 | fbe@unsw.edu.au       |         | 2000-01-01 | 
   82 |     1 | College of Fine Arts (COFA)         | College of Fine Arts (COFA)                 | COFA   | 93850684 | cofa@unsw.edu.au      |         | 2000-01-01 | 
  112 |     1 | Faculty of Engineering              | Faculty of Engineering                      | ENG    |          |                       |         | 1980-01-01 | 
  164 |     1 | Faculty of Law                      | Faculty of Law                              | LAW    |          |                       |         | 2000-01-01 | 
  183 |     1 | Faculty of Medicine                 | Faculty of Medicine                         | MED    |          |                       |         | 2000-01-01 | 
 1278 |     1 | Australian School of Business       | Australian School of Business               | COM\dM   | 99319500 |                       |         | 2000-01-01 | 
 1519 |     1 | UNSW Asia                           | UNSW Asia                                   | ASIA   |          |                       |         | 2000-01-01 | 
 1597 |     1 | Faculty of AA                       | The Academic Administration Faculty (Test)  |        | 93850000 | wlmok@cse.unsw.edu.au |         | 2000-01-01 | 
 1626 |     1 | BOS                                 | DVC (A) Board of Studies                    |        |          |                       |         | 2000-01-01 | 
(14 rows)


proj1=# select * from staff_roles where name='Dean';
                                    id  | rtype | rclass | name | description 
                                  ------+-------+--------+------+-------------
                                   1286 | A     | A      | Dean | 
                                  (1 row)


proj1=# select * from affiliations where role=1286 and ending IS NULL;

                                    staff   | orgunit | role | isprimary |  starting  | ending 
                                  ----------+---------+------+-----------+------------+--------
                                   50404791 |     112 | 1286 | t         | 2001-01-01 | 
                                   50404791 |    1446 | 1286 | f         | 2001-01-01 | 
                                   50404791 |    1448 | 1286 | f         | 2001-01-01 | 
                                    5034591 |    1567 | 1286 | f         | 2010-03-05 | 
                                    5034591 |     164 | 1286 | t         | 2010-03-05 | 
                                   50280287 |    1450 | 1286 | f         | 2001-01-01 | 
                                   50280287 |      31 | 1286 | t         | 2001-01-01 | 
                                   50405697 |      64 | 1286 | t         | 2010-03-05 | 
                                   50405697 |    1572 | 1286 | f         | 2010-03-08 | 
                                   50405697 |    1573 | 1286 | f         | 2010-03-09 | 
                                   50392143 |    1571 | 1286 | f         | 2010-03-09 | 
                                   50500017 |    1568 | 1286 | f         | 2010-06-07 | 
                                   50500017 |    1569 | 1286 | f         | 2010-06-07 | 
                                   50500017 |      52 | 1286 | t         | 2010-06-07 | 
                                   50392143 |    1570 | 1286 | f         | 2010-03-08 | 
                                   50392143 |     183 | 1286 | t         | 2010-08-12 | 
                                   50404672 |      31 | 1286 | f         | 2012-07-25 | 
                                   50500017 |    1506 | 1286 | f         | 2001-01-01 | 
                                   50509754 |    1278 | 1286 | t         | 2013-02-19 | 
                                    5034580 |      82 | 1286 | t         | 2013-04-01 | 
                                    5034580 |    1575 | 1286 | f         | 2013-04-22 | 
                                  (21 rows)


proj1=# select * from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1);
                                  staff   | orgunit | role | isprimary |  starting  | ending 
                                ----------+---------+------+-----------+------------+--------
                                 50280287 |      31 | 1286 | t         | 2001-01-01 | 
                                 50404672 |      31 | 1286 | f         | 2012-07-25 | 
                                 50500017 |      52 | 1286 | t         | 2010-06-07 | 
                                 50405697 |      64 | 1286 | t         | 2010-03-05 | 
                                  5034580 |      82 | 1286 | t         | 2013-04-01 | 
                                 50404791 |     112 | 1286 | t         | 2001-01-01 | 
                                  5034591 |     164 | 1286 | t         | 2010-03-05 | 
                                 50392143 |     183 | 1286 | t         | 2010-08-12 | 
                                 50509754 |    1278 | 1286 | t         | 2013-02-19 | 
                                (9 rows)




 



Q.name:#select name from people where id in
(select staff from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1));     

Q.faculty:#select longname from orgunits where utype =1 and id in
(select orgunit from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1));      

Q2.phone:#select phone from staff where id in
(select staff from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1));     

Q2.starting:#select starting from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1);



create view test2 as select p.name,o.longname, s.phone, a.starting
from people p, orgunits o, staff s, affiliations a, orgunits o2
where p.id in(select staff from affiliations where role =1286 and ending IS NULL and orgunit in
 (select o2.id from orgunits o2 where o2.utype=1)) 
and o.utype =1 and o.id in
(select orgunit from affiliations where role=1286 and ending IS NULL and orgunit in
(select o2.id from orgunits o2 where o2.utype=1))
and s.id in
(select a.staff from affiliations  where role=1286 and ending IS NULL and orgunit in
(select o2.id from orgunits o2 where o2.utype=1))
and a.role=1286 and a.ending IS NULL and a.orgunit in
(select o2.id from orgunits o2 where o2.utype=1);

create view test3 as select p.name, a.starting
from people p, affiliations a, orgunits o2
where p.id in
(select a.staff from affiliations a where a.role =1286 and a.ending IS NULL and a.orgunit in
(select o2.id from orgunits o2 where o2.utype=1));


//
create view test2 as select p.name,o.longname
from people p, orgunits o
where p.id in(select staff from affiliations where role =1286 and ending IS NULL and orgunit in
 (select id from orgunits where utype=1)) 
and o.utype =1 and o.id in
(select orgunit from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1));
//


(select p.name
from people p
where p.id in(select staff from affiliations where role =1286 and ending IS NULL and orgunit in
 (select id from orgunits where utype=1)) )
 INTERSECT
 (select o.longname
from orgunits o
where o.utype =1 and o.id in
(select orgunit from affiliations where role=1286 and ending IS NULL and orgunit in
(select id from orgunits where utype=1)) );
