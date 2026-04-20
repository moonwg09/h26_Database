
판매원 테이블
Salesperson(name, age, salary)
고객 테이블
Customer(name, city, industrytype)
주문 테이블
Order(number, custname, salesperson, amount)-- 컬럼 설명
name         -- 판매원/고객 이름
age          -- 판매원 나이
salary       -- 판매원 급여
city         -- 고객 거주 도시
industrytype -- 고객 직업
number       -- 주문번호
custname     -- 주문 고객 이름
salesperson  -- 담당 판매원 이름
amount       -- 주문 금액

문제 1. 
모든 판매원의 이름, 나이, 급여를 보여주는 뷰 v_salesperson_info를 작성하시오.
create view v_salesperson_info as
    select name, age, salary
    from Salesperson


문제 2. 
급여가 10,000원 이상인 판매원의 이름과 급여를 보여주는 읽기 전용 뷰 v_high_salary_sp를 작성하시오.
create view v_high_salary_sp as
    select name, salary
    from Salesperson
    where salary >= 10000
    with read only;

문제 3. 
나이가 30세 미만인 판매원의 이름, 나이, 급여를 보여주는 뷰 v_young_salesperson을 작성하시오.
create view v_young_salesperson as
    select name, age, salary
    from Salesperson
    where age < 30;

문제 4.
'LA'에 거주하는 고객의 이름, 도시, 직업을 보여주는 읽기 전용 뷰 v_la_customer를 작성하시오.
create view v_la_customer as
    select name, city, industrytype
    from Customer
    where city in ('LA'); -- city = "LA"

문제 5.
직업이 '개발자'인 고객의 이름, 도시, 직업을 보여주는 뷰 v_developer_customer를 작성하시오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.
create view v_developer_customer as
    select name, city, industrytype
    from Customer
    where industrytype = '개발자'
    with check option; -- 수정은 가능하되, 설정한 조건을 유지하는 범위 내에서만 허용

문제 6.
주문 금액이 15,000원 이상인 주문의 주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 읽기 전용 뷰 v_high_amount_order를 작성하시오.
create view v_high_amount_order as
    select number, custname, salesperson, amount
    from Order
    where amount >= 15000
    with read only;

문제 7.
급여가 8,000원 이상 12,000원 이하인 판매원의 이름, 나이, 급여를 보여주는 뷰 v_mid_salary_sp를 작성하시오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.
create view v_mid_salary_sp as
    select name, age, salary
    from Salesperson
    where salary between 8000 and 12000
    with check option;

문제 8.
담당 판매원이 'Tom'인 주문의 주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 뷰 v_tom_order를 작성하시오.
create view v_tom_order as
    select number, custname, salesperson, amount
    from Order
    where salesperson = 'Tom';

문제 9.
이름이 'S'로 시작하는 판매원의 이름, 나이, 급여를 보여주는 읽기 전용 뷰 v_s_salesperson을 작성하시오.
create view v_s_salesperson as
    select name, age, salary
    from Salesperson
    where name like 'S%'
    with read only;

문제 10.
주문 금액이 5,000원 이상 10,000원 이하인 주문의 주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 뷰 v_mid_amount_order를 작성하시오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오
create view v_mid_amount_order as
    select number, custname, salesperson, amount
    from Order
    where amount between 5000 and 10000
    with check option;


(복합 뷰)
문제 1.
판매원별 총 주문금액과 주문 횟수를 보여주는 뷰 v_sp_order_summary를 작성하시오.
(출력 컬럼 : 판매원이름, 총주문금액, 주문횟수)
CREATE OR REPLACE VIEW v_sp_order_summary AS
SELECT s.name AS 판매원이름,
       SUM(o.amount) AS 총주문금액,
       COUNT(o.number) AS 주문횟수
FROM Salesperson s
JOIN "Order" o ON s.name = o.salesperson
GROUP BY s.name;

문제 2.
고객별 총 주문금액과 주문 횟수를 보여주는 뷰 v_cust_order_summary를 작성하시오.
(출력 컬럼 : 고객이름, 도시, 총주문금액, 주문횟수)
CREATE OR REPLACE VIEW v_cust_order_summary AS
SELECT c.name AS 고객이름,
       c.city AS 도시,
       SUM(o.amount) AS 총주문금액,
       COUNT(o.number) AS 주문횟수
FROM Customer c
JOIN "Order" o ON c.name = o.custname
GROUP BY c.name, c.city;

문제 3.
판매원의 평균 급여보다 높은 급여를 받는 판매원의 이름, 나이, 급여를 보여주는 뷰 v_above_avg_salary를 작성하시오.
create view v_above_avg_salary as
    select name, age, salary
    from Salesperson
    where salary > (
        select avg(salary)
        from Salesperson
    );

문제 4.
한 번도 주문을 받지 못한 판매원의 이름, 나이, 급여를 보여주는 뷰 v_no_order_sp를 작성하시오.
create view v_no_order_sp as
    select s.name, s.age, salary
    from Salesperson s
    where not exists(
        select 1
        from Order o
        where o.salesperson = s.name
    );

문제 5.
'LA'에 거주하는 고객으로부터 주문을 받은 판매원의 이름, 나이, 급여를 보여주는 뷰 v_la_order_sp를 작성하시오.
create view v_la_order_sp as
select distinct s.name, s.age, s.salary
from Salesperson s
join Order o on s.name = o.salesperson
join Customer c on o.custname = c.name
where c.city = 'LA';

문제 6.
판매원별 평균 주문금액을 계산하여 전체 평균 주문금액보다 높은 판매원의 이름과 평균주문금액을 보여주는 뷰 v_above_avg_order_sp를 작성하시오.
create view v_above_avg_order_sp as
    select salesperson, avg(amount) as '평균주문금액'
    from Order
    group by salesperson
    having avg(amount) > (
        select avg(amount)
        from Order
    );

문제 7.
한 번도 주문하지 않은 고객의 이름, 도시, 직업을 보여주는 뷰 v_no_order_cust를 작성하시오.
create view v_no_order_cust as
    select c.name, c.city, c.industrytype
    from Customer c
    where not exists(
        select 1
        from Order o
        where o.custname = c.name
    );

문제 8.
2건 이상 주문을 받은 판매원의 이름과 주문 횟수, 총 주문금액을 보여주는 뷰 v_frequent_sp를 작성하시오.
create view v_frequent_sp as 
    select s.name, count(o.number) as '주문 횟수', sum(o.amount) as '총 주문금액'
    from Order o
    join Salesperson s on s.name= o.salesperson
    group by s.name
    having count(o.number) >= 2;

문제 9.
고객의 도시별 총 주문금액과 주문 건수를 보여주는 뷰 v_city_order_stats를 작성하시오.
(출력 컬럼 : 도시, 총주문금액, 주문건수)
create view v_city_order_stats as
    select c.city, sum(o.amount) as '총 주문금액', count(o.number) as '주문 건수'
    from Order o
    join Customer c on c.name = o.custname
    group by c.city;


문제 10.
판매원별 최고 주문금액, 최저 주문금액, 평균 주문금액과 자신의 급여 대비 총 주문금액 비율을 보여주는 뷰 v_sp_order_stats를 작성하시오.
(출력 컬럼 : 판매원이름, 급여, 최고주문금액, 최저주문금액, 평균주문금액, 급여대비주문비율)
create view v_sp_order_stats as
    select s.name, s.salary, max(o.amount) as '최고 주문금액', min(o.amount) as '최저 주문금액', avg(o.amount) as '평균 구문금액', round(sum(o.amount) / s.salary  * 100, 2) as '급여대비주문비율'
    from Order o
    join Salesperson s on s.name = o.salesperson
    group by s.name, s.salary;

문제 11.
직업별 총 주문금액과 평균 주문금액을 보여주는 뷰 v_industry_order_stats를 작성하시오.
(출력 컬럼 : 직업, 총주문금액, 평균주문금액)
create view v_industry_order_stats as
    select c.industrytype, sum(o.amount) as '총주문금액', avg(o.amount) as '평균주문금액'
    from Order o
    join Customer c on c.name = o.custname
    group by c.industrytype;

문제 12.
판매원 중 자신의 급여보다 총 주문금액이 더 높은 판매원의 이름, 급여, 총주문금액을 보여주는 뷰 v_sp_order_over_salary를 작성하시오.
create view v_sp_order_over_salary as
    select s.name, s.salary, sum(o.amount) as '총주문금액'
    from Order o
    join Salesperson s on s.name = o.salesperson
    group by s.name, s.salary
    having s.salary < sum(o.amount);

문제 13.
각 판매원이 주문을 받은 고객의 수(서로 다른 고객만)와 총 주문금액을 보여주는 뷰 v_sp_cust_count를 작성하시오.
(출력 컬럼 : 판매원이름, 담당고객수, 총주문금액)
create view v_sp_cust_count as
    select s.name, count(distinct c.name) as '담당고객수', sum(o.amount) as '총주문금액'
    from Salesperson s
    join Order o on s.name = o.salesperson
    join Customer c on o.custname = c.name
    group by s.name;

문제 14.
주문 금액이 가장 높은 주문을 한 고객의 이름, 도시, 직업, 주문금액을 보여주는 뷰 v_max_order_cust를 작성하시오.
create view v_max_order_cust as
    select c.name, c.city, c.industrytype, o.amount
    from Customer c 
    join Order o on c.name = o.custname
    where o.amount = (
        select max(amount)
        from Order
    );

문제 15.
판매원별로 주문금액의 합계를 구하고, 전체 주문금액 대비 각 판매원의 주문 비중을 보여주는 뷰 v_sp_order_ratio를 작성하시오.
(출력 컬럼 : 판매원이름, 총주문금액, 전체주문금액, 주문비중)
create view v_sp_order_ratio as
    select s.name, sum(o.amount) as '총주문금액', (select sum(amount) from Order) as '전체 주문금액', round(sum(o.amount) / (select sum(amount) from Order)  * 100, 2) as '주문비중'
    from Salesperson s
    join Order o on o.salesperson = s.name
    group by s.name;


[극장 데이터베이스]_3장 연습문제 20번 기준]

극장(극장번호, 극장이름, 위치)
상영관(극장번호, 상영관번호, 영화제목, 가격, 좌석수)
고객(고객번호, 이름, 주소)
예약(극장번호, 상영관번호, 고객번호, 좌석번호, 날짜)

문제 1.
모든 극장의 극장번호, 극장이름, 위치를 보여주는 뷰 v_theater_info를 작성하시오.
create view v_theater_info as
    select 극장번호, 극장이름, 위치
    from 극장;

문제 2.
위치가 '강남'인 극장의 극장번호, 극장이름을 보여주는 읽기 전용 뷰 v_gangnam_theater를 작성하시오.
create view v_gangnam_theater as
    select 극장번호, 극장이름
    from 극장
    where 위치 = '강남'
    with read only;

문제 3.
가격이 10,000원 이상인 상영관의 극장번호, 상영관번호, 영화제목, 가격을 보여주는 읽기 전용 뷰 v_high_price_screen을 작성하시오.
create view v_high_price_screen as
    select 극장번호, 상영관번호, 영화제목, 가격
    from 상영관
    where 가격 >= 10000
    with read only;

문제 4.
좌석수가 100석 이상인 상영관의 극장번호, 상영관번호, 영화제목, 좌석수를 보여주는 뷰 v_large_screen을 작성하시오.
create view v_large_screen as
    select 극장번호, 상영관번호, 영화제목, 좌석수 
    from 상영관
    where 좌석수 >= 100;

문제 5.
주소가 '강남'인 고객의 고객번호, 이름, 주소를 보여주는 읽기 전용 뷰 v_gangnam_customer를 작성하시오.
create view v_gangnam_customer as 
    select 고객번호, 이름, 주소
    from 고객
    where 주소 = '강남'
    with read only;

문제 6.
2025년 9월 1일에 예약된 내역의 극장번호, 상영관번호, 고객번호, 좌석번호, 날짜를 보여주는 뷰 v_reservation_20250901을 작성하시오.
create view v_reservation_20250901 as
    select 극장번호, 상영관번호, 고객번호, 좌석번호, 날짜
    from 예약
    where 날짜 = '2025-09-01';

문제 7.
가격이 7,500원 이상 10,000원 이하인 상영관의 극장번호, 상영관번호, 영화제목, 가격을 보여주는 뷰 v_mid_price_screen을 작성하시오.
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.
create view v_mid_price_screen as
    select 극장번호, 상영관번호, 영화제목, 가격
    from 상영관
    where 가격 between 7500 and 10000
    with check option;

문제 8.
좌석번호가 20번 이하인 예약 내역의 극장번호, 상영관번호, 고객번호, 좌석번호를 보여주는 뷰 v_front_seat_reservation을 작성하시오.
create view v_front_seat_reservation as
    select 극장번호, 상영관번호, 고객번호, 좌석번호
    from 예약
    where 좌석번호 <= 20;

문제 9.
영화제목에 '영화'가 포함된 상영관의 극장번호, 상영관번호, 영화제목, 가격, 좌석수를 보여주는 읽기 전용 뷰 v_movie_screen을 작성하시오.
create view v_movie_screen as
    select 극장번호, 상영관번호, 영화제목, 가격, 좌석수
    from 상영관
    where 영화제목 like '%영화%'
    with read only;

문제 10.
주소가 '잠실'인 고객의 고객번호, 이름, 주소를 보여주는 뷰 v_jamsil_customer를 작성하시오.  
단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오
create view v_jamsil_customer as
    select 고객번호, 이름, 주소
    from 고객
    where 주소 = '잠실'
    with check option;


(극장 데이터베이스 복합 뷰 문제)
극장(극장번호, 극장이름, 위치)
상영관(극장번호, 상영관번호, 영화제목, 가격, 좌석수)
고객(고객번호, 이름, 주소)
예약(극장번호, 상영관번호, 고객번호, 좌석번호, 날짜)

문제 1.
극장별 상영관 수와 평균 가격을 보여주는 뷰 v_theater_screen_stats를 작성하시오.
(출력 컬럼 : 극장이름, 위치, 상영관수, 평균가격)
create view v_theater_screen_stats as
    select 극장.극장이름, 극장.위치, count(상영관.극장번호) as '상영관수', avg(상영관.가격) as '평균가격'
    from 극장
    join 상영관 on 극장.극장번호 = 상영관.극장번호
    group by 극장.극장이름, 극장.위치;

문제 2.
각 극장의 상영관 중 가격이 가장 비싼 영화제목과 가격을 보여주는 뷰 v_theater_max_price를 작성하시오.
(출력 컬럼 : 극장이름, 영화제목, 가격)
create view v_theater_max_price as
    select t.극장이름, s.영화제목, s.가격
    from 극장 t
    join 상영관 s on s.극장번호 = t.극장번호
    where s.가격 = (
        select max(s.가격)
        from 상영관 s2
        where s2.극장번호 = s.극장번호
    );

문제 3.
고객별 총 예약 횟수를 보여주는 뷰 v_customer_reservation_count를 작성하시오.
(출력 컬럼 : 고객이름, 주소, 총예약횟수)
create view v_customer_reservation_count as
    select c.고객이름, c.주소, count(r.극장번호) as '총예약횟수'
    from 고객 c
    join 예약 r on r.고객번호 = c.고객번호
    group by c.고객이름, c.주소;

문제 4.
한 번도 예약하지 않은 고객의 고객번호, 이름, 주소를 보여주는 뷰 v_no_reservation_customer를 작성하시오.
create view v_no_reservation_customer as 
    select 고객번호, 이름, 주소
    from 고객 c
    where not exists(
        select 1
        from 예약 r
        where c.고객번호 = r.고객번호
    );

문제 5.
예약이 한 번도 없는 상영관의 극장번호, 상영관번호, 영화제목, 가격을 보여주는 뷰 v_no_reservation_screen을 작성하시오.
create view v_no_reservation_screen as 
    select 극장번호, 상영관번호, 영화제목, 가격
    from 상영관 s
    where not exists(
        select 1
        from 예약 r
        where s.상영관번호 = r.상영관번호
        and s.극장번호 = r.극장번호
    );

문제 6.
극장별 총 예약 건수와 총 예약 좌석수를 보여주는 뷰 v_theater_reservation_stats를 작성하시오.
(출력 컬럼 : 극장이름, 총예약건수, 총예약좌석수)
create view v_theater_reservation_stats as
    select t.극장이름, count(r.고객번호) as "총예약건수", count(r.좌석번호) as "총예약좌석수"
    from 극장 t
    join 예약 r on r.극장번호 = t.극장번호
    group by t.극장이름;

문제 7.
'강남'에 사는 고객이 예약한 내역의 고객이름, 극장번호, 상영관번호, 좌석번호, 날짜를 보여주는 뷰 v_gangnam_customer_reservation을 작성하시오.
create view v_gangnam_customer_reservation as
    select c.이름, r.극장번호, r.상영관번호, r.좌석번호, r.날짜
    from 예약 r
    join 고객 c on c.고객번호 = r.고객번호
    where c.주소 = '강남';

문제 8.!!!!
상영관별 예약 건수와 전체 좌석수 대비 예약된 좌석의 비율을 보여주는 뷰 v_screen_reservation_rate를 작성하시오.
(출력 컬럼 : 극장번호, 상영관번호, 영화제목, 좌석수, 예약건수, 예약률) 
단, 예약률은 소수점 2자리까지 표시한다.
create view v_screen_reservation_rate as
    select s.극장번호, s.상영관번호, s.영화제목, s.좌석수, count(r.고객번호) as "예약건수", round(count(r.고객번호) / s.좌석수 * 100, 2) as "예약률"
    from 상영관 s
    left join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    group by s.극장번호, s.상영관번호, s.영화제목, s.좌석수;

문제 9.
2건 이상 예약한 고객의 이름, 주소, 예약횟수를 보여주는 뷰 v_frequent_customer를 작성하시오.
create view v_frequent_customer as
    select c.이름, c.주소, count(r.고객번호) as "예약횟수"
    from 고객 c
    join 예약 r on c.고객번호 = r.고객번호
    group by c.이름, c.주소
    having count(r.고객번호) >= 2;

문제 10.
영화제목별 총 예약 건수와 총 예약 금액을 보여주는 뷰 v_movie_reservation_stats를 작성하시오.
(출력 컬럼 : 영화제목, 총예약건수, 총예약금액)
create view v_movie_reservation_stats as
    select s.영화제목, count(r.고객번호) as "총예약건수", sum(s.가격) as "총예약금액"
    from 상영관 s 
    join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    group by s.영화제목;

문제 11.
극장 위치별 평균 영화 가격과 총 상영관 수를 보여주는 뷰 v_location_screen_stats를 작성하시오.
(출력 컬럼 : 위치, 평균가격, 총상영관수)
create view v_location_screen_stats as
    select t.위치, avg(s.가격), count(s.상영관번호)
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호
    group by t.위치;

문제 12.
각 고객이 가장 최근에 예약한 날짜와 예약한 극장번호, 상영관번호를 보여주는 뷰 v_customer_last_reservation을 작성하시오.
(출력 컬럼 : 고객이름, 극장번호, 상영관번호, 최근예약날짜)
create view v_customer_last_reservation as
    select c.고객이름, r.극장번호, r.상영관번호, max(r.날짜) as "최근예약날짜"
    from 고객 c
    join 예약 r on c.고객번호 = r.고객번호
    where r.날짜 = (
        select max(r2.날짜)
        from 예약 r2
        where r.고객번호 = r2.고객번호
    );

문제 13.
전체 평균 가격보다 비싼 상영관의 극장이름, 상영관번호, 영화제목, 가격을 보여주는 뷰 v_above_avg_price_screen을 작성하시오.
create view v_above_avg_price_screen as
    select t.극장이름, s.상영관번호, s.영화제목, s.가격
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호
    where s.가격 > (
        select avg(가격)
        from 상영관
    );

문제 14. !!!(절대 못품)
극장별로 예약 건수가 가장 많은 상영관의 극장이름, 상영관번호, 영화제목, 예약건수를 보여주는 뷰 v_most_reserved_screen을 작성하시오.
CREATE OR REPLACE VIEW v_most_reserved_screen AS
SELECT t.극장이름, s.상영관번호, s.영화제목, res.cnt AS "예약건수"
FROM 극장 t
JOIN 상영관 s ON t.극장번호 = s.극장번호
JOIN (
    -- 1단계: 상영관별 예약 건수를 미리 계산
    SELECT 극장번호, 상영관번호, COUNT(*) as cnt
    FROM 예약
    GROUP BY 극장번호, 상영관번호
) res ON s.극장번호 = res.극장번호 AND s.상영관번호 = res.상영관번호
WHERE res.cnt = (
    -- 2단계: 해당 극장의 상영관 중 최대 예약 건수와 일치하는지 확인 (상관 서브쿼리)
    SELECT MAX(COUNT(*))
    FROM 예약 r2
    WHERE r2.극장번호 = s.극장번호
    GROUP BY r2.상영관번호
);

-- 인라인 뷰 (res): 모든 상영관의 성적표(예약 건수)를 미리 만듭니다

문제 15.
고객별 총 예약금액을 계산하고 전체 예약금액 대비 각 고객의 예약 비중을 보여주는 뷰 v_customer_payment_ratio를 작성하시오.
(출력 컬럼 : 고객이름, 총예약금액, 전체예약금액, 예약비중)
create view v_customer_payment_ratio as
    select c.고객이름, sum(s.가격) as "총예약금액", (select sum(s.가격) from 예약 r join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호) as '전체 예약금액', round(sum(s.가격) / (select sum(s.가격) from 예약 r join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호) * 100, 2) as "예약비중"
    from 고객 c
    join 예약 r on c.고객번호 = r.고객번호
    join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호
    group by c.고객이름; 
