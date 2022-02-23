--ESCAPE
SELECT * FROM employees WHERE job_id like '%\_A%' escape '\';
SELECT * FROM employees WHERE job_id like '%#_A%' escape '#';

--IN : OR 대신 사용
SELECT * FROM employees WHERE manager_id=101 or manager_id=102 or manager_id=103;
SELECT * FROM employees WHERE manager_id in(101,102,103);

--BETWEEN AND : 포함
SELECT * FROM employees WHERE manager_id BETWEEN 101 AND 103;

--IS NULL / IS NOT NULL
SELECT * FROM employees WHERE commission_pct IS NULL;
SELECT * FROM employees WHERE commission_pct IS NOT NULL;

--[주요 함수]
--MOD
SELECT * FROM employees WHERE MOD(employee_id,2)=1;
SELECT MOD(10,3) FROM dual;

--ROUND()
SELECT ROUND(355.95555) FROM dual;
SELECT ROUND(355.95555,0) FROM dual;
SELECT ROUND(355.95555,2) FROM dual;
SELECT ROUND(355.95555,-1) FROM dual;

--TRUNC()
SELECT TRUNC(45.5555,1)FROM dual;
SELECT last_name, TRUNC(salary/12,2) FROM employees;

--날짜 관련 함수
SELECT SYSDATE FROM dual;
SELECT SYSDATE + 1 FROM dual;
SELECT last_name, TRUNC((SYSDATE - hire_date)/365) 근속연수 FROM employees;
SELECT last_name, hire_date, ADD_MONTHS(hire_date, 6) FROM employees;
SELECT LAST_DAY(sysdate) - sysdate FROM dual;
SELECT hire_date, NEXT_DAY(hire_date,'월') FROM employees;
SELECT sysdate, NEXT_DAY(sysdate, '금') FROM dual;

--MONTHS_BETWEEN()
SELECT last_name,sysdate,hire_date, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)) FROM employees;

--형변환 함수
--number character date
--to_date() 문자열을 날짜로
--to_number, to_char
SELECT last_name, months_between('2012/12/31',hire_date) FROM employees;
SELECT trunc(sysdate - to_date('2014/01/01')) FROM dual;

--Q. employees 테이블에 있는 직원들(사번, 이름 기준으로)에 대하여 현재기준으로 근속연수를 구하세요
SELECT employee_id,last_name, TRUNC((sysdate - hire_date)/365)근속연수 FROM employees;

SELECT TO_DATE('20210101'),
TO_CHAR(TO_DATE('20210101'),'MonthDD YYYY','NLS_DATE_LANGUAGE=ENGLISH') format1 FROM dual;

SELECT TO_CHAR(SYSDATE, 'YY/MM/DD HH24:MI:SS') FROM dual;
SELECT TO_CHAR(SYSDATE, 'yy/mm/dd') FROM dual;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual;
SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss') FROM dual;
SELECT TO_CHAR(SYSDATE, 'DAY') FROM dual;

--TO_CHAR
--9 한자리의 숫자표현
--0 앞부분을 0으로 표현
--$ 달러 기호를 앞에 표현
--. 소수점을 표시
--, 특정 위치에 표시
--MI 오른쪽에 ? 기호 표시
--PR 음수값을 <>으로 표현
--EEEE 과학적 표현
--B 공백을 0으로 표현
--L 지역통화
SELECT salary, TO_CHAR(salary,'0099999') FROM employees;
SELECT TO_CHAR(-salary, '999999PR') FROM employees;
SELECT TO_CHAR(1111, '99.99EEEE') FROM dual;
SELECT TO_CHAR(1111, 'B9999.99') FROM dual;
SELECT TO_CHAR(1111,'L99999') FROM dual; 

--WIDTH_BUCKET() 지정값, 최소값, 최대값, BUCKET 개수
SELECT WIDTH_BUCKET(92,0,100,10) FROM dual;
SELECT WIDTH_BUCKET(100,0,100,10) FROM dual;
SELECT department_id, last_name, salary, WIDTH_BUCKET(salary,0,20000,5) FROM employees WHERE department_id=50;

--[과제] employees 테이블에서 employee_id, last_name, salary, hire_date 및 입사일 기준으로 근속년수를 계산해서 아래사항을 추가한 후 
--출력하세요. 2001년 1월 1일 창업하여 현재(2020년 12월 31일)까지 20년간 운영되어온 회사는 직원의 근속연수에 따라 30등급으로 나누어 등급에
--따라 1000원의 bonus를 지급(bonus 기준 내림차순 정렬)
SELECT employee_id, last_name, salary, hire_date,
TRUNC(((to_date('20201231') - hire_date)/365))근속연수,
(WIDTH_BUCKET(TRUNC(((to_date('20.12.31') - hire_date)/365)),0,20,30)) 보너스등급,
(WIDTH_BUCKET(TRUNC(((to_date('20.12.31') - hire_date)/365)),0,20,30))*1000 bonus
FROM employees
ORDER BY bonus DESC;

--문자함수
SELECT UPPER('Hello World') FROM dual;
SELECT LOWER('Hello World') FROM dual;
SELECT last_name, salary FROM employees WHERE LOWER(last_name)='seo';
SELECT INITCAP(job_id) FROM employees;
SELECT job_id, LENGTH(job_id) FROM employees;
SELECT INSTR('Hello World','o',3,2) From dual;
SELECT SUBSTR('Hello World',3,3) FROM dual;
SELECT SUBSTR('Hello World',-3,3) FROM dual;
SELECT LPAD('Hello World',20,'#') FROM dual;
SELECT RPAD('Hello World',20,'#') FROM dual;
SELECT LTRIM('aaaHello Worldaaa','a') FROM dual;
SELECT RTRIM('aaaHello Worldaaa','a') FROM dual;
SELECT LTRIM('   Hello World   ') FROM dual;
SELECT RTRIM('   Hello World   ') FROM dual;
SELECT TRIM('   Hello World   ') FROM dual;

--기타함수
SELECT salary, commission_pct, salary*12*NVL(commission_pct,0) FROM employees;

SELECT last_name, department_id,
CASE WHEN department_id=90 THEN '경영지원실'
WHEN department_id = 60 THEN '프로그래머'
WHEN department_id=100 THEN '인사부'
END AS 소속
FROM employees;

--분석함수 : 여러 가지 기준을 적용해 여러 결과를 return 할 수 있으며 처리 대상이 되는 행의 집단을 window라고 지칭
--FIRST_VALUE() OVER() 그룹의 첫번째 값을 구한다.
SELECT first_name 이름, salary 연봉,
FIRST_VALUE(salary) OVER(ORDER BY salary DESC) 최고연봉
FROM employees;
--3줄 위의 값까지 중 첫번째 값
SELECT first_name 이름, salary 연봉,
FIRST_VALUE(salary) OVER(ORDER BY salary DESC ROWS 3 PRECEDING) 최고연봉
FROM employees;

--Q. 3줄 위의 값까지중 최저연봉
select first_name 이름, salary 연봉,
first_value(salary) over(order by salary asc rows 3 preceding) 최저연봉
from employees;

select first_name 이름, salary 연봉,
last_value(salary) over(order by salary desc rows 3 preceding) 최저연봉
from employees;

select first_name 이름, salary 연봉,
last_value(salary) over(order by salary desc rows 3 preceding) 최저연봉
from employees;

--Q. 위아래 각각 2줄 까지 중 최저연봉
SELECT first_name 이름, salary 연봉,
LAST_VALUE(salary) OVER(ORDER BY salary DESC ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) 최저연봉
FROM employees;

--[과제] employees 테이블에서 department_id=50인 직원의 연봉을 내림차순 정렬하여 누적 카운드를 출력하세요.
SELECT department_id, last_name, salary, COUNT(*) over(order by salary desc) 
FROM employees
WHERE department_id=50;

--[과제] employees 테이블에서 department_id를 기준으로 오름차순 정렬하고 department_id 그룹 직원의 연봉 누적 합계를 출력하세요.
SELECT department_id, last_name, salary, SUM(salary) OVER(PARTITION BY department_id 
ORDER BY department_id asc) FROM employees;

SELECT department_id, last_name, salary, SUM(salary) OVER( 
ORDER BY department_id asc) FROM employees;

--[과제] employees 테이블에서 department_id(부서)별 직원 연봉순위를 출력하세요.
SELECT first_name, department_id 부서, salary 연봉,
RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) 부서연봉순위
FROM employees;

SELECT first_name, department_id 부서, salary 연봉,
RANK() OVER(ORDER BY salary DESC) 연봉순위
FROM employees;

--dml
DESC BOOK;
SELECT * FROM BOOK;
SELECT BOOKNAME,PRICE FROM BOOK;
SELECT PUBLISHER FROM BOOK;
SELECT DISTINCT PUBLISHER FROM BOOK;
SELECT * 
FROM BOOK
WHERE PRICE < 10000;
--Q. 가격이 10000원 이상 20000원 이하인 도서를 검색하세요.
SELECT * FROM BOOK WHERE 10000 <= PRICE AND PRICE <= 20000;
--Q. 출판사가 굿스포츠, 혹은 대한미디어인 도서를 검색하세요.
SELECT * FROM BOOK WHERE PUBLISHER = '굿스포츠' OR PUBLISHER = '대한미디어';
SELECT * FROM BOOK WHERE PUBLISHER IN ('굿스포츠','대한미디어');
--Q. 출판사가 굿스포츠, 혹은 대한미디어가 아닌 도서를 검색하세요.
SELECT * FROM BOOK WHERE PUBLISHER NOT IN ('굿스포츠','대한미디어');
--Q. 도서이름에 축구가 포함된 출판사를 검색하세요.
select PUBLISHER from BOOK where BOOKNAME like '%축구%';
select * from BOOK where BOOKNAME like '%축구%';
--[과제] 도서이름의 왼쪽 두 번째 위치에 구라는 문자열을 갖는 도서를 검색하세요.
-- _은 특정 위치의 한개의 문자와 일치
-- %은 0개 이상의 문자와 일치
SELECT BOOKNAME,PUBLISHER
FROM BOOK
WHERE BOOKNAME LIKE'_구%';
--[과제] 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하세요.
SELECT * 
FROM BOOK
WHERE BOOKNAME LIKE '%축구%' AND PRICE >= 20000;

SELECT * 
FROM BOOK
ORDER BY BOOKNAME;

SELECT * 
FROM BOOK
ORDER BY BOOKNAME DESC;

--Q. 도서를 가격순으로 검색하고 가격이 같으면 이름순으로 검색하세요.
SELECT * FROM BOOK ORDER BY PRICE,BOOKNAME;
--Q. 도서를 가격의 내림차순으로 검색하고 만약 가격이 같다면 출판사의 오름차순으로 출력하세요.
select * from book
order by price Desc,publisher;

SELECT * FROM ORDERS;
SELECT SUM(SALEPRICE)
FROM ORDERS;

SELECT SUM(SALEPRICE) AS "총매출"
FROM ORDERS;

--Q.CUSTID 가 2번인 고객이 주문한 도서의 총판매액을 구하세요.
select sum(SALEPRICE) AS "총 판매액" from ORDERS where CUSTID=2;
SELECT SUM(SALEPRICE) AS TOTAL,
AVG(SALEPRICE) AS AVERAGE,
MIN(SALEPRICE) AS MINIMUM,
MAX(SALEPRICE) AS MAXIMUM
FROM ORDERS;

SELECT COUNT(*) FROM ORDERS;

--Q. CUSTID별 도서수량과 총판매액을 출력하세요.
SELECT CUSTID, COUNT(*) AS 도서수량, SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
GROUP BY CUSTID;

--Q. 가격이 8000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하세요. 단 두권 이상 구매한 고객에 한정함
SELECT CUSTID, COUNT(*) AS 도서수량
FROM ORDERS
WHERE SALEPRICE >= 8000
GROUP BY CUSTID
HAVING COUNT(*) >= 2;

SELECT * FROM CUSTOMER;

SELECT * 
FROM CUSTOMER, ORDERS
WHERE CUSTOMER.CUSTID = ORDERS.CUSTID
ORDER BY CUSTOMER.CUSTID;

--Q. 고객별로 주문한 모든 도서의 총 판매액을 구하고 고객이름별로 정렬하세요.
SELECT NAME, SUM(SALEPRICE)
FROM CUSTOMER,ORDERS
WHERE CUSTOMER.CUSTID = ORDERS.CUSTID
GROUP BY CUSTOMER.NAME
ORDER BY CUSTOMER.NAME;

--Q. 고객의 이름과 고객이 주문한 도서의 이름을 구하세요.
SELECT CUSTOMER.NAME, BOOK.BOOKNAME
FROM CUSTOMER,ORDERS,BOOK
WHERE CUSTOMER.CUSTID = ORDERS.CUSTID AND ORDERS.BOOKID= BOOK.BOOKID;

SELECT C.NAME, B.BOOKNAME
FROM CUSTOMER C,ORDERS O,BOOK B
WHERE C.CUSTID = O.CUSTID AND O.BOOKID= B.BOOKID;

--[과제] 가격이 20,000인 도서를 주문한 고객의 이름과 도서의 이름을 구하세요.
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE C.CUSTID = O.CUSTID AND O.BOOKID=B.BOOKID AND B.PRICE=20000;

--[과제] 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하세요.
--outer join 조인조건을 만족하지 못하더라도 해당 행을 나타냄
SELECT C.NAME, O.SALEPRICE
FROM CUSTOMER C, ORDERS O
WHERE C.CUSTID = O.CUSTID(+);
--[과제] 가장 비싼 도서의 이름을 출력하세요.
SELECT BOOKNAME
FROM BOOK
WHERE PRICE=(SELECT MAX(PRICE) FROM BOOK);
SELECT * FROM BOOK;

--[과제] 도서를 구매한 적이 있는 고객의 이름을 검색하세요.
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS);
--[과제] 대한미디어에서 출판한 도서를 구매한 고객의 이름을 출력하세요.
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS
WHERE BOOKID IN (SELECT BOOKID FROM BOOK
WHERE PUBLISHER = '대한미디어'));

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
SELECT * FROM BOOK;
SELECT b1.bookname
FROM book b1
WHERE b1.price > (SELECT avg(b2.price)
FROM book b2 WHERE b2.publisher=b1.publisher);

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.
SELECT * FROM customer;
SELECT * FROM orders;
SELECT name
FROM customer
MINUS
SELECT name
FROM customer
WHERE custid IN(SELECT custid FROM orders);

--Q. 주문이 있는 고객의 이름과 주소를 보이시오.
SELECT name, address
FROM customer
WHERE custid IN(SELECT custid FROM orders);

--Q.Customer 테이블에서 고객번호가 5인 고객의 주소를 ‘대한민국 부산’으로 변경하시오.
UPDATE customer
SET address = '대한민국 부산'
WHERE custid=5;

SELECT * FROM customer;
--Q.Customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경하시오.
UPDATE customer
SET address = (SELECT address FROM customer
WHERE name = '김연아')
WHERE name = '박세리';
SELECT * FROM customer;
--Q.Customer 테이블에서 고객번호가 5인 고객을 삭제한 후 결과를 확인하시오.
DELETE customer
WHERE custid=5;

SELECT ABS(-78), ABS(+78) FROM DUAL;
SELECT ROUND(4.875,1) FROM DUAL;
SELECT * FROM orders;
--Q.고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하시오.
select custid 고객번호,round(avg(saleprice),-2) "평균 주문 금액"
from orders
group by custid;

--Q.도서 제목에 ‘야구’가 포함된 도서를 ‘농구’로 변경한 후 도서 목록, 가격을 보이시오.
SELECT * FROM book;
SELECT bookid, REPLACE(bookname, '야구','농구') bookname, price
FROM book;

--Q.‘굿스포츠’에서 출판한 도서의 제목과 제목의 글자 수, 바이트 수를 보이시오.
SELECT bookname 제목, LENGTH(bookname) 글자수, LENGTHB(bookname) 바이트수
FROM book
WHERE publisher = '굿스포츠';

SELECT * FROM customer;
INSERT INTO customer VALUES(6,'박세리','대한민국 대전','000-9000-0001');
INSERT INTO customer VALUES(5,'박세리','대한민국 대전',null);
DELETE customer
WHERE custid = 6;

--Q.마당서점의 고객 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.
SELECT SUBSTR(name,1,1)성,COUNT(*)인원수
FROM customer
GROUP BY SUBSTR(name,1,1);

--Q. 마당서점은 주문일로 부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하세요.
SELECT orderdate 주문일자, orderdate+10 확정일자
FROM orders;

--Q.DBMS 서버에 설정된 현재 날짜와 시간, 요일을 확인하시오. 
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE,'yyyy/mm/dd dy hh24:mi:ss')SYSDATE1
FROM dual;

--Q.마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오.
SELECT * FROM orders;
SELECT orderid 주문번호,TO_CHAR(orderdate,'YYYY-mm-dd day') 주문일,custid 고객번호, bookid 도서번호
FROM orders
WHERE orderdate = '20/07/07';
 
--Q.고객목록에서 고객번호, 이름, 전화번호를 앞의 두 명만 보이시오.
SELECT * FROM customer;
SELECT ROWNUM 순번, custid 고객번호, name 이름, phone 전화번호
FROM customer
WHERE ROWNUM<=2;

--Q.평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오.
SELECT orderid,saleprice FROM orders
WHERE saleprice <= (SELECT AVG(saleprice) FROM orders);

--Q.전체 평균 주문금액보다 큰 금액의 고객 주문 내역에 대해서 주문번호, 고객번호, 금액을 보이시오.
SELECT * FROM orders;
SELECT	orderid, custid, saleprice
from Orders b1
where b1.saleprice > (select avg(b2.saleprice)
from Orders b2 where b2.custid = b1.custid);

--Q.‘대한민국’에 거주하는 고객에게 판매한 도서의 총 판매액을 구하시오.
SELECT * FROM customer;
SELECT SUM(saleprice) 총판매액
FROM orders
WHERE custid IN (SELECT custid FROM customer WHERE address LIKE '%대한민국%');

--Q.3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 주문번호와 금액을 보이시오.
select orderid, saleprice from orders 
where saleprice > (select max(saleprice) from orders where custid='3');

--[과제]EXISTS 연산자를 사용하여 ‘대한민국’에 거주하는 고객에게 판매한 도서의 총 판매액을 구하시오.
SELECT SUM(saleprice)total
FROM orders o
WHERE EXISTS(SELECT * FROM customer c 
WHERE address LIKE'%대한민국%' AND o.custid=c.custid);

--[과제]마당서점의 고객별 판매액을 보이시오(고객이름과 고객별 판매액 출력)
SELECT (SELECT name FROM customer c WHERE c.custid=o.custid)name,
SUM(saleprice) total FROM orders o
GROUP BY o.custid;

--[과제] 고객번호가 2 이하인 고객의 판매액을 보이시오(고객이름과 고객별 판매액 출력)
SELECT * FROM customer;
SELECT c.name, SUM(o.saleprice) total
FROM(SELECT custid, name
FROM customer
WHERE custid<=2) c,
orders o
WHERE c.custid = o.custid
GROUP BY c.name;




--Q.주소에 ‘대한민국’을 포함하는 고객들로 구성된 뷰를 만들고 조회하시오. 뷰의 이름은 vw_Customer로 설정하시오.
CREATE VIEW vw_Customer
AS SELECT *
FROM customer
WHERE address LIKE'%대한민국%';

SELECT * FROM vw_Customer;
SELECT * FROM customer;
--[과제]Orders 테이블에서 고객이름과 도서이름을 바로 확인할 수 있는 뷰를 생성한 후, 
--‘김연아’ 고객이 구입한 도서의 주문번호, 도서이름, 주문액을 보이시오.
CREATE VIEW vw_orders(orderid,custid,name,bookid,bookname,saleprice,orderdate)
AS SELECT o.orderid, o.custid, c.name, o.bookid, b.bookname, o.saleprice, o.orderdate
FROM orders o, customer c, book b
WHERE o.custid = c.custid AND o.bookid=b.bookid;
SELECT * FROM vw_orders;
SELECT orderid, bookname, saleprice
FROM vw_orders
WHERE name='김연아';
--[과제]vw_Customer를 미국을 주소로 가진 고객으로 변경하세요.
SELECT * FROM vw_Customer;
CREATE OR REPLACE VIEW vw_Customer
AS SELECT *
FROM customer
WHERE address LIKE'%미국%';

--[과제]앞서 생성한 뷰 vw_Customer를 삭제하시오.
DROP VIEW vw_Customer;

--[HR Tables]

SELECT * FROM employees;
--[과제]EMPLOYEES 테이블에서 commission_pct 의  Null값 갯수를  출력하세요.
SELECT COUNT(*)
FROM employees
WHERE commission_pct is null;
--[과제]EMPLOYEES 테이블에서 employee_id가 홀수인 것만 출력하세요.
SELECT *
FROM employees
WHERE MOD(employee_id,2)=1;
--[과제]job_id의 문자 길이를 구하세요.
SELECT job_id, LENGTH(job_id) FROM employees;
--[과제]job_id 별로 연봉합계 연봉평균 최고연봉 최저연봉 출력
SELECT job_id, SUM(salary)연봉합계, AVG(salary)연봉평균, MAX(salary)최고연봉,MIN(salary)최저연봉
FROM employees
GROUP BY job_id;

--날짜 관련 함수
SELECT SYSDATE FROM DUAL;
SELECT * FROM employees;
SELECT last_name, hire_date, TRUNC((SYSDATE - hire_date)/365,0)근속연수 FROM employees;

--특정 개월 수를 더한 날짜를 구하기
SELECT last_name, hire_date, ADD_MONTHS(hire_date,6) FROM employees;

--해당 날짜가 속한 월의 말일을 반환하는 함수
SELECT LAST_DAY(SYSDATE) FROM dual;

--Q. 다음 달 말일(hire_data 기준)
select last_name, hire_date,last_DAY(ADD_MONTHS(hire_date,1)) "입사 다음달 말일"
from employees;

--해당 날짜를 기준으로 명시된 요일에 해당하는 다음주 날짜를 반환
SELECT hire_date,next_day(hire_date,'월') FROM employees;

--months_between() 날짜와 날짜 사이의 개월 수를 구하기
SELECT last_name, TRUNC(MONTHS_BETWEEN(sysdate,hire_date),0)근속월수1, ROUND(MONTHS_BETWEEN(sysdate,hire_date),0)근속월수2 FROM employees;

--Q.입사일 6개월 후 첫 번째 월요일을 직원이름별로 출력하세요.
SELECT last_name, hire_date, NEXT_DAY(ADD_MONTHS(hire_date,6),'월')d_day
FROM employees;

--Q.job_id 별로 연봉합계 연봉평균 최고연봉 최저연봉 출력, 단 평균연봉이 5000 이상인 경우만 포함
select job_id , sum(salary)연봉합계,avg(salary)연봉평균,max(salary)최고연봉,min(salary)최저연봉
from employees
group by job_id
having avg(salary) >= 5000;

--Q.job_id 별로 연봉합계 연봉평균 최고연봉 최저연봉 출력, 단 평균연봉이 5000 이상인 경우만 내림차순으로 정렬
select job_id , sum(salary)연봉합계,avg(salary)연봉평균,max(salary)최고연봉,min(salary)최저연봉
from employees
group by job_id
having avg(salary) >= 5000
order by avg(salary) desc;


--Q. last_name에 L이 포함된 직원의 연봉을 구하라
SELECT LAST_NAME , SALARY
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%L%';

--Q. job_id에 PROG가 포함된 직원의 입사일 구하라
SELECT JOB_ID,HIRE_DATE
FROM EMPLOYEES
WHERE JOB_ID LIKE '%PROG%';

--Q. 연봉이 10000$ 이상인 MANAGER_ID 가 100인 직원의 데이터 출력
SELECT * 
FROM EMPLOYEES
WHERE SALARY >=10000 AND MANAGER_ID =100;

--Q. DEPARTMENT_ID 가 100보다 적은 모든 직원의 연봉을 구하여라
SELECT DEPARTMENT_ID,SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID <100;

--Q. MANAGER_ID 가 101,103인 직원의 JOB_ID를 구하여라
SELECT MANAGER_ID,JOB_ID
FROM EMPLOYEES
WHERE MANAGER_ID =101 OR MANAGER_ID =103;

--join

--Q. 사원번호가 110인 사원의 부서명
SELECT employee_id, department_name
FROM employees e,departments d
WHERE e.department_id=d.department_id and employee_id=110;

SELECT employee_id, department_name
FROM employees e
join departments d on e.department_id=d.department_id
WHERE employee_id=110;

--Q.사번이 120번인 사람의 사번, 이름, 업무(job_id), 업무명(job_title)을 출력(두가지 방식)
select employee_id,last_name,e.job_id,job_title 
from employees e 
join jobs j on e.job_id=j.job_id
where employee_id=120;

select employee_id,last_name,e.job_id,job_title from employees e,jobs j 
where employee_id=120 and e.job_id=j.job_id;

--사번, 이름, department_name, job_title(employees, departments, jobs)
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM jobs;

SELECT e.employee_id, e.first_name, e.last_name, d.department_name, j.job_title
FROM employees e, departments d, jobs j
WHERE e.job_id=j.job_id AND e.department_id=d.department_id;

SELECT e.employee_id 사번, e.last_name 이름, d.department_name 사원, j.job_title 직무명
FROM employees e
join departments d
on e.department_id = d.department_id
join jobs j
on e.job_id = j.job_id;

--self join 하나의 테이블이 두 개의 테이블인 것처럼 조인
SELECT e.employee_id 사번, e.last_name 이름, m.last_name, m.manager_id 
FROM employees e, employees m
WHERE e.employee_id = m.manager_id;

--outer join: 조인 조건에 만족하지 못하더라도 해당 행을 나타내고 싶을 때 사용
SELECT e.employee_id 사번, e.last_name 이름, m.last_name, m.manager_id
FROM employees e, employees m
WHERE e.employee_id=m.manager_id(+);

--UNION(두 결과를 합치면서 중복 값 제거)
SELECT first_name 이름, salary 급여 FROM employees
WHERE salary < 5000
UNION
SELECT first_name 이름, salary 급여 FROM employees
WHERE hire_date < '99/01/01';

select * from employees;
--UNINON ALL(두 결과를 합치면서 중복 포함)
SELECT first_name 이름, salary 급여 FROM employees
WHERE salary < 5000
UNION ALL
SELECT first_name 이름, salary 급여 FROM employees
WHERE hire_date < '99/01/01';

--INTERSECT(교집합)
SELECT first_name 이름, salary 급여 FROM employees
WHERE salary < 5000
INTERSECT
SELECT first_name 이름, salary 급여 FROM employees
WHERE hire_date < '07/01/01';

--MINUS(차집합)
SELECT first_name 이름, salary 급여 FROM employees
WHERE salary < 5000
MINUS
SELECT first_name 이름, salary 급여 FROM employees
WHERE hire_date < '07/01/01';

SELECT employee_id, last_name, manager_id 
FROM employees
WHERE last_name='Kumar';

--Q.100번 부서의 구성원 모두의 급여보다 더 많은 급여를 받는 사원을 출력
select e.last_name, e.salary from employees e
where e.salary > ALL(select (salary) from employees where department_id = 100);


--[과제] 2005년 이후에 입사한 직원의 사번, 이름, 입사일, 부서명(department_name), 업무명(job_title)을 출력
SELECT e.employee_id,e.last_name,hire_date,department_name,job_title
FROM employees e, departments d, jobs j
WHERE e.department_id=d.department_id AND e.job_id=j.job_id and hire_date >= '05/01/01'
ORDER BY hire_date;

--[과제]job_title, department_name별로 평균 연봉을 구한 후 출력하세요. 
SELECT job_title, department_name, ROUND(AVG(salary)) "평균 연봉"
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id AND e.job_id=j.job_id
GROUP BY job_title, department_name;

--[과제]평균보다 많은 급여를 받는 직원 검색 후 출력하세요.
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--[과제]last_name이 King인 직원의 last_name, hire_date, department_id를 출력하세요
SELECT last_name, hire_date, department_id
FROM employees
WHERE LOWER(last_name)='king';

--[과제] 사번, 이름, 직급, 출력하세요. 단, 직급은 아래 기준에 의함
--salary > 20000 then '대표이사'
--salary > 15000 then '이사' 
--salary > 10000 then '부장' 
--salary > 5000 then '과장' 
--salary > 3000 then '대리'
--나머지 '사원'
SELECT employee_id 사번, last_name 이름,
CASE WHEN salary > 20000 then '대표이사'
WHEN salary > 15000 then '이사' 
WHEN salary > 10000 then '부장' 
WHEN salary > 5000 then '과장' 
WHEN salary > 3000 then '대리'
ELSE '사원'
END AS 직급
FROM employees;
