-- Active: 1729699485027@@127.0.0.1@3306@project
USE project;
CREATE TABLE DimPatient (
    id INT PRIMARY KEY,  -- Links to the 'id' from both CSVs
    drug VARCHAR(100),   -- Drug information (descriptive data)
    stage INT,           -- Patient stage (descriptive data)
    status VARCHAR(10)   -- Patient status (descriptive data)
);

CREATE TABLE FactMedicalMeasurements (
    measurement_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique measurement ID
    id INT,  -- Links to the patient 'id' in DimPatient
    N_days INT,  -- Number of days (fact)
    Age INT,     -- Age of the patient (can be fact or dimension based on your requirement)
    Sex VARCHAR(10),  -- Gender of the patient
    Ascites VARCHAR(10),
    Hepatomegaly VARCHAR(10),
    Spiders VARCHAR(10),
    Edema VARCHAR(10),
    Bilirubin FLOAT,
    Cholesterol INT,
    Albumin FLOAT,
    Copper INT,
    Alk_Phos FLOAT,
    SGOT FLOAT,
    Tryglicerides INT,
    Platelets INT,
    Prothrombin FLOAT,
    CONSTRAINT fk_patient FOREIGN KEY (id) REFERENCES DimPatient(id)
);

SELECT * FROM DimPatient limit 10 ;
SELECT * FROM FactMedicalMeasurements LIMIT 10;



-- Add Foreign Key Constraint to link FactMedicalMeasurements to DimPatient
ALTER TABLE FactMedicalMeasurements
ADD CONSTRAINT fk_patient_id
FOREIGN KEY (id)
REFERENCES DimPatient(id);

-- Example query to fetch data by joining Fact and Dimension tables
-- Query to fetch all columns from both FactMedicalMeasurements and DimPatient tables
SELECT 
    f.measurement_id,
    f.id,               -- Links to DimPatient (Foreign Key)
    f.N_days,           -- Number of days (fact)
    f.Age,              -- Age of the patient
    f.Sex,              -- Gender of the patient
    f.Ascites,          -- Ascites value
    f.Hepatomegaly,     -- Hepatomegaly value
    f.Spiders,          -- Spiders value
    f.Edema,            -- Edema value
    f.Bilirubin,        -- Bilirubin value
    f.Cholesterol,      -- Cholesterol value
    f.Albumin,          -- Albumin value
    f.Copper,           -- Copper value
    d.drug,             -- Drug information (descriptive data)
    d.stage,            -- Patient stage (descriptive data)
    d.status            -- Patient status (descriptive data)
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id;


