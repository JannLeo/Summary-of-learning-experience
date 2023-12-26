USE demo11;
SELECT	 d.`DNAME`
FROM department d	
LEFT JOIN employee e
ON d.`DEPTNO`=e.`DEPTNO`
WHERE e.`DEPTNO`IS NULL
	
/*SELECT DISTINCT   DEPTNO	  FROM employee; */