-- Active: 1729699485027@@127.0.0.1@3306@project

UPDATE FactMedicalMeasurements
SET Age = Age / 365.0;

SELECT id, Age, Sex, Bilirubin, Cholesterol, Albumin, Copper
FROM FactMedicalMeasurements;


SELECT 
    d.drug,
    COUNT(f.id) AS num_patients
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    d.drug;

SELECT 
    d.status,
    AVG(f.Bilirubin) AS avg_bilirubin
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    d.status;

SELECT 
    f.id,
    f.Age,
    f.Sex,
    f.Cholesterol,
    d.drug,
    d.stage
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
WHERE 
    f.Cholesterol > 200
    AND d.drug = 'Placebo';  -- Replace 'DrugName' with the specific drug you want to filter

SELECT 
    d.stage,
    COUNT(f.id) AS num_patients
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    d.stage;

SELECT 
    d.drug,
    MAX(f.Age) AS max_age,
    MIN(f.Age) AS min_age,
    AVG(f.Age) AS avg_age
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    d.drug;

SELECT 
    f.id,
    f.Age,
    f.Sex,
    f.Edema,
    f.Spiders,
    d.drug,
    d.stage
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
WHERE 
    f.Edema = 'Yes' 
    AND f.Spiders = 'Yes';

SELECT 
    f.id,
    f.Age,
    f.Sex,
    f.Albumin,
    d.drug
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
WHERE 
    f.Albumin < 3.5;

SELECT 
    f.Sex,
    AVG(f.Bilirubin) AS avg_bilirubin,
    AVG(f.Cholesterol) AS avg_cholesterol,
    AVG(f.Albumin) AS avg_albumin,
    AVG(f.Copper) AS avg_copper
FROM 
    FactMedicalMeasurements f
GROUP BY 
    f.Sex;


SELECT 
    f.id,
    f.N_days,
    f.Age,
    f.Sex,
    d.drug,
    d.stage,
    d.status
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
ORDER BY 
    f.N_days DESC
LIMIT 1;

SELECT 
    CASE 
        WHEN f.Age BETWEEN 0 AND 20 THEN '0-20'
        WHEN f.Age BETWEEN 21 AND 40 THEN '21-40'
        WHEN f.Age BETWEEN 41 AND 60 THEN '41-60'
        WHEN f.Age > 60 THEN '60+'
    END AS age_range,
    COUNT(f.id) AS num_patients
FROM 
    FactMedicalMeasurements f
GROUP BY 
    age_range;

SELECT 
    f.id,
    f.Copper,
    f.Age,
    f.Sex,
    d.drug,
    d.stage
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
ORDER BY 
    f.Copper DESC
LIMIT 5;

SELECT 
    f.id,
    f.Bilirubin,
    f.Albumin,
    f.Age,
    f.Sex,
    d.drug,
    d.stage
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
WHERE 
    f.Bilirubin > 2 
    AND f.Albumin < 3.5;

SELECT 
    f.Sex,
    d.stage,
    COUNT(f.id) AS num_patients
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    f.Sex, d.stage;

SELECT 
    d.drug,
    d.stage,
    AVG(f.Bilirubin) AS avg_bilirubin,
    AVG(f.Cholesterol) AS avg_cholesterol,
    AVG(f.Albumin) AS avg_albumin,
    AVG(f.Copper) AS avg_copper
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    d.drug, d.stage;

SELECT 
    f.id,
    f.N_days,
    f.Age,
    f.Sex,
    d.drug,
    d.stage,
    d.status
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
ORDER BY 
    f.N_days DESC
LIMIT 10;

SELECT 
    CASE 
        WHEN f.Age BETWEEN 0 AND 20 THEN '0-20'
        WHEN f.Age BETWEEN 21 AND 40 THEN '21-40'
        WHEN f.Age BETWEEN 41 AND 60 THEN '41-60'
        WHEN f.Age > 60 THEN '60+'
    END AS age_range,
    AVG(f.Bilirubin) AS avg_bilirubin,
    AVG(f.Cholesterol) AS avg_cholesterol,
    AVG(f.Albumin) AS avg_albumin,
    AVG(f.Copper) AS avg_copper
FROM 
    FactMedicalMeasurements f
GROUP BY 
    age_range;

SELECT 
    d.stage,
    d.status,
    COUNT(f.id) AS num_patients
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id
GROUP BY 
    d.stage, d.status;

SELECT
    SUM(f.measurement_id = 'N') AS measurement_id_N_count,
    SUM(f.id = 'N') AS id_N_count,
    SUM(f.N_days = 'N') AS N_days_N_count,
    SUM(f.Age = 'N') AS Age_N_count,
    SUM(f.Sex = 'N') AS Sex_N_count,
    SUM(f.Ascites = 'N') AS Ascites_N_count,
    SUM(f.Hepatomegaly = 'N') AS Hepatomegaly_N_count,
    SUM(f.Spiders = 'N') AS Spiders_N_count,
    SUM(f.Edema = 'N') AS Edema_N_count,
    SUM(f.Bilirubin = 'N') AS Bilirubin_N_count,
    SUM(f.Cholesterol = 'N') AS Cholesterol_N_count,
    SUM(f.Albumin = 'N') AS Albumin_N_count,
    SUM(f.Copper = 'N') AS Copper_N_count,
    SUM(f.Alk_Phos = 'N') AS Alk_Phos_N_count,
    SUM(f.SGOT = 'N') AS SGOT_N_count,
    SUM(f.Tryglicerides = 'N') AS Tryglicerides_N_count,
    SUM(f.Platelets = 'N') AS Platelets_N_count,
    SUM(f.Prothrombin = 'N') AS Prothrombin_N_count,
    SUM(d.drug = 'N') AS drug_N_count,
    SUM(d.stage = 'N') AS stage_N_count,
    SUM(d.status = 'N') AS status_N_count
FROM
    FactMedicalMeasurements f
JOIN
    DimPatient d
ON
    f.id = d.id;


