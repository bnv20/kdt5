--2014 ~ 2015년 사이의 4개 회사 구매 데이터
SELECT COUNT(*) FROM PURPROD;
--고객 속성정보 : 19383명(고객수)
SELECT * FROM CUSTDEMO;
SELECT COUNT(*) FROM custdemo;
SELECT * FROM COMPET;
SELECT * FROM CHANNEL;
SELECT * FROM MEMBERSHIP;
SELECT * FROM PRODCL;
SELECT * FROM PURPROD;

--# 구매 분석(매출 분석)
SELECT YEAR, ROUND(SUM(구매금액)/1000000) 총구매액, ROUND(AVG(구매금액)) 평균구매액
FROM PURPROD
GROUP BY YEAR;

--# 고객 속성
--성별, 연령별, 거주지별,다양한 조합별 매출 변화 
--경쟁사 이용, 멤버십 이용, 온라인 채널에 대한 매출 특이성

--# 고객 구매행동 패턴의 변화
--다양한 고객 유형별 구매 증감, 상품 구매 패턴, 구매 형태(시간, 장소 등)

--# 유통 환경에 대한 이해(도매인)

ALTER TABLE PURPROD ADD YEAR NUMBER;
UPDATE PURPROD SET YEAR=substr(구매일자,1,4);
COMMIT;

SELECT * FROM PURPROD;
COMMIT;
CREATE TABLE PURBYYEAR AS
SELECT 고객번호, YEAR, SUM(구매금액) 구매액
FROM PURPROD
GROUP BY 고객번호, YEAR
ORDER BY 고객번호;

SELECT * FROM PURBYYEAR;




CREATE TABLE pur_amt AS
SELECT 고객번호 cusno, sum(구매금액) puramt
FROM PURPROD
GROUP BY 고객번호 
ORDER BY 고객번호;