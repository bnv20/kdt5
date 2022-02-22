--[테이블 생성 규칙]

--테이블명은 객체를 의미할 수 있는 적절한 이름을 사용한다. 가능한 단수형을 권고한다.--
--테이블명은 다른 테이블의 이름과 중복되지 않아야 한다.--
--한 테이블 내에서는 칼럼명이 중복되게 지정될 수 없다. --
--테이블 이름을 지정하고 각 칼럼들은 괄호 "( )" 로 묶어 지정한다.--
--각 칼럼들은 콤마" ", 로 구분되고, 항상 끝은 세미콜론 ";"으로 끝난다.--
--칼럼에 대해서는 다른 테이블까지 고려하여 데이터베이스 내에서는 일관성 있게 사용하는 것이 좋다. (데이터 표준화 관점)--
--칼럼 뒤에 데이터 유형은 꼭 지정되어야 한다.--
--테이블명과 칼럼명은 반드시 문자로 시작해야 하고, 벤더별로 길이에 대한 한계가 있다.--
--벤더에서 사전에 정의한 예약어(Reserved word)는 쓸 수 없다.--
--A-Z, a-z, 0-9, _, $, # 문자만 허용된다.

select * from tabs;
CREATE TABLE MEMBER
(
ID       VARCHAR2(50),
PWD      VARCHAR2(50),
NAME     VARCHAR2(50),
GENDER   VARCHAR2(50),
AGE      NUMBER,
BIRTHDAY VARCHAR2(50),
PHONE    VARCHAR2(50),
REGDATE  DATE
);

DROP TABLE MEMBER;

CREATE TABLE MEMBER
(
ID       VARCHAR2(20),
PWD      VARCHAR2(20),
NAME     VARCHAR2(20),
GENDER   NCHAR(2),
AGE      NUMBER(3),
BIRTHDAY VARCHAR2(10),
PHONE    VARCHAR2(13),
REGDATE  DATE
);
--일부 속성만 입력
INSERT INTO MEMBER(ID, PWD, NAME)VALUES('200901','111','KEVIN'); 
SELECT * FROM MEMBER;
--전체 모두 입력
INSERT INTO MEMBER VALUES('200902','112','JAMES','M',29,'01-JAN-99','010-1234-2345','1994/05/02');

SELECT * FROM MEMBER;

ALTER TABLE MEMBER ADD TEXT NCLOB;

INSERT INTO MEMBER(ID, PWD,TEXT) VALUES('200903','112','정치는 국민을 위해 존재한다');

--기존 테이블을 이용하여 새로운 테이블을 생성
CREATE TABLE MEMBER1 AS SELECT * FROM MEMBER;
SELECT * FROM MEMBER1;
DESC member1;
CREATE TABLE member2 AS SELECT * FROM member1 WHERE 1=0;
DESC member2;

--테이블의 모근 row 삭제
TRUNCATE TABLE member1;

--테이블 속성 및 타입 조회
DESC MEMBER;
--테이블 리스트 조회
SELECT * FROM TABS;

--ALTER
DESC MEMBER1;
--수정
ALTER TABLE MEMBER1 MODIFY(ID VARCHAR2(50), NAME NVARCHAR2(50));
--변경
ALTER TABLE MEMBER1 RENAME COLUMN BIRTHDAY TO BD;
--삭제
ALTER TABLE MEMBER1 DROP COLUMN AGE;
--추가
ALTER TABLE MEMBER1 ADD AGE NUMBER;

ALTER TABLE MEMBER1 ADD CONSTRAINT MEMBER1_PK PRIMARY KEY (ID);

--[과제] MEMBER2 테이블을 생성한 후 수정, 변경, 삭제, 추가 작업을 수행하세요.(학생 이력 table, 속성은 5개 이상)

--트랜잭션
--SAVEPOINT 이름 : 현재까지의 트랜잭션을 특정 이름으로 지정하는 명령
--ROLLBACK TO 이름 : 저장되지 않은 데이터를 모두 취소하고 트랜잭션을 종료
--COMMIT : 저장되지 않은 모든 제이터베이스를 저장하고 현재의 트랜잭션을 종료

SELECT * FROM member1;
TRUNCATE TABLE member1;
COMMIT;

INSERT INTO member1 (ID, PWD, NAME) VALUES('200901','111','KEVIN');
SAVEPOINT SV1;
INSERT INTO member1 (ID, PWD, NAME, AGE) VALUES('200902','112','JAMES',25);
UPDATE member1 SET PWD='121' WHERE NAME='KEVIN';
UPDATE member1 SET PWD='122', AGE='20' WHERE ID='200902';
SAVEPOINT SV2;
INSERT INTO member1 (ID, PWD, NAME, AGE) VALUES('200903','113','SUSAN',35);
--ROLLBACK TO SV1;
UPDATE member1 SET PWD='131' WHERE NAME='KEVIN';
ROLLBACK TO SV2;
DELETE member1 WHERE ID = '200901';
DELETE member1 WHERE ID = '200902';
COMMIT;
