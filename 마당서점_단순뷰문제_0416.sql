

마당서점 복합 뷰 생성 문제
마당서점의 기본 테이블 구조입니다.

sql-- 고객 테이블
Customer(custid, name, address, phone)-- 도서 테이블
Book(bookid, bookname, publisher, price)-- 주문 테이블
Orders(orderid, custid, bookid, saleprice, orderdate)

문제 1.
고객별 총 주문금액과 주문 횟수를 보여주는 뷰 v_cust_order_summary를 작성하시오.
(출력 컬럼: 고객이름, 총주문금액, 주문횟수)
create view v_cust_order_summary as
    select c.name, sum(o.saleprice), count(o.orderid)
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name;

문제 2.
각 도서의 도서명, 출판사, 판매된 총 수량(주문 횟수), 총 판매금액을 보여주는 뷰 v_book_sales를 작성하시오.
CREATE VIEW v_book_sales AS
    SELECT 
        b.bookname, 
        b.publisher, 
        COUNT(o.orderid) AS "총수량", 
        SUM(o.saleprice) AS "총판매금액"
    FROM Book b
    JOIN Orders o ON b.bookid = o.bookid
    GROUP BY b.bookname, b.publisher;

문제 3.
주문한 적 있는 고객의 이름, 주소, 가장 최근 주문일을 보여주는 뷰 v_cust_last_order를 작성하시오.
create view v_cust_last_order as
    select name, address, max(orderdate) as "가장 최근 주문일"
    from Customer c
    join Orders o on c.custid = o.custid
    group by name, address;

문제 4.
도서 정가보다 할인된 금액으로 판매된 주문 내역을 보여주는 뷰 v_discounted_orders를 작성하시오.
(출력 컬럼: 주문번호, 고객이름, 도서명, 정가, 판매가, 할인금액)
create view v_discounted_orders as 
    select orderid, name, bookname, price, saleprice, (price-saleprice) as "할인금액"
    from Orders o
    join Book b on b.bookid = o.bookid
    join Customer c on c.custid = o.custid
    where o.saleprice < b.price; 

문제 5.
출판사별 평균 판매가격과 최고 판매가격을 보여주는 뷰 v_publisher_stats를 작성하시오.
(출력 컬럼: 출판사, 평균판매가, 최고판매가)
create view v_publisher_stats as
    select b.publisher, avg(o.saleprice) as "평균판매가", max(o.saleprice) as "최고판매가"
    from Book b
    join Orders o on o.bookid = b.bookid
    group by b.publisher;

문제 6.
총 주문금액이 30,000원 이상인 우수 고객의 이름과 총 주문금액을 보여주는 뷰 v_vip_customer를 작성하시오.
create view v_vip_customer as
    select c.name, sum(o.saleprice) as "총 주문금액"
    from Customer c
    join Orders o on o.custid = c.custid
    group by c.name
    having sum(o.saleprice)>= 30000;

문제 7.
2024년에 주문된 내역의 고객이름, 도서명, 판매가격, 주문일자를 보여주는 뷰 v_orders_2024를 작성하시오.
create view v_orders_2024 as
    select c.name, b.bookname, o.saleprice, o.orderdate
    from Book b
    join Orders o on b.bookid = o.bookid
    join Customer c on c.custid = o.custid
    where o.orderdate between '2024-01-01' and '2024-12-31';

문제 8.
한 번도 주문되지 않은 도서의 도서명과 출판사, 정가를 보여주는 뷰 v_unsold_books를 작성하시오.
create view v_unsold_books as
    select b.bookname, b.publisher, b.price
    from Book b
    where not exists(
        select 1
        from Orders o
        where o.bookid = b.bookid
    );


문제 9.
고객별로 가장 비싸게 구매한 도서명과 그 금액을 보여주는 뷰 v_cust_max_order를 작성하시오.
(출력 컬럼: 고객이름, 도서명, 최고구매금액)
create view v_cust_max_order as
    select c.name, b.bookname, max(o.saleprice) as "최고구매금액"
    from Book b
    join Orders o on o.bookid = b.bookid
    join Customer c on c.custid = o.custid
    where o.saleprice = (
        select max(o.saleprice)
        from Orders o
        where o.custid = c.custid 
    );


문제 10.
도서명, 고객이름, 판매가, 해당 도서 평균 판매가, 평균 대비 차이를 보여주는 뷰 v_book_price_compare를 작성하시오.
(출력 컬럼: 도서명, 고객이름, 판매가, 도서평균판매가, 차이) !!
create view v_book_price_compare as
    select 
        b.bookname, 
        c.name, 
        o.saleprice, 
        avg(o.saleprice) over (partition by b.bookid) AS "도서평균판매가",
        (o.saleprice - avg(o.saleprice) over (partition by b.bookid)) AS "차이"
    from Book b
    join Orders o on b.bookid = o.bookid
    join Customer c on c.custid = o.custid;


[복합 뷰 문제]
문제 1.
출판사별로 판매된 도서 수와 총 판매금액을 보여주는 뷰 v_publisher_sales를 작성하시오.
(출력 컬럼: 출판사, 판매도서수, 총판매금액)
create view v_publisher_sales as
    select b.publisher, count(o.orderid) as "판매도서수", sum(o.saleprice)
    from Book b
    join Orders o on o.bookid = b.bookid
    group by b.publisher;

문제 2.
고객별 평균 구매금액을 계산하고, 전체 고객 평균보다 높은 고객만 보여주는 뷰 v_above_avg_customer를 작성하시오.
(출력 컬럼: 고객이름, 평균구매금액) !!
create view v_above_avg_customer as
    select c.name, avg(o.saleprice) as "평균 구매금액"
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name
    having avg(o.saleprice) > (
        select avg(o.saleprice) as "전체 고객 평균"
        from Orders o
    );


문제 3.
주문 내역에서 도서명, 고객이름, 주문일자, 판매가격을 출력하되 판매가격이 높은 순으로 정렬된 뷰 v_orders_detail을 작성하시오.
create view v_orders_detail as 
    select b.bookname, c.name, o.orderdate, o.saleprice
    from Book b
    join Orders o on b.bookid = o.bookid
    join Customer c on c.custid = o.custid
    order by o.saleprice desc;

문제 4.
2권 이상 주문한 고객의 이름과 주문 횟수를 보여주는 뷰 v_frequent_customer를 작성하시오.
create view v_frequent_customer as
    select c.name, count(o.orderid)
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name
    having count(o.orderid) >= 2;


문제 5.
각 고객이 마지막으로 주문한 도서명과 주문일자를 보여주는 뷰 v_last_ordered_book을 작성하시오.
(출력 컬럼: 고객이름, 도서명, 주문일자)
create view v_last_ordered_book as
    select c.name, b.bookname, o.orderdate
    from Book b
    join Orders o on b.bookid = o.bookid
    join Customer c on c.custid = o.custid
    where o.orderdate = (
        select max(o.orderdate)
        from Orders o
        where o.custid = c.custid
    );

문제 6.
도서 정가 대비 평균 할인율이 가장 높은 출판사 순으로 보여주는 뷰 v_publisher_discount_rate를 작성하시오.
(출력 컬럼: 출판사, 평균할인율) !!
단, 정가보다 낮게 팔린 경우만 포함한다.
create view v_publisher_discount_rate as
    select b.publisher, avg(b.price - o.saleprice / b.price * 100) as "평균할인율"
    from Book b
    join Orders o on o.bookid = b.bookid
    where b.price > o.saleprice 
    group by b.publisher
    order by "평균할인율" desc;


문제 7.
한 번이라도 주문한 적 있는 고객과 한 번도 주문하지 않은 고객을 구분하여 보여주는 뷰 v_customer_order_status를 작성하시오.
(출력 컬럼: 고객이름, 주문여부) !!!
단, 주문여부는 '주문있음' / '주문없음'으로 표시한다.
create view v_customer_order_status as
    select c.name,
        case 
            when exists (select 1 from Orders o where o.custid = c.custid) 
            then '주문있음'
            else '주문없음'
        end as "주문여부"
    from Customer c;

문제 8.
월별 총 판매금액과 주문 건수를 보여주는 뷰 v_monthly_sales를 작성하시오.(출력 컬럼: 년도, 월, 총판매금액, 주문건수)
create view v_monthly_sales as
    select year(o.orderdate) as "년도", month(o.orderdate) as "월",sum(o.saleprice), count(o.orderid)
    from Orders o
    group by year(o.orderdate), month(o.orderdate);

문제 9.
같은 출판사의 도서를 2종류 이상 구매한 고객의 이름과 출판사, 구매 종류 수를 보여주는 뷰 v_publisher_loyal_customer를 작성하시오
create view v_publisher_loyal_customer as
    select c.name, b.publisher, count(distinct b.bookname) as "구매 종류 수"
    from Book b
    join Orders o on o.bookid = b.bookid
    join Customer c on c.custid = o.custid
    group by c.name, b.publisher
    having count(distinct b.bookname) >= 2;


문제 10.
도서별로 최고가, 최저가, 평균가로 판매된 가격과 정가 대비 최대 할인금액을 보여주는 
뷰 v_book_price_stats를 작성하시오.
(출력 컬럼: 도서명, 출판사, 최고판매가, 최저판매가, 평균판매가, 최대할인금액)
create view v_book_price_stats as
    select b.bookname, b.publisher, max(o.saleprice) as "최고 판매가", min(o.saleprice) as "최저판매가", avg(o.saleprice) as "평균판매가", max(b.price-o.saleprice) as "최대할인금액"
    from Book b
    join Orders o on o.bookid = b.bookid
    group by b.bookname, b.publisher;


[사원 데이터베이스]
Employee(empno, name, phoneno, address, sex, position, depno)
Department(depno, deptname, ,manager)
Project(projno, projname, deptno)
Works(empno, projno, hours_worked)

문제 1.
모든 사원의 사원번호, 이름, 부서명, 직급, 급여를 보여주는 뷰 v_emp_basic을 작성하시오.
create view v_emp_basic as
    select e.empno, e.ename, d.dname, e.job, e.sal
    from emp e
    join dept d on e.deptno = d.deptno;


문제 2.
급여가 500만원 이상인 사원의 이름, 직급, 급여, 부서명을 보여주는 읽기 전용 뷰 v_high_salary_emp를 작성하시오.
create or replace view v_high_salary_emp as
    select e.ename, e.job, e.sal, d.dname
    from emp e
    join dept d on e.deptno = d.deptno
    where e.sal > 500
with read only;


문제 3.
현재 진행 중인 프로젝트(오늘 날짜가 시작일과 종료일 사이)의 프로젝트번호, 프로젝트명, 시작일, 종료일을 보여주는 뷰 v_active_projects를 작성하시오.
create or replace view v_active_projects as
    select projno, projname, start_date, end_date
    from projects
    where sysdate between start_date and end_date;

문제 4.
입사일이 2019년 이전인 사원의 사원번호, 이름, 부서명, 입사일, 근속연수를 보여주는 뷰 v_veteran_employee를 작성하시오.
(근속연수는 현재 연도 기준으로 계산)
create or replace view v_veteran_employee as
    select e.empno, e.ename, d.dname, e.hiderdate, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM e.hiredate) AS work_years
    from emp e
    join dept d on d.deptno = e.deptno
    where e.hiredate < TO_DATE('2019-01-01', 'YYYY-MM-DD');

문제 5.
부서 위치가 '서울'인 부서의 부서번호, 부서명, 예산을 보여주는 뷰 v_seoul_department를 작성하시오.
create or replace view v_seoul_department as
    select deptno, dname, budget
    from dept
    where loc = '서울';

문제 6.
직급이 '부장' 또는 '이사'인 사원의 사원번호, 이름, 직급, 급여를 보여주는 읽기 전용 뷰 v_senior_position를 작성하시오.
create or replace view v_senior_position as
    select empno, ename, job, sal
    from emp
    where job in ('부장', '이사')
with read ONLY;

문제 7.
프로젝트에서 'PM' 역할을 담당하는 사원의 사원번호, 프로젝트번호, 담당역할, 투입시간을 보여주는 뷰 v_pm_role을 작성하시오.
create or replace view v_pm_role as
    select empno, projno, role, work_hours
    from project_assignments
    where role = 'PM';

문제 8.
급여가 300만원 미만인 사원 중 입사일이 2022년 이후인 사원의 이름, 직급, 급여, 입사일을 보여주는 뷰 v_junior_emp를 작성하시오.
create or replace view v_junior_emp as
    select ename, job, sal, hiredate
    from emp
    where sal < 300
      and hiredate >= TO_DATE('2022-01-01', 'YYYY-MM-DD');


문제 9.
예산이 1억원 이상인 프로젝트의 프로젝트명, 시작일, 종료일, 예산을 보여주는 읽기 전용 뷰 v_large_budget_project를 작성하시오.
create or replace view v_large_budget_project as
    select p.projname, p.start_date, p.end_date, d.budget
    from dept d
    join projects p on p.deptno = d.deptno
    where d.budget >= 10000
with read only;


문제 10.
관리자가 없는 최상위 관리자이면서 급여가 700만원 이상인 사원의사원번호, 이름, 부서명, 직급, 급여를 보여주는 읽기 전용 뷰 v_top_executive를 작성하시오
create or replace view v_top_executive as
    select e.empno, e.ename, d.dname, e.job, e.sal
    from emp e
    join dept d on d.deptno = e.deptno
    where e.sal >= 700
    and e.mgr is null
with read only;


[복합 뷰]
문제 1.
부서별 평균 급여와 최고 급여, 최저 급여를 보여주는 뷰 v_dept_salary_stats를 작성하시오.
(출력 컬럼: 부서명, 평균급여, 최고급여, 최저급여)
create view v_dept_salary_stats as
    select d.dname, avg(e.sal) as '평균급여', max(e.sal) as '최고급여', min(e.sal) as '최저급여'
    from dept d
    join emp e e.deptno = d.deptno
    group by d.dname;

문제 2.
각 사원이 참여한 프로젝트 수와 총 투입시간을 보여주는 뷰 v_emp_project_summary를 작성하시오.
(출력 컬럼: 사원이름, 참여프로젝트수, 총투입시간)
create or replace view v_emp_project_summary as
    select 
        e.ename as 사원이름, 
        count(w.projno) as 참여프로젝트수, 
        sum(w.hours_worked) as 총투입시간
    from emp e 
    join works w on e.empno = w.empno
    group by e.ename;

문제 3.
부서별 예산 대비 해당 부서 사원들의 평균 급여 비율을 보여주는 뷰 v_dept_budget_ratio를 작성하시오.
(출력 컬럼: 부서명, 부서예산, 평균급여, 급여예산비율)
단, 급여예산비율은 소수점 2자리까지 표시한다.
create or replace view v_dept_budget_ratio as
    select d.dname, d.sal, avg(e.sal) as "평균급여", round(avg(e.sal) / d.budget * 100, 2)
    from emp e
    join dept d on d.deptno = e.deptno
    group by d.dname, d.budget;

문제 4.
현재 진행 중인 프로젝트에 참여하고 있는 사원의 이름, 부서명, 프로젝트명, 담당역할을 보여주는 뷰 v_active_project_emp를 작성하시오.
create or replace view v_active_project_emp as
    select e.ename, d.dname, p.projname, w.role
    from emp e
    join dept d on e.deptno = d.deptno
    join works w on e.empno = w.empno
    join projects p on w.projno = p.projno
    where sysdate between p.start_date and p.end_date;

문제 5.
한 번도 프로젝트에 참여하지 않은 사원의 사원번호, 이름, 부서명, 직급을 보여주는 뷰 v_no_project_emp를 작성하시오.
create or replace view v_no_project_emp as
    select e.empno, e.ename, d.dname, e.job
    from emp e
    join dept d on d.deptno= e.deptno
    where not exists(
        select 1
        from work w
        where w.empno = e.empno
    );


문제 6.
프로젝트별 참여 사원 수와 총 투입시간, 평균 투입시간을 보여주는 뷰 v_project_stats를 작성하시오.
(출력 컬럼: 프로젝트명, 참여사원수, 총투입시간, 평균투입시간)
create or replace view v_project_stats as
    select p.projname, count(e.empno) as '참여사원수', sum(w.hours_worked) as '총투입시간', avg(w.hours_worked) as '평균투입시간'
    from emp e
    join works w on w.empno = e.empno
    join projects p on p.projno = w.projno
    group by p.projname;


문제 7.
자신이 속한 부서의 평균 급여보다 높은 급여를 받는 사원의 이름, 부서명, 급여, 부서평균급여를 보여주는 뷰 v_above_dept_avg를 작성하시오.
create or replace view v_above_dept_avg as
    select
        e.ename, 
        d.dname, 
        e.sal, 
        dept_avg.avg_sal as 부서평균급여
    from emp e
    join dept d on e.deptno = d.deptno
    join (
        select deptno, avg(sal) as avg_sal
        from emp
        GROUP BY deptno
    ) dept_avg on e.deptno = dept_avg.deptno
    where e.sal > dept_avg.avg_sal;


문제 8.
각 부서에서 가장 오래 근무한 사원의 이름, 부서명, 입사일, 근속연수를 보여주는 뷰 v_longest_serving를 작성하시오.
create or replace view v_longest_serving as
    select e.ename, d.dname, e.hiderdate, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM e.hiredate) AS work_years
    from emp e
    join dept d on e.deptno = d.deptno
    where (e.deptno, e.hiredate) in (
        select deptno, min(hiredate)
        from emp
        group by deptno
    );

문제 9.
2개 이상의 프로젝트에 참여하면서 총 투입시간이 100시간 이상인 사원의 이름, 참여프로젝트수, 총투입시간을 보여주는 뷰 v_active_emp를 작성하시오.
create or replace view v_active_emp
    select e.ename, count(p.projno) as "참여프로젝트수", sum(w.hours_worked) as '총투입시간'
    from emp e
    join works w on w.empno = e.empno
    group by e.name
    having count(p.projno) >= 2 and
    sum(w.hours_worked) >= 100;


문제 10.
부서별로 'PM' 역할을 맡은 사원 수와 해당 부서의 평균 급여를 보여주는 뷰 v_dept_pm_stats를 작성하시오.
(출력 컬럼: 부서명, PM수, 부서평균급여)
create or replace view v_dept_pm_stats as
    select d.dname, COUNT(CASE WHEN w.role = 'PM' THEN 1 END) AS PM수, avg(e.sal) as "부서평균급여"
    from emp e
    join dept d on d.deptno = e.deptno
    LEFT JOIN works w ON e.empno = w.empno
    group by d.dname; 