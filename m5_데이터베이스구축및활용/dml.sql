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