CREATE database Sakila;

use Sakila;
-- 
-- Table structure for table `departments` 
-- 
CREATE TABLE IF NOT EXISTS `departments` ( 
`DEPARTMENT_ID` decimal(4,0) NOT NULL DEFAULT '0', 
`DEPARTMENT_NAME` varchar(30) NOT NULL, 
`MANAGER_ID` decimal(6,0) DEFAULT NULL, 
`LOCATION_ID` decimal(4,0) DEFAULT NULL, 
PRIMARY KEY (`DEPARTMENT_ID`), 
KEY `DEPT_MGR_FK` (`MANAGER_ID`), 
KEY `DEPT_LOCATION_IX` (`LOCATION_ID`) 
) ; 
-- 
-- Dumping data for table `departments` 
-- 
INSERT INTO `departments` (`DEPARTMENT_ID`, `DEPARTMENT_NAME`, `MANAGER_ID`, `LOCATION_ID`) VALUES 
('10', 'Administration', '200', '1700'), 
('20', 'Marketing', '201', '1800'), 
('30', 'Purchasing', '114', '1700'), 
('40', 'Human Resources', '203', '2400'), 
('50', 'Shipping', '121', '1500'), 
('60', 'IT', '103', '1400'), 
('70', 'Public Relations', '204', '2700'), 
('80', 'Sales', '145', '2500'), 
('90', 'Executive', '100', '1700'), 
('100', 'Finance', '108', '1700'), 
('110', 'Accounting', '205', '1700'), 
('120', 'Treasury', '0', '1700'), 
('130', 'Corporate Tax', '0', '1700'), 
('140', 'Control And Credit', '0', '1700'), 
('150', 'Shareholder Services', '0', '1700'), 
('160', 'Benefits', '0', '1700'), 
('170', 'Manufacturing', '0', '1700'), 
('180', 'Construction', '0', '1700'), 
('190', 'Contracting', '0', '1700'), 
('200', 'Operations', '0', '1700'), 
('210', 'IT Support', '0', '1700'), 
('220', 'NOC', '0', '1700'), 
('230', 'IT Helpdesk', '0', '1700'), 
('240', 'Government Sales', '0', '1700'), 
('250', 'Retail Sales', '0', '1700'), 
('260', 'Recruiting', '0', '1700'), 
('270', 'Payroll', '0', '1700'); 
-- -------------------------------------------------------- 


-- Table structure for table `employees` 
-- 
CREATE TABLE IF NOT EXISTS `employees` ( 
`EMPLOYEE_ID` decimal(6,0) NOT NULL DEFAULT '0', 
`FIRST_NAME` varchar(20) DEFAULT NULL, 
`LAST_NAME` varchar(25) NOT NULL, 
`EMAIL` varchar(25) NOT NULL, 
`PHONE_NUMBER` varchar(20) DEFAULT NULL, 
`HIRE_DATE` date NOT NULL, 
`JOB_ID` varchar(10) NOT NULL, 
`SALARY` decimal(8,2) DEFAULT NULL, 
`COMMISSION_PCT` decimal(2,2) DEFAULT NULL, 
`MANAGER_ID` decimal(6,0) DEFAULT NULL, 
`DEPARTMENT_ID` decimal(4,0) DEFAULT NULL, 
PRIMARY KEY (`EMPLOYEE_ID`), 
UNIQUE KEY `EMP_EMAIL_UK` (`EMAIL`), 
KEY `EMP_DEPARTMENT_IX` (`DEPARTMENT_ID`), 
KEY `EMP_JOB_IX` (`JOB_ID`), 
KEY `EMP_MANAGER_IX` (`MANAGER_ID`), 
KEY `EMP_NAME_IX` (`LAST_NAME`,`FIRST_NAME`) 
) ; 
-- 
-- Dumping data for table `employees` 
-- 
INSERT INTO `employees` (`EMPLOYEE_ID`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`, `PHONE_NUMBER`, `HIRE_DATE`, `JOB_ID`, `SALARY`, `COMMISSION_PCT`, `MANAGER_ID`, `DEPARTMENT_ID`) VALUES 
('100', 'Steven', 'King', 'SKING', '515.123.4567', '1987-06-17', 'AD_PRES', '24000.00', '0.00', '0', '90'), 
('101', 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '1987-06-18', 'AD_VP', '17000.00', '0.00', '100', '90'), 
('102', 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '1987-06-19', 'AD_VP', '17000.00', '0.00', '100', '90'), 
('103', 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '1987-06-20', 'IT_PROG', '9000.00', '0.00', '102', '60'), 
('104', 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '1987-06-21', 'IT_PROG', '6000.00', '0.00', '103', '60'), 
('105', 'David', 'Austin', 'DAUSTIN', '590.423.4569', '1987-06-22', 'IT_PROG', '4800.00', '0.00', '103', '60'), 
('106', 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '1987-06-23', 'IT_PROG', '4800.00', '0.00', '103', '60'), 
('107', 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '1987-06-24', 'IT_PROG', '4200.00', '0.00', '103', '60'), 
('108', 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '1987-06-25', 'FI_MGR', '12000.00', '0.00', '101', '100'), 
('109', 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '1987-06-26', 'FI_ACCOUNT', '9000.00', '0.00', '108', '100'), 
('110', 'John', 'Chen', 'JCHEN', '515.124.4269', '1987-06-27', 'FI_ACCOUNT', '8200.00', '0.00', '108', '100'), 
('111', 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '1987-06-28', 'FI_ACCOUNT', '7700.00', '0.00', '108', '100'), 
('112', 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', '1987-06-29', 'FI_ACCOUNT', '7800.00', '0.00', '108', '100'), 
('113', 'Luis', 'Popp', 'LPOPP', '515.124.4567', '1987-06-30', 'FI_ACCOUNT', '6900.00', '0.00', '108', '100'),

('114', 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '1987-07-01', 'PU_MAN', '11000.00', '0.00', '100', '30'), 
('115', 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '1987-07-02', 'PU_CLERK', '3100.00', '0.00', '114', '30'), 
('116', 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '1987-07-03', 'PU_CLERK', '2900.00', '0.00', '114', '30'), 
('117', 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', '1987-07-04', 'PU_CLERK', '2800.00', '0.00', '114', '30'); 