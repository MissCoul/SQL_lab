REM   Script: minilab2
REM   assignment 

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND > 1 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            AND n.registered = 1 
    		 
            )  
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            AND n.registered = 1 
    		AND a.appointment_id > 1 
            )  
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT a.appointment_id  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            AND n.registered = 1 
    		AND COUNT(a.appointment_id) > 1 
            )  
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT a.appointment_id  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            
    		AND COUNT(a.appointment_id) > 1 
            )  
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT a.appointment_id  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            AND n.registered = 1 
    	  HAVING COUNT(a.appointment_id) > 1 
            )  
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            AND n.registered = 1 
    	   
            )  
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
            AND n.registered = 1 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
             
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
           AND n.registered = ('1') 
           
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
           AND n.registered = ('1') 
          HAVING COUNT(a.appointment_id) >= ('2')  
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
           AND n.registered = ('1') 
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
           AND n.registered = '1' 
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
          
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
             AND n.registered = TRUE 
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
              
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
             AND n.registered = 'Y' 
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
             AND n.registered = 'Y' 
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

DROP TABLE physician CASCADE CONSTRAINTS;

CREATE TABLE physician ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE nurse CASCADE CONSTRAINTS;

CREATE TABLE nurse ( 
    employee_id NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    position    VARCHAR2(200) NOT NULL, 
    registered  CHAR(1) NOT NULL, 
    ssn         NUMBER(10, 0) NOT NULL 
);

DROP TABLE patient CASCADE CONSTRAINTS;

CREATE TABLE patient ( 
    ssn          NUMBER(10, 0) PRIMARY KEY, 
    name         VARCHAR2(200) NOT NULL, 
    address      VARCHAR2(200) NOT NULL, 
    phone        VARCHAR2(200) NOT NULL, 
    insurance_id NUMBER(10, 0) NOT NULL, 
    pcp          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( pcp ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE appointment CASCADE CONSTRAINTS;

CREATE TABLE appointment ( 
    appointment_id   NUMBER(10, 0) PRIMARY KEY, 
    patient          NUMBER(10, 0) NOT NULL, 
    prep_nurse       NUMBER(10, 0), 
    physician        NUMBER(10, 0) NOT NULL, 
    start_date       DATE NOT NULL, 
    end_date         DATE NOT NULL, 
    examination_room VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( prep_nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ) 
);

DROP TABLE department CASCADE CONSTRAINTS;

CREATE TABLE department ( 
    department_id NUMBER(10, 0) PRIMARY KEY, 
    name          VARCHAR2(200) NOT NULL, 
    head          NUMBER(10, 0) NOT NULL, 
    FOREIGN KEY ( head ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE procedures CASCADE CONSTRAINTS;

CREATE TABLE procedures ( 
    code NUMBER(10, 0) PRIMARY KEY, 
    name VARCHAR2(200) NOT NULL, 
    cost BINARY_DOUBLE NOT NULL 
);

DROP TABLE blocks CASCADE CONSTRAINTS;

CREATE TABLE blocks ( 
    floor NUMBER(10, 0) NOT NULL, 
    code  NUMBER(10, 0) NOT NULL, 
    PRIMARY KEY ( floor, 
                  code ) 
);

DROP TABLE medication CASCADE CONSTRAINTS;

CREATE TABLE medication ( 
    code        NUMBER(10, 0) PRIMARY KEY, 
    name        VARCHAR2(200) NOT NULL, 
    brand       VARCHAR2(200) NOT NULL, 
    description VARCHAR2(200) NOT NULL 
);

DROP TABLE affiliated_with CASCADE CONSTRAINTS;

CREATE TABLE affiliated_with ( 
    physician           NUMBER(10, 0) NOT NULL, 
    department          NUMBER(10, 0) NOT NULL, 
    primary_affiliation CHAR(1 BYTE) NOT NULL, 
    PRIMARY KEY ( physician, 
                  department ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ) 
);

DROP TABLE trained_in CASCADE CONSTRAINTS;

CREATE TABLE trained_in ( 
    physician             NUMBER(10, 0) NOT NULL, 
    treatment             NUMBER(10, 0) NOT NULL, 
    certification_date    DATE NOT NULL, 
    certification_expires DATE NOT NULL, 
    PRIMARY KEY ( physician, 
                  treatment ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( treatment ) 
        REFERENCES procedures ( code ) 
);

DROP TABLE prescribes CASCADE CONSTRAINTS;

CREATE TABLE prescribes ( 
    physician         NUMBER(10, 0) NOT NULL, 
    patient           NUMBER(10, 0) NOT NULL, 
    medication        NUMBER(10, 0) NOT NULL, 
    prescription_date DATE NOT NULL, 
    appointment       NUMBER(10, 0), 
    dose              VARCHAR2(200) NOT NULL, 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( medication ) 
        REFERENCES medication ( code ), 
    FOREIGN KEY ( appointment ) 
        REFERENCES appointment ( appointment_id ), 
    PRIMARY KEY ( physician, 
                  patient, 
                  medication, 
                  prescription_date ) 
);

DROP TABLE room CASCADE CONSTRAINTS;

CREATE TABLE room ( 
    room_number  NUMBER(10, 0) PRIMARY KEY, 
    room_type    VARCHAR2(200) NOT NULL, 
    block_floor  NUMBER(10, 0) NOT NULL, 
    block_code   NUMBER(10, 0) NOT NULL, 
    unavailable  CHAR(1) NOT NULL, 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE on_call CASCADE CONSTRAINTS;

CREATE TABLE on_call ( 
    nurse       NUMBER(10, 0) NOT NULL, 
    block_floor NUMBER(10, 0) NOT NULL, 
    block_code  NUMBER(10, 0) NOT NULL, 
    start_date  DATE NOT NULL, 
    end_date    DATE NOT NULL, 
    PRIMARY KEY ( nurse, 
                  block_floor, 
                  block_code, 
                  start_date, 
                  end_date ), 
    FOREIGN KEY ( nurse ) 
        REFERENCES nurse ( employee_id ), 
    FOREIGN KEY ( block_floor, 
                  block_code ) 
        REFERENCES blocks ( floor, 
                            code ) 
);

DROP TABLE stay CASCADE CONSTRAINTS;

CREATE TABLE stay ( 
    stay_id    NUMBER(10, 0) PRIMARY KEY, 
    patient    NUMBER(10, 0) NOT NULL, 
    room       NUMBER(10, 0) NOT NULL, 
    start_date DATE NOT NULL, 
    end_date   DATE NOT NULL, 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( room ) 
        REFERENCES room ( room_number ) 
);

DROP TABLE undergoes CASCADE CONSTRAINTS;

CREATE TABLE undergoes ( 
    patient         NUMBER(10, 0) NOT NULL, 
    procedur       NUMBER(10, 0) NOT NULL, 
    stay            NUMBER(10, 0) NOT NULL, 
    operation_date  DATE NOT NULL, 
    physician       NUMBER(10, 0) NOT NULL, 
    assistingnurse  NUMBER(10, 0), 
    FOREIGN KEY ( patient ) 
        REFERENCES patient ( ssn ), 
    FOREIGN KEY ( procedur ) 
        REFERENCES procedures ( code ), 
    FOREIGN KEY ( stay ) 
        REFERENCES stay ( stay_id ), 
    FOREIGN KEY ( physician ) 
        REFERENCES physician ( employee_id ), 
    FOREIGN KEY ( assistingnurse ) 
        REFERENCES nurse ( employee_id ));

INSERT INTO physician VALUES (1, 'John Dorian', 'Staff Internist', 111111111);

INSERT INTO physician VALUES (2, 'Elliot Reid', 'Attending Physician', 222222222);

INSERT INTO physician VALUES(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333);

INSERT INTO physician VALUES(4, 'Percival Cox', 'Senior Attending Physician', 444444444);

INSERT INTO physician VALUES(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555);

INSERT INTO physician VALUES(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666);

INSERT INTO physician VALUES(7, 'John Wen', 'Surgical Attending Physician', 777777777);

INSERT INTO physician VALUES(8, 'Keith Dudemeister', 'MD Resident', 888888888);

INSERT INTO physician VALUES(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO department VALUES(1, 'General Medicine', 4);

INSERT INTO department VALUES(2, 'Surgery', 7);

INSERT INTO department VALUES(3, 'Psychiatry', 9);

INSERT INTO affiliated_with VALUES(1, 1, 'Y');

INSERT INTO affiliated_with VALUES(2, 1, 'Y');

INSERT INTO affiliated_with VALUES(3, 1, 'N');

INSERT INTO affiliated_with VALUES(3, 2, 'Y');

INSERT INTO affiliated_with VALUES(4, 1, 'Y');

INSERT INTO affiliated_with VALUES(5, 1, 'Y');

INSERT INTO affiliated_with VALUES(6, 2, 'Y');

INSERT INTO affiliated_with VALUES(7, 1, 'N');

INSERT INTO affiliated_with VALUES(7, 2, 'Y');

INSERT INTO affiliated_with VALUES(8, 1, 'Y');

INSERT INTO affiliated_with VALUES(9, 3, 'Y');

INSERT INTO procedures VALUES(1, 'Reverse Rhinopodoplasty', 1500.0);

INSERT INTO procedures VALUES(2, 'Obtuse Pyloric Recombobulation', 3750.0);

INSERT INTO procedures VALUES(3, 'Folded Demiophtalmectomy', 4500.0);

INSERT INTO procedures VALUES(4, 'Complete Walletectomy', 10000.0);

INSERT INTO procedures VALUES(5, 'Obfuscated Dermogastrotomy', 4899.0);

INSERT INTO procedures VALUES(6, 'Reversible Pancreomyoplasty', 5600.0);

INSERT INTO procedures VALUES(7, 'Follicular Demiectomy', 25.0);

INSERT INTO patient VALUES(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1);

INSERT INTO patient VALUES(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2);

INSERT INTO patient VALUES(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2);

INSERT INTO patient VALUES(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);

INSERT INTO nurse VALUES(101, 'Carla Espinosa', 'Head Nurse', 'Y', 111111110);

INSERT INTO nurse VALUES(102, 'Laverne Roberts', 'Nurse', 'Y', 222222220);

INSERT INTO nurse VALUES(103, 'Paul Flowers', 'Nurse', 'N', 333333330);

INSERT INTO blocks VALUES(1, 1);

INSERT INTO blocks VALUES(1, 2);

INSERT INTO blocks VALUES(1, 3);

INSERT INTO blocks VALUES(2, 1);

INSERT INTO blocks VALUES(2, 2);

INSERT INTO blocks VALUES(2, 3);

INSERT INTO blocks VALUES(3, 1);

INSERT INTO blocks VALUES(3, 2);

INSERT INTO blocks VALUES(3, 3);

INSERT INTO blocks VALUES(4, 1);

INSERT INTO blocks VALUES(4, 2);

INSERT INTO blocks VALUES(4, 3);

INSERT INTO room VALUES(101, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(102, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(103, 'Single', 1, 1, 'N');

INSERT INTO room VALUES(111, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(112, 'Single', 1, 2, 'Y');

INSERT INTO room VALUES(113, 'Single', 1, 2, 'N');

INSERT INTO room VALUES(121, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(122, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(123, 'Single', 1, 3, 'N');

INSERT INTO room VALUES(201, 'Single', 2, 1, 'Y');

INSERT INTO room VALUES(202, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(203, 'Single', 2, 1, 'N');

INSERT INTO room VALUES(211, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(212, 'Single', 2, 2, 'N');

INSERT INTO room VALUES(213, 'Single', 2, 2, 'Y');

INSERT INTO room VALUES(221, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(222, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(223, 'Single', 2, 3, 'N');

INSERT INTO room VALUES(301, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(302, 'Single', 3, 1, 'Y');

INSERT INTO room VALUES(303, 'Single', 3, 1, 'N');

INSERT INTO room VALUES(311, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(312, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(313, 'Single', 3, 2, 'N');

INSERT INTO room VALUES(321, 'Single', 3, 3, 'Y');

INSERT INTO room VALUES(322, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(323, 'Single', 3, 3, 'N');

INSERT INTO room VALUES(401, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(402, 'Single', 4, 1, 'Y');

INSERT INTO room VALUES(403, 'Single', 4, 1, 'N');

INSERT INTO room VALUES(411, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(412, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(413, 'Single', 4, 2, 'N');

INSERT INTO room VALUES(421, 'Single', 4, 3, 'Y');

INSERT INTO room VALUES(422, 'Single', 4, 3, 'N');

INSERT INTO room VALUES(423, 'Single', 4, 3, 'N');

INSERT INTO appointment VALUES(13216584, 100000001, 101, 1, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(26548913, 100000002, 101, 2, TO_DATE('2008-04-24 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-24 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(36549879, 100000001, 102, 1, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(46846589, 100000004, 103, 4, TO_DATE('2008-04-25 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-25 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO appointment VALUES(59871321, 100000004, NULL, 4, TO_DATE('2008-04-26 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(69879231, 100000003, 103, 2, TO_DATE('2008-04-26 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(76983231, 100000001, NULL, 3, TO_DATE('2008-04-26 12:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-26 13:00', 'yyyy-mm-dd hh24:mi'), 'C');

INSERT INTO appointment VALUES(86213939, 100000004, 102, 9, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-21 11:00', 'yyyy-mm-dd hh24:mi'), 'A');

INSERT INTO appointment VALUES(93216548, 100000002, 101, 2, TO_DATE('2008-04-27 10:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-04-27 11:00', 'yyyy-mm-dd hh24:mi'), 'B');

INSERT INTO medication VALUES(1, 'Procrastin-X', 'X', 'N/A');

INSERT INTO medication VALUES(2, 'Thesisin', 'Foo Labs', 'N/A');

INSERT INTO medication VALUES(3, 'Awakin', 'Bar Laboratories', 'N/A');

INSERT INTO medication VALUES(4, 'Crescavitin', 'Baz Industries', 'N/A');

INSERT INTO medication VALUES(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO prescribes VALUES(1, 100000001, 1, TO_DATE('2008-04-24 10:47', 'yyyy-mm-dd hh24:mi'), 13216584, '5');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-27 10:53', 'yyyy-mm-dd hh24:mi'), 86213939, '10');

INSERT INTO prescribes VALUES(9, 100000004, 2, TO_DATE('2008-04-30 16:53', 'yyyy-mm-dd hh24:mi'), NULL, '5');

INSERT INTO on_call VALUES(101, 1, 1, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(101, 1, 2, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(102, 1, 3, TO_DATE('2008-11-04 11:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 1, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 2, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO on_call VALUES(103, 1, 3, TO_DATE('2008-11-04 19:00', 'yyyy-mm-dd hh24:mi'), TO_DATE('2008-11-05 03:00', 'yyyy-mm-dd hh24:mi'));

INSERT INTO stay VALUES(3215, 100000001, 111, TO_DATE('2008-05-01', 'yyyy-mm-dd'), TO_DATE('2008-05-04', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3216, 100000003, 123, TO_DATE('2008-05-03', 'yyyy-mm-dd'), TO_DATE('2008-05-14', 'yyyy-mm-dd'));

INSERT INTO stay VALUES(3217, 100000004, 112, TO_DATE('2008-05-02', 'yyyy-mm-dd'), TO_DATE('2008-05-03', 'yyyy-mm-dd'));

INSERT INTO undergoes VALUES(100000001, 6, 3215, TO_DATE('2008-05-02', 'yyyy-mm-dd'), 3, 101);

INSERT INTO undergoes VALUES(100000001, 2, 3215, TO_DATE('2008-05-03', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 1, 3217, TO_DATE('2008-05-07', 'yyyy-mm-dd'), 3, 102);

INSERT INTO undergoes VALUES(100000004, 5, 3217, TO_DATE('2008-05-09', 'yyyy-mm-dd'), 6, NULL);

INSERT INTO undergoes VALUES(100000001, 7, 3217, TO_DATE('2008-05-10', 'yyyy-mm-dd'), 7, 101);

INSERT INTO undergoes VALUES(100000004, 4, 3217, TO_DATE('2008-05-13', 'yyyy-mm-dd'), 3, 103);

INSERT INTO trained_in VALUES(3, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(3, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 5, TO_DATE('2007-01-01', 'yyyy-mm-dd'), TO_DATE('2007-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(6, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 1, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 2, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 3, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 4, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 5, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 6, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

INSERT INTO trained_in VALUES(7, 7, TO_DATE('2008-01-01', 'yyyy-mm-dd'), TO_DATE('2008-12-31', 'yyyy-mm-dd'));

SELECT name AS "Physician" 
FROM physician 
WHERE employee_id IN 
    ( SELECT undergoes.physician 
     FROM undergoes 
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician 
     AND undergoes.procedur=trained_in.treatment 
     WHERE treatment IS NULL );

SELECT p.name AS "Physician", 
       pr.name AS "Procedures", 
       u.operation_date, 
       pt.name AS "Patient" 
FROM physician p, 
     undergoes u, 
     patient pt, 
     procedures pr 
WHERE u.patient = pt.SSN 
  AND u.procedur = pr.Code 
  AND u.physician = p.employee_id 
  AND NOT EXISTS 
    ( SELECT * 
     FROM trained_in t 
     WHERE t.treatment = u.procedur 
       AND t.physician = u.physician );

SELECT name  
  FROM physician  
 WHERE employee_id IN  
       ( 
         SELECT physician FROM undergoes u  
          WHERE operation_date >  
               ( 
                  SELECT certification_expires  
                    FROM trained_in t  
                   WHERE t.physician = u.physician  
                     AND t.treatment = u.procedur 
               ) 
       );

SELECT p.name AS physician, pr.name AS procedures, u.operation_date, pt.name AS patient, t.certification_expires 
  FROM physician p, undergoes u, patient pt, procedures pr, trained_in t 
  WHERE u.patient = pt.SSN 
    AND u.procedur = pr.Code 
    AND u.Physician = P.employee_id 
    AND pr.Code = t.treatment 
    AND p.employee_id = t.physician 
    AND u.operation_date > t.certification_expires;

SELECT pt.name AS patient, ph.name AS physician, n.name AS nurse, a.start_date, a.end_date, a.examination_room, phpcp.name AS pcp 
  FROM patient pt, physician ph, physician phpcp, appointment a LEFT JOIN nurse n ON a.prep_nurse = n.employee_id 
 WHERE a.patient = pt.SSN 
   AND a.physician = ph.employee_id 
   AND pt.pcp = phpcp.employee_id 
   AND a.physician <> pt.pcp;

SELECT * FROM undergoes u 
 WHERE patient <>  
   ( 
     SELECT patient FROM stay s 
      WHERE u.stay = s.stay_id 
   );

SELECT n.name FROM nurse n 
 WHERE employee_id IN 
   ( 
     SELECT oc.nurse FROM on_call oc, room r 
      WHERE oc.block_floor = r.block_floor 
        AND oc.block_code = r.block_code 
        AND r.room_number = 123 
   );

SELECT examination_room, COUNT(appointment_id) AS room_number 
  FROM appointment 
  GROUP BY examination_room ;

SELECT pt.name, phpcp.name FROM patient pt, physician phpcp 
 WHERE pt.pcp = phpcp.employee_id 
   AND EXISTS 
       ( 
         SELECT * FROM prescribes pr 
          WHERE pr.patient = pt.ssn 
            AND pr.physician = pt.pcp 
       ) 
   AND EXISTS 
       ( 
         SELECT * FROM undergoes u, procedures pr 
          WHERE u.procedur = pr.code 
            AND u.patient = pt.ssn 
            AND pr.cost > 5000 
       ) 
    AND EXISTS 
       ( 
         SELECT COUNT(a.appointment_id)  
    	  FROM appointment a, nurse n 
          WHERE a.prep_nurse = n.employee_id 
             AND n.registered = 'Y' 
          HAVING COUNT(a.appointment_id) >= 2 
            )  
     
   AND NOT pt.pcp IN 
       ( 
          SELECT head FROM department 
       ) ;

