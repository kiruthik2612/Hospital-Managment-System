create database hospital_management_system;
use hospital_management_system;

 
CREATE TABLE patients (
    patient_id INt AUTO_INCREMENT PRIMARY KEY,
	medical_record_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	dob DATE NOT NULL,
    phone_number varchar(12) unique check(length(phone_number)=10),
    gender varchar(1) CHECK (gender IN ('M','F','O'))
);

CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('Doctor','Nurse','Admin')),
    department VARCHAR(50) NOT NULL
);
 
 CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    type VARCHAR(20) CHECK (type IN ('ICU','General','Private')),
    total_beds INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(15) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled','Completed','No-show')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);
 
 
CREATE TABLE admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    room_id INT NOT NULL,
    admitted_at DATE NOT NULL,
    discharged_at DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE diagnoses (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    illness VARCHAR(100) NOT NULL,
    diagnosis_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES staff(staff_id)
);


CREATE TABLE medications (
    medication_id  INT AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL
);

 
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    medication_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES staff(staff_id),
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
);

CREATE TABLE pharmacy_inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_id INT NOT NULL,
    stock_qty INT NOT NULL,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
);
 
 
CREATE TABLE tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    test_type VARCHAR(50) NOT NULL,
    ordered_date DATE NOT NULL,
    report_date DATE,
	expected_report_date DATE, -- NEW COLUMN
    status VARCHAR(15) DEFAULT 'Pending' CHECK (status IN ('Pending','Completed')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);
 -- alter table tests add column  expected_report_date DATE AFTER report_date;
 
 CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    payment_mode VARCHAR(25) CHECK(payment_mode IN ('E_wallet','G_Pay','Cash')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

 
CREATE TABLE alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    alert_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE supply_orders (
    supply_order_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    supplier_name VARCHAR(100),
    received_date DATE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
);

CREATE TABLE vitals (
    vital_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    heart_rate INT,
    bp_systolic INT,
    bp_diastolic INT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id));

-- Inserting values into the tables 

 INSERT INTO patients 
(medical_record_number, first_name, last_name, dob,phone_number, gender)VALUES
('MRN1','Aarav','Malhotra','1992-03-15','9897854685','M'),
('MRN2','Isha','Gupta','1994-07-22','9637539485','F'),
('MRN3','Kabir','Chopra','1996-10-05','9785462845','M'),
('MRN4','Ananya','Reddy','1998-12-11','6358947516','F'),
('MRN5','Vihaan','Bansal','1993-09-18','8946857954','M'),
('MRN6','Meera','Sharma','1995-04-29','7895846854','F'),
('MRN7','Advait','Joshi','1999-06-08','7584585545','M'),
('MRN8','Saanvi','Kapoor','2000-11-23','9658741452','F'),
('MRN09','Arjun','Iyer','1997-02-14','8798785847','M'),
('MRN10','Myra','Deshmukh','2001-08-30','8787898785','F');
 
INSERT INTO staff
(first_name, last_name, role, department)VALUES
('Raj','Mehta','Doctor','Cardiology'),
('Asha','Verma','Doctor','Neurology'),
('Sandeep','Singh','Doctor','Orthopedics'),
('Rekha','Nair','Doctor','Emergency'),
('Anil','Kumar','Doctor','Pediatrics'),
('Ramesh','Menon','Nurse','Cardiology'),
('Seema','Joshi','Nurse','Orthopedics'),
('Anita','Das','Nurse','Emergency'),
('Vikash','Shah','Admin','Billing'),
('Kiran','Patel','Admin','Reception');
-- update staff set department='Pediatrics' where staff_id=4;

INSERT INTO rooms 
(room_number, type, total_beds, is_available)VALUES
('101','ICU',2,TRUE),
('102','ICU',2,TRUE),
('201','General',4,TRUE),
('202','General',4,TRUE),
('203','Private',1,TRUE),
('204','Private',1,TRUE),
('301','General',3,TRUE),
('302','Private',1,TRUE),
('303','General',3,TRUE),
('304','Private',1,TRUE);

INSERT INTO appointments
(patient_id, doctor_id, appointment_date, appointment_time, status)VALUES
(1,1,'2025-01-01','09:30','Completed'),
(2,2,'2025-02-02','10:15','Scheduled'),
(3,3,'2025-03-15','11:00','Completed'),
(4,4,'2025-05-24','14:00','Completed'),
(5,5,'2025-05-15','15:30','Completed'),
(6,1,'2025-06-11','10:45','No-show'),
(7,2,'2025-08-17','12:00','Completed'),
(8,3,'2025-08-18','09:15','Completed'),
(9,4,'2025-09-08','13:30','Completed'),
(10,5,'2025-09-10','11:45','Completed');
 
INSERT INTO admissions 
(patient_id, doctor_id, room_id, admitted_at, discharged_at)VALUES
(1,1,1,'2025-08-20','2025-08-30'),
(2,2,2,'2025-08-15','2025-08-28'),
(3,3,3,'2025-08-10',NULL),
(4,4,4,'2025-08-12','2025-08-18'),
(5,5,5,'2025-08-05','2025-08-15'),
(6,1,6,'2025-07-30',NULL),
(7,3,7,'2025-07-25','2025-08-02'),
(8,2,8,'2025-08-22',NULL),
(9,4,9,'2025-07-10','2025-07-20'),
(10,5,10,'2025-08-01',NULL);

 
INSERT INTO diagnoses
(patient_id, doctor_id, illness, diagnosis_date)VALUES
(1,1,'Hypertension','2025-08-20'),
(2,2,'Migraine','2025-08-16'),
(3,3,'Fractured Arm','2025-08-11'),
(4,4,'Asthma Attack','2025-08-12'),
(5,5,'Viral Fever','2025-08-05'),
(6,1,'Heart Disease','2025-07-31'),
(7,3,'Back Pain','2025-07-26'),
(8,2,'Seizure','2025-08-23'),
(9,4,'Accident Trauma','2025-07-10'),
(10,5,'Bronchitis','2025-08-01');
 
INSERT INTO medications
(medication_id,medication_name)VALUES
(1,'Losartan'),
(2,'Paracetamol'),
(3,'Ibuprofen'),
(4,'Salbutamol'),
(5,'Paracetamol'),
(6,'Atorvastatin'),
(7,'Ibuprofen'),
(8,'Valproate'),
(9,'Ibuprofen'),
(10,'Amoxicillin');
 
INSERT INTO prescriptions 
(patient_id, doctor_id, medication_id, start_date, end_date)VALUES
(1,1,1,'2025-08-21','2025-08-28'),
(2,2,2,'2025-08-16','2025-08-20'),
(3,3,3,'2025-08-11','2025-08-18'),
(4,4,4,'2025-08-12','2025-08-17'),
(5,5,5,'2025-08-06','2025-08-10'),
(6,1,6,'2025-08-01','2025-08-15'),
(7,3,7,'2025-07-27','2025-08-03'),
(8,2,8,'2025-08-23','2025-08-28'),
(9,4,9,'2025-07-11','2025-07-15'),
(10,5,10,'2025-08-02','2025-08-08');
 
INSERT INTO tests 
(patient_id, test_type, ordered_date, report_date, expected_report_date, status)VALUES
(1,'Blood Test','2025-08-20','2025-08-21','2025-08-24','Completed'),
(2,'MRI Scan','2025-08-16',NULL,'2025-08-20','Pending'),
(3,'X-Ray','2025-08-11','2025-08-11','2025-08-15','Completed'),
(4,'Allergy Test','2025-08-12','2025-08-14','2025-08-18','Completed'),
(5,'Blood Test','2025-08-06','2025-08-06','2025-08-10','Completed'),
(6,'ECG','2025-08-01','2025-08-01','2025-08-01','Completed'),
(7,'CT Scan','2025-07-27',NULL,'2025-09-02','Pending'),
(8,'EEG','2025-08-23','2025-08-25','2025-08-25','Completed'),
(9,'Blood Test','2025-07-11','2025-07-12','2025-07-12','Completed'),
(10,'Chest X-Ray','2025-08-02',NULL,'2025-09-06','Pending');
 
 
 
INSERT INTO pharmacy_inventory (medication_id, stock_qty) VALUES
(1,50),(2,40),(3,35),(4,60),(5,25),(6,30),(7,45),(8,50),(9,20),(10,15);

INSERT INTO billing
(patient_id, total_amount, paid_amount,payment_mode)VALUES
(1,5000,5000, 'E_wallet'),
(2,3000,3000,'Cash'),
(3,7000,4000,'Cash'),
(4,2000,2000,'E_wallet'),
(5,1500,1500,'G_Pay'),
(6,8000,3000,'Cash'),
(7,4500,4500,'G_pay'),
(8,6000,2000,'Cash'),
(9,3500,3500,'E_wallet'),
(10,5000,1000,'G_pay');

INSERT INTO alerts (patient_id, alert_message, created_at) VALUES
(1,'Critical vitals! Notify doctor.','2025-08-30 10:15:00'),
(3,'Missed follow-up appointment.','2025-09-01 09:00:00'),
(6,'Medication stock low.','2025-08-25 08:30:00'),
(8,'Test report delayed.','2025-08-28 11:45:00'),
(2,'Billing discrepancy detected.','2025-08-26 14:00:00'),
(4,'Emergency admission alert.','2025-08-12 02:00:00'),
(5,'New prescription review needed.','2025-08-06 13:15:00'),
(7,'Surgery scheduled.','2025-07-28 10:00:00'),
(9,'Room availability updated.','2025-07-11 08:30:00'),
(10,'Patient ready for discharge.','2025-08-08 15:00:00');
 
 INSERT INTO supply_orders (medication_id, quantity, order_date, supplier_name, received_date) VALUES
(1, 200, '2025-01-10', 'MediCare Pharma', '2025-01-12'),
(2, 150, '2025-01-15', 'HealthFirst Supplies', '2025-01-16'),
(3, 300, '2025-02-01', 'Wellness Distributors', '2025-02-03'),
(4, 100, '2025-02-10', 'MediCare Pharma', '2025-02-11'),
(5, 250, '2025-02-20', 'PharmaLink', '2025-02-21'),
(6, 180, '2025-03-01', 'CureMed Suppliers', '2025-03-02'),
(7, 120, '2025-03-15', 'MediCare Pharma', '2025-03-16'),
(8, 220, '2025-03-20', 'HealthFirst Supplies', '2025-03-21'),
(9, 160, '2025-04-05', 'Wellness Distributors', '2025-04-06'),
(10, 300, '2025-04-12', 'PharmaLink', '2025-04-13');

INSERT INTO vitals (patient_id, recorded_at, heart_rate, bp_systolic, bp_diastolic)
VALUES
(1,'2025-08-30 08:00:00',110,150,95),
(2,'2025-08-30 08:15:00',90,120,80),
(3,'2025-08-30 08:30:00',100,130,85),
(4,'2025-08-30 08:45:00',88,118,78),
(5,'2025-08-30 09:00:00',92,125,82),
(6,'2025-08-30 09:15:00',120,160,100),
(7,'2025-08-30 09:30:00',95,122,84),
(8,'2025-08-30 09:45:00',85,115,75),
(9,'2025-08-30 10:00:00',105,140,90),
(10,'2025-08-30 10:15:00',98,128,85);   
   
   use hospital;
    -- Tasks

-- Tasks 1. Retrieve a list of all patients who have visited the hospital in the last six months.Patients who visited in the last 6 months
 
SELECT  DISTINCT p.patient_id, p.first_name, p.last_name, p.dob,p.phone_number,a.appointment_date
FROM patients p
JOIN appointments a ON a.patient_id = p.patient_id
WHERE a.appointment_date >=CURDATE()-INTERVAL 6 MONTH;

select* from appointments;

 -- Tasks 2. List the details of doctors along with their specializations and the number of patients they have treated.

SELECT s.staff_id, s.first_name, s.last_name, s.department AS specialization,
       COUNT(DISTINCT a.patient_id) AS patients_treated
FROM staff s
JOIN appointments a ON s.staff_id = a.doctor_id
WHERE s.role = 'Doctor'
GROUP BY s.staff_id, s.first_name, s.last_name, s.department
ORDER BY patients_treated DESC;

 -- Tasks 3. Find all appointments scheduled for 'Dr. Mehta' on 'March 15,2024', including patient details and appointment time.
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES (1, 1, '2024-03-15', '10:00', 'Completed');

SELECT a.appointment_id, CONCAT(p.first_name,' ',p.last_name) AS patient_name,CONCAT(s.first_name, ' ', s.last_name) as doctor_name, a.appointment_date,a.appointment_time
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN staff s ON a.doctor_id = s.staff_id
WHERE s.first_name = 'Raj' AND s.last_name = 'Mehta'
AND a.appointment_date = '2024-03-15'
ORDER BY a.appointment_time;

 -- Tasks 4. Identify patients who have been admitted for more than 10 days and calculate their total billing amount.
 
SELECT p.patient_id, p.first_name, p.last_name,
       DATEDIFF(IFNULL(a.discharged_at, CURDATE()), a.admitted_at) AS stay_length,
       b.total_amount
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN billing b ON p.patient_id = b.patient_id
WHERE DATEDIFF(IFNULL(a.discharged_at, CURDATE()), a.admitted_at) > 10;
-- or
/*SELECT p.patient_id, p.first_name, p.last_name,
       DATEDIFF(a.discharged_at, a.admitted_at) AS days_admitted,
       b.total_amount
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN billing b ON b.patient_id = p.patient_id
WHERE a.discharged_at IS NOT NULL
  AND DATEDIFF(a.discharged_at, a.admitted_at) > 10;*/
 select* from admissions;
 
-- Task 5. List all available hospital rooms and their current occupancy status.
SELECT r.room_id,r.room_number, r.type, r.total_beds, 
       SUM(CASE WHEN a.discharged_at IS NULL THEN 1 ELSE 0 END) AS occupied_beds,
       r.total_beds - SUM(CASE WHEN a.discharged_at IS NULL THEN 1 ELSE 0 END) AS available_beds
FROM rooms r
LEFT JOIN admissions a ON r.room_id = a.room_id
GROUP BY r.room_id, r.room_number, r.type, r.total_beds; 

-- Task 6. Retrieve the complete medical history of a specific patient, including past illnesses, prescriptions, and treatments.
 
SELECT p.patient_id, p.first_name, p.last_name,
       d.illness, d.diagnosis_date,
       m.medication_name, pr.start_date, pr.end_date,
       t.test_type, t.status AS test_status, t.report_date
FROM patients p
LEFT JOIN diagnoses d ON p.patient_id = d.patient_id
LEFT JOIN prescriptions pr ON p.patient_id = pr.patient_id
LEFT JOIN medications m ON pr.medication_id = m.medication_id
LEFT JOIN tests t ON p.patient_id = t.patient_id
WHERE p.patient_id = '5';

-- Task 7. Find all emergency room visits in the last month, along with reasons for admission and attending doctors.
 
SELECT e.admission_id, p.first_name, p.last_name, e.admitted_at, concat(s.first_name,' ', s.last_name)AS doctor
FROM admissions e
JOIN patients p ON e.patient_id = p.patient_id
JOIN staff s ON e.doctor_id = s.staff_id
WHERE s.department = 'Emergency'
AND e.admitted_at <= CURRENT_DATE - INTERVAL 1 month;
  
  
-- Task 8. List all patients who have been prescribed 'Amoxicillin' in the past three months.
 
SELECT DISTINCT p.patient_id, p.first_name, p.last_name
FROM prescriptions pr
JOIN medications m ON pr.medication_id = m.medication_id
JOIN patients p ON pr.patient_id = p.patient_id
WHERE m.medication_name LIKE 'Amoxicillin'
AND pr.start_date >= CURRENT_DATE - INTERVAL 3 month;
  
-- Task 9. Retrieve all pending medical test reports, including the test type and expected report delivery date.
 
SELECT 
    t.test_id,
    p.first_name,
    p.last_name,
    t.test_type,
    t.ordered_date,
    t.expected_report_date
FROM tests t
JOIN patients p ON t.patient_id = p.patient_id
WHERE t.status = 'Pending';

-- Task 10. Identify the department with the highest number of patient admissions in the past year.
 
SELECT s.department, COUNT(*) AS admission_count
FROM admissions a
JOIN staff s ON a.doctor_id = s.staff_id
WHERE a.admitted_at >= CURRENT_DATE - INTERVAL 1 year
GROUP BY s.department
ORDER BY admission_count DESC limit 1;
-- or if there’s a tie then the below one his will return multiple rows
/*SELECT s.department, COUNT(*) AS admission_count
FROM admissions a
JOIN staff s ON a.doctor_id = s.staff_id
WHERE a.admitted_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY s.department
HAVING COUNT(*) = (
    SELECT MAX(dept_count)
    FROM (
        SELECT COUNT(*) AS dept_count
        FROM admissions a
        JOIN staff s ON a.doctor_id = s.staff_id
        WHERE a.admitted_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
        GROUP BY s.department
    ) sub
);*/

-- Task 11. Patients who visited multiple doctors for the same illness
 INSERT INTO diagnoses (patient_id, doctor_id, illness, diagnosis_date) VALUES
(1, 2, 'Hypertension', '2025-08-25'),  -- Aarav sees a 2nd doctor Dr Asha for Hypertention
(3, 4, 'Fractured Arm', '2025-08-12'); -- Kabir sees a 2nd doctor

SELECT p.patient_id, p.first_name, p.last_name, d.illness,
COUNT(DISTINCT d.doctor_id) AS doctor_count
FROM diagnoses d
JOIN patients p ON d.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name, d.illness
HAVING COUNT(DISTINCT d.doctor_id) > 1;


-- Task 12. List all staff members working in the 'Cardiology' department, along with their roles and shift timings.
ALTER TABLE staff ADD COLUMN shift_time VARCHAR(20) CHECK (shift_time IN ('Morning', 'Evening', 'Night')) DEFAULT 'Morning';
UPDATE staff SET shift_time='Morning' WHERE staff_id IN (1,6,9);
UPDATE staff SET shift_time='Evening' WHERE staff_id IN (2,7,10);
UPDATE staff SET shift_time='Night'   WHERE staff_id IN (3,4,5,8);

SELECT staff_id, first_name, last_name, role, department, shift_time
FROM staff
WHERE department = 'Cardiology';

-- Task 13. Find the number of surgeries performed in the last six months, categorized by type of surgery.
INSERT INTO diagnoses (patient_id, doctor_id, illness, diagnosis_date) VALUES
(7,3,'Knee Surgery','2025-08-01'),
(3,3,'Arm Surgery','2025-08-12')
ON DUPLICATE KEY UPDATE diagnosis_date=VALUES(diagnosis_date);

SELECT d.illness AS surgery_type, COUNT(*) AS surgery_count
FROM diagnoses d
WHERE d.illness LIKE '%surgery%'
AND d.diagnosis_date >= CURRENT_DATE - INTERVAL 6 month GROUP BY d.illness;

-- Task 14. Retrieve a report of all prescriptions issued by a specific doctor within a given date range.
 
SELECT pr.prescription_id, m.medication_name,CONCAT(p.first_name,' ',p.last_name) AS patient_name, pr.start_date
FROM prescriptions pr
JOIN medications m ON pr.medication_id = m.medication_id
JOIN patients p ON pr.patient_id = p.patient_id
WHERE pr.doctor_id = (SELECT staff_id FROM staff WHERE first_name='Asha' AND last_name='Verma')
  AND pr.start_date BETWEEN '2025-01-01' AND '2025-09-08';
  
-- Task 15. Identify the most commonly diagnosed illness based on patient records.
SELECT illness, COUNT(*) AS frequency
FROM diagnoses
GROUP BY illness
ORDER BY frequency DESC
LIMIT 1;

-- Task 16. Generate a report showing hospital revenue generated from outpatient consultations, surgeries, and diagnostic tests.
 
SELECT SUM(total_amount) AS total_revenue FROM billing;
-- or to know how much is pending 
/*SELECT
  SUM(total_amount) AS total_revenue,
  SUM(CASE WHEN paid_amount>0 THEN paid_amount ELSE 0 END) AS collected_amount,
  SUM(total_amount - paid_amount) AS outstanding
FROM billing;*/

-- Task 17. Ensure that when a patient is discharged, their final bill is updated correctly, including consultation fees, treatment costs, and room charges.
 
DELIMITER $$
CREATE TRIGGER update_final_bill_on_discharge
AFTER UPDATE ON admissions
FOR EACH ROW
BEGIN
   DECLARE stay_days INT;
  IF NEW.discharged_at IS NOT NULL THEN   
    SET stay_days = DATEDIFF(NEW.discharged_at, NEW.admitted_at);
    UPDATE billing
    SET total_amount = total_amount + (stay_days * 1000)  -- Example: ₹1000/day room charge
    WHERE patient_id = NEW.patient_id;
  END IF;
END$$
DELIMITER ;
-- or 
/* DELIMITER $$
DROP TRIGGER IF EXISTS update_final_bill_on_discharge $$
CREATE TRIGGER update_final_bill_on_discharge
AFTER UPDATE ON admissions
FOR EACH ROW
BEGIN
  IF NEW.discharged_at IS NOT NULL AND (OLD.discharged_at IS NULL OR OLD.discharged_at<>NEW.discharged_at) THEN
    UPDATE billing
    SET total_amount = total_amount + (GREATEST(DATEDIFF(NEW.discharged_at, NEW.admitted_at),0) * 1000)
    WHERE patient_id = NEW.patient_id;
  END IF;
END $$
DELIMITER ;*/

select * from admissions;
select * from billing;

UPDATE admissions
SET discharged_at = '2025-08-25'
WHERE patient_id = 1;
SELECT * FROM billing WHERE patient_id = 1;

-- Task 18. Automatically notify doctors if a critical patient's vital signs drop below a safe threshold.
 
 DELIMITER $$
CREATE TRIGGER alert_critical_vitals
AFTER INSERT ON vitals
FOR EACH ROW
BEGIN
  IF NEW.heart_rate < 40 OR NEW.bp_systolic < 80 THEN
    INSERT INTO alerts (patient_id, alert_message, created_at)
    VALUES (NEW.patient_id, 'Critical vitals! Notify doctor immediately.', NOW());
  END IF;
END$$
DELIMITER ;
DESC vitals;
DESC alerts;
INSERT INTO vitals (patient_id, heart_rate, bp_systolic, bp_diastolic, recorded_at)
VALUES (1, 75, 120, 80, NOW());
SELECT * FROM alerts WHERE patient_id = 1;
INSERT INTO vitals (patient_id, heart_rate, bp_systolic, bp_diastolic, recorded_at)
VALUES (1, 35, 70, 50, NOW());
SELECT * FROM alerts WHERE patient_id = 1;

-- Task 19. Ensure that no duplicate patient records are created when registering a new patient.
ALTER TABLE patients
  ADD UNIQUE KEY uniq_patient_name_dob (first_name, last_name, dob);
desc patients;

-- Task 20. Update room availability immediately when a patient is admitted or discharged.
 -- When a patient is admitted - mark room unavailable
DELIMITER $$
CREATE TRIGGER update_room_status_on_admit
AFTER INSERT ON admissions
FOR EACH ROW
BEGIN
  UPDATE rooms
  SET is_available = FALSE
  WHERE room_id = NEW.room_id;
END$$
DELIMITER ;
-- When discharged - mark room available again
DELIMITER $$
CREATE TRIGGER update_room_status_on_discharge
AFTER UPDATE ON admissions
FOR EACH ROW
BEGIN
  IF NEW.discharged_at IS NOT NULL THEN
    UPDATE rooms
    SET is_available = TRUE
    WHERE room_id = NEW.room_id;
  END IF;
END$$
DELIMITER ;
DESC admissions;
DESC rooms;

INSERT INTO rooms (room_id,room_number,total_beds, is_available)
VALUES (101,305,3, FALSE);
INSERT INTO admissions (doctor_id,patient_id, room_id, admitted_at)
VALUES (2,1, 101, '2025-09-15');

select* from admissions;
UPDATE admissions
SET discharged_at = '2025-09-19'
WHERE patient_id = 1 AND room_id = 101;
SELECT * FROM rooms WHERE room_id = 101;


-- Task 21.Verify that all prescribed medications are available in the pharmacy before issuing them to a patient.

 DELIMITER $$
CREATE TRIGGER check_medication_stock
BEFORE INSERT ON prescriptions
FOR EACH ROW
BEGIN
  DECLARE stock INT;
  SELECT stock_qty INTO stock
  FROM pharmacy_inventory
  WHERE medication_id = NEW.medication_id;

  IF stock IS NULL OR stock <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Medication not available in stock!';
  END IF;
END$$
alter table prescriptions add prescribed_at time;
INSERT INTO pharmacy_inventory (medication_id, stock_qty)
VALUES (1, 10), (2, 0);
select * from pharmacy_inventory;
INSERT INTO prescriptions (doctor_id,patient_id, medication_id, dosage, prescribed_at)
VALUES (5,102, 2, '1 tablet daily', NOW());
desc prescriptions;
-- Task 22. Ensure that only authorized hospital staff can modify or delete sensitive patient records.
 -- Create role

CREATE ROLE IF NOT EXISTS medical_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON patients To 'guest_user'@'localhost' ;
REVOKE UPDATE, DELETE ON hospital.patients FROM 'guest_user'@'localhost';


-- REVOKE dangerous rights from a guest account, if it exists:
-- REVOKE UPDATE, DELETE ON hospital.patients FROM 'guest_user'@'localhost';

 -- Task 23. Create an alert if a patient misses a scheduled follow-up appointment.
SET GLOBAL event_scheduler=ON;
DELIMITER $$
CREATE EVENT missed_followup_alert
ON SCHEDULE EVERY 1 day
DO
  INSERT INTO alerts (patient_id, alert_message, created_at)
  SELECT a.patient_id, 'Missed follow-up appointment', NOW()
  FROM appointments a
  WHERE a.status = 'Scheduled'
    AND a.appointment_date < CURDATE();
END $$
DELIMITER ;

SET GLOBAL event_scheduler=ON;

DELIMITER $$
CREATE EVENT missed_followup_alert
ON SCHEDULE EVERY 1 DAY
DO
  INSERT INTO alerts (patient_id, alert_message, created_at)
  SELECT a.patient_id, 'Missed follow-up appointment', NOW()
  FROM appointments a
  WHERE a.status = 'Scheduled'
    AND a.appointment_date < CURDATE();
$$
DELIMITER ;


SHOW VARIABLES LIKE 'event_scheduler';
INSERT INTO alerts (patient_id, alert_message, created_at)
SELECT a.patient_id, 'Missed follow-up appointment', NOW()
FROM appointments a
WHERE a.status = 'Scheduled'
  AND a.appointment_date < CURDATE();
SELECT * FROM alerts;
ALTER EVENT missed_followup_alert
ON SCHEDULE EVERY 1 MINUTE;
select * from alerts;
-- Task 24.Automatically update hospital inventory when new medical supplies are received or used.
-- After prescription issued
DELIMITER $$
CREATE TRIGGER update_inventory_on_usage
AFTER INSERT ON prescriptions
FOR EACH ROW
BEGIN
  UPDATE pharmacy_inventory
  SET stock_qty = stock_qty - 1
  WHERE medication_id = NEW.medication_id;
END$$
DELIMITER ;

-- After receiving supply order
DELIMITER $$
CREATE TRIGGER update_inventory_on_receipt
AFTER INSERT ON supply_orders
FOR EACH ROW
BEGIN
  UPDATE pharmacy_inventory
  SET stock_qty = stock_qty + NEW.quantity
  WHERE medication_id = NEW.medication_id;
END$$
DELIMITER ;
-- or
DELIMITER $$
CREATE TRIGGER update_inventory_on_receipt
AFTER INSERT ON supply_orders
FOR EACH ROW
BEGIN
  INSERT INTO pharmacy_inventory (medication_id, stock_qty)
  VALUES (NEW.medication_id, NEW.quantity)
  ON DUPLICATE KEY UPDATE stock_qty = stock_qty + NEW.quantity;
END $$
DELIMITER ;
INSERT INTO supply_orders ( medication_id, quantity, order_date)
VALUES ( 101, 50, NOW());
desc supply_orders;
SELECT * FROM pharmacy_inventory WHERE medication_id = 10;
-- Task 25. Generate a monthly report summarizing patient admissions,treatments, and medical trends.
CREATE VIEW monthly_patient_report AS
SELECT 
  DATE_FORMAT(admitted_at, '%Y-%m') AS month,
  COUNT(DISTINCT patient_id) AS total_patients,
  COUNT(DISTINCT doctor_id) AS total_doctors,
  COUNT(admission_id) AS total_admissions
FROM admissions
GROUP BY month
ORDER BY month DESC;
SELECT * FROM monthly_patient_report ORDER BY month DESC;
-- Task 26. Ensure that when a patient is discharged, their final bill is updated correctly, including consultation fees, treatment costs, and room charges.
 
DELIMITER $$
CREATE TRIGGER trg_update_final_bill
AFTER UPDATE ON admissions
FOR EACH ROW
BEGIN
    IF NEW.discharged_at IS NOT NULL THEN
        UPDATE billing
        SET total_amount = total_amount 
            + (SELECT total_beds * 1000 FROM rooms WHERE room_id = NEW.room_id)
        WHERE patient_id = NEW.patient_id;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_update_final_bill
AFTER UPDATE ON admissions
FOR EACH ROW
BEGIN
    IF NEW.discharged_at IS NOT NULL THEN
        UPDATE billing
        SET total_amount = total_amount 
            + ((SELECT total_beds FROM rooms WHERE room_id = NEW.room_id) * 1000)
        WHERE patient_id = NEW.patient_id;
    END IF;
END $$
DELIMITER ;

-- Add a room
desc rooms;
INSERT INTO rooms (room_id,  total_beds)
VALUES (101, 2);

-- Admit a patient
INSERT INTO admissions (admission_id, patient_id, room_id, admitted_at)
VALUES (1, 1, 101, '2025-09-15');

-- Initialize billing
INSERT INTO billing (patient_id, total_amount)
VALUES (1, 0);
UPDATE admissions
SET discharged_at = '2025-09-18'
WHERE admission_id = 1;

SELECT * FROM billing WHERE patient_id = 1;

 
 desc patients;
