--Q. 다음 사항을 수행하세요.

--테이블 2개 생성(제약 조건 포함)

--데이터 각각 5개씩 삽입

--속성 타입 수정, 데이터 값 변경, 속성 이름 변경, 제약조건 추가, savepoint 2개 포함

--savepoint 1번으로 rollback후 동일작업 수행

--savepoint 2번으로 rollback후 동일작업 수행

--작업내용을 확정

--2개 테이블 Join (inner join, left outer join, right outer join, full outer join)을 수행

--2개 테이블에 대하여 각 조건별로 결과물을 조회하고 그 결과물에 대하여 합집합(중복포함 및 미포함), 교집함, 차집함을 출력하세요. 


--[과제] HR EMPLOYEES 테이블에서 escape 옵션을 사용하여 아래와 같이 출력되는 SQL문을 작성하세요. 
--job_id 칼럼에서  _을 와일드카드가 아닌 문자로 취급하여 '_A'를 포함하는  모든 행을 출력
select job_id from employees
where job_id like '%#_A%' escape '#';

--[과제] employees 테이블에서 이름에 FIRST_NAME에 LAST_NAME을 붙여서 'NAME' 컬럼명으로 출력하세요.
--예) Steven King 
SELECT CONCAT(CONCAT(first_name,' '),last_name) name FROM employees;
SELECT first_name||' '||last_name name FROM employees;

--[과제] Seo라는 사람의 부서명을 출력하세요.
select last_name, department_name from employees e
join departments d on d.department_id=e.department_id
where last_name = 'Seo';
SELECT department_name FROM departments
WHERE department_id=(SELECT department_id FROM employees WHERE last_name='Seo');

--[과제] HR 테이블들을 분석해서 전체 현황을 설명할 수 있는 요약 테이블 3개를 작성하세요.
--예)부서별 salary 순위

